import 'package:catotinder/src/data/auth_service.dart';
import 'package:dio_http/dio_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  group('AuthService', () {
    test('signIn returns api_key on 200', () async {
      final dio = _MockDio();
      final svc = CustomAuthService(client: dio);

      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: '/api/sign-in'),
          statusCode: 200,
          data: <String, dynamic>{'api_key': 'k'},
        ),
      );

      final key = await svc.signIn(email: 'a@b', password: '123456');
      expect(key, 'k');
    });

    test('signUp throws DioError on non-200', () async {
      final dio = _MockDio();
      final svc = CustomAuthService(client: dio);

      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: '/api/sign-up'),
          statusCode: 400,
          data: <String, dynamic>{'error': 'bad'},
        ),
      );

      expect(
        () => svc.signUp(email: 'a@b', password: '123456'),
        throwsA(isA<DioError>()),
      );
    });
  });
}
