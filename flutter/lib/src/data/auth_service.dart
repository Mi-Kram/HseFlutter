import 'package:catotinder/src/domain/auth/auth_service.dart';
import 'package:dio_http/dio_http.dart';

/// Сервис авторизации: регистрация и вход.
class CustomAuthService implements AuthService {
  final Dio client;

  CustomAuthService({required this.client});

  @override
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    final res = await client.post(
      '/api/sign-up',
      data: <String, dynamic>{'email': email, 'password': password},
    );

    if (res.statusCode != 200) {
      throw DioError(requestOptions: res.requestOptions, response: res);
    }

    final data = res.data as Map<String, dynamic>;
    return data['api_key'] as String;
  }

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final res = await client.post(
      '/api/sign-in',
      data: <String, dynamic>{'email': email, 'password': password},
    );

    if (res.statusCode != 200) {
      throw DioError(requestOptions: res.requestOptions, response: res);
    }

    final data = res.data as Map<String, dynamic>;
    return data['api_key'] as String;
  }
}
