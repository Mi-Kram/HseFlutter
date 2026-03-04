import 'package:catotinder/src/domain/auth/auth_service.dart';
import 'package:catotinder/src/presentation/auth/widgets/auth_form.dart';
import 'package:flutter/material.dart';

typedef AuthenticatedCallback = void Function(String apiKey);

/// Экран авторизации: вкладки "Вход" и "Регистрация".
class AuthScreen extends StatelessWidget {
  final AuthService _authService;
  final AuthenticatedCallback _onAuthenticated;

  final VoidCallback _onToggleTheme;
  final bool _isDark;

  const AuthScreen({
    super.key,
    required AuthService authService,
    required AuthenticatedCallback onAuthenticated,
    required bool isDark,
    required VoidCallback onToggleTheme,
  }) : _authService = authService,
       _onAuthenticated = onAuthenticated,
       _isDark = isDark,
       _onToggleTheme = onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Авторизация'),
          actions: [
            IconButton(
              icon: Icon(_isDark ? Icons.dark_mode : Icons.light_mode),
              onPressed: _onToggleTheme,
              tooltip: 'Сменить тему',
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Вход'),
              Tab(text: 'Регистрация'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AuthForm(
              key: const ValueKey('sign_in_form'),
              authService: _authService,
              isSignUp: false,
              onAuthenticated: _onAuthenticated,
            ),
            AuthForm(
              key: const ValueKey('sign_up_form'),
              authService: _authService,
              isSignUp: true,
              onAuthenticated: _onAuthenticated,
            ),
          ],
        ),
      ),
    );
  }
}
