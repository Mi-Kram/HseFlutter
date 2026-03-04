abstract class AuthService {
  /// Регистрация пользователя.
  /// Возвращает выданный api_key.
  Future<String> signUp({required String email, required String password});

  /// Вход пользователя.
  /// Возвращает выданный api_key.
  Future<String> signIn({required String email, required String password});
}
