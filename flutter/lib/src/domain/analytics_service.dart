/// Интерфейс клиента аналитики
abstract class AnalyticsService {
  Future<bool> trackEvent({
    required String eventName,
    required Map<String, dynamic> data,
  });
}
