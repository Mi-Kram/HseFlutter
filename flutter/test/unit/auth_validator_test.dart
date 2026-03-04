import 'package:catotinder/src/domain/auth/auth_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidator', () {
    test('email validation: empty/invalid/valid', () {
      expect(AuthValidator.validateEmail(''), 'Введите email');
      expect(AuthValidator.validateEmail('   '), 'Введите email');
      expect(AuthValidator.validateEmail('abc'), 'Некорректный email');
      expect(AuthValidator.validateEmail('a@b'), isNull);
      expect(AuthValidator.validateEmail('  a@b  '), isNull);
    });

    test('password validation: empty/short/valid', () {
      expect(AuthValidator.validatePassword(''), 'Введите пароль');
      expect(
        AuthValidator.validatePassword('12345'),
        'Пароль должен быть не короче 6 символов',
      );
      expect(AuthValidator.validatePassword('123456'), isNull);
    });
  });
}
