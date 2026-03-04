/// Валидация полей авторизации/регистрации.
class AuthValidator {
  static String? validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return 'Введите email';
    }
    if (!v.contains('@')) {
      return 'Некорректный email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) {
      return 'Введите пароль';
    }
    if (v.length < 6) {
      return 'Пароль должен быть не короче 6 символов';
    }
    return null;
  }
}
