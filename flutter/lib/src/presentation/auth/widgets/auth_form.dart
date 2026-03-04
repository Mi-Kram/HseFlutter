import 'package:catotinder/src/domain/auth/auth_service.dart';
import 'package:catotinder/src/domain/auth/auth_validator.dart';
import 'package:dio_http/dio_http.dart';
import 'package:flutter/material.dart';

typedef AuthenticatedCallback = void Function(String apiKey);

class AuthForm extends StatefulWidget {
  final AuthService authService;
  final bool isSignUp;
  final AuthenticatedCallback onAuthenticated;

  const AuthForm({
    super.key,
    required this.authService,
    required this.isSignUp,
    required this.onAuthenticated,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final apiKey = widget.isSignUp
          ? await widget.authService.signUp(email: email, password: password)
          : await widget.authService.signIn(email: email, password: password);

      if (!mounted) return;
      widget.onAuthenticated(apiKey);
    } on DioError catch (e) {
      setState(() {
        var data = e.response?.data as Map<String, dynamic>;
        _errorText = data['error']?.toString() ?? e.message;
      });
    } catch (e) {
      setState(() {
        _errorText = 'Ошибка: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: AuthValidator.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: AuthValidator.validatePassword,
                ),
                const SizedBox(height: 24),
                if (_errorText != null) ...[
                  Text(_errorText!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                ],
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.isSignUp ? 'Зарегистрироваться' : 'Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
