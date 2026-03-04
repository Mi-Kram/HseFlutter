import 'dart:async';

import 'package:catotinder/src/domain/auth/auth_service.dart';
import 'package:catotinder/src/presentation/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

Widget _wrap(Widget child) => MaterialApp(home: child);

void main() {
  testWidgets('invalid input shows invalid email (sign in)', (tester) async {
    final authService = _MockAuthService();

    await tester.pumpWidget(
      _wrap(
        AuthScreen(
          authService: authService,
          onAuthenticated: (_) {},
          isDark: false,
          onToggleTheme: () {},
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'abc');
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.text('Войти'));
    await tester.pump();

    expect(find.text('Некорректный email'), findsOneWidget);
  });

  testWidgets('invalid input shows invalid password (sign in)', (tester) async {
    final authService = _MockAuthService();

    await tester.pumpWidget(
      _wrap(
        AuthScreen(
          authService: authService,
          onAuthenticated: (_) {},
          isDark: false,
          onToggleTheme: () {},
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'a@b');
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.text('Войти'));
    await tester.pump();

    expect(
      find.text('Пароль должен быть не короче 6 символов'),
      findsOneWidget,
    );
  });

  testWidgets('successful sign in calls onAuthenticated and shows loading', (
    tester,
  ) async {
    final completer = Completer<String>();
    String? receivedKey;

    final authService = _MockAuthService();
    when(
      () => authService.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      _wrap(
        AuthScreen(
          authService: authService,
          onAuthenticated: (k) => receivedKey = k,
          isDark: false,
          onToggleTheme: () {},
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'a@b');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Войти'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete('key-xyz');
    await tester.pumpAndSettle();

    expect(receivedKey, 'key-xyz');
  });
}
