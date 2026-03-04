import 'package:catotinder/src/domain/analytics_service.dart';
import 'package:dio_http/dio_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Реализация клиента аналитики для отправки на свой сервер
class CustomAnalyticsService implements AnalyticsService {
  final Dio _client;
  static const String _deviceIdKey = 'analytics_device_id';

  CustomAnalyticsService({required Dio client}) : _client = client {
    _initializeDeviceId();
  }

  String? _deviceId;

  /// Инициализация deviceId (анонимный идентификатор устройства)
  Future<void> _initializeDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _deviceId = prefs.getString(_deviceIdKey);

      if (_deviceId == null) {
        _deviceId = _generateDeviceId();
        await prefs.setString(_deviceIdKey, _deviceId!);
      }
    } catch (e) {
      _deviceId = _generateDeviceId();
    }
  }

  String _generateDeviceId() {
    return 'device_${DateTime.now().millisecondsSinceEpoch}_${_randomString(8)}';
  }

  String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
      length,
      (index) => chars[DateTime.now().microsecond % chars.length],
    ).join();
  }

  @override
  Future<bool> trackEvent({
    required String eventName,
    required Map<String, dynamic> data,
  }) async {
    final res = await _client.post(
      '/api/analytics',
      data: <String, dynamic>{'event': eventName, 'data': data},
    );

    return res.statusCode == 200;
  }
}
