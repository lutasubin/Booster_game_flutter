import 'package:firebase_analytics/firebase_analytics.dart';

/// Lớp hỗ trợ Firebase Analytics để theo dõi sự kiện trong ứng dụng.
class AnalyticsHelper {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Lấy instance của FirebaseAnalytics
  static FirebaseAnalytics get instance => _analytics;

  
  /// Ghi nhận sự kiện khi người dùng mở ứng dụng
  static Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

   /// Ghi nhận sự kiện khi người dùng thay đổi cài đặt
  static Future<void> logSettingChange(String settingName, String value) async {
    await _analytics.logEvent(
      name: 'setting_change',
      parameters: {
        'setting_name': settingName,
        'value': value,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  

 

   
}