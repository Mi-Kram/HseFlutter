import 'package:catotinder/src/domain/analytics_service.dart';
import 'package:catotinder/src/domain/auth/auth_service.dart';

class LogAuthService implements AuthService {
  final AuthService authService;
  final AnalyticsService analyticsService;

  const LogAuthService({
    required this.authService,
    required this.analyticsService,
  });

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var res = await authService.signIn(email: email, password: password);
      analyticsService.trackEvent(
        eventName: 'sing-in',
        data: {'success': true, 'email': email},
      );
      return res;
    } catch (e) {
      analyticsService.trackEvent(
        eventName: 'sing-in',
        data: {'success': false, 'email': email},
      );
      rethrow;
    }
  }

  @override
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      var res = await authService.signUp(email: email, password: password);
      analyticsService.trackEvent(
        eventName: 'sing-up',
        data: {'success': true, 'email': email},
      );
      return res;
    } catch (e) {
      analyticsService.trackEvent(
        eventName: 'sing-up',
        data: {'success': false, 'email': email},
      );
      rethrow;
    }
  }
}
