/// MysticaTarot Global Constants
class AppConstants {
  AppConstants._();

  /// App Info
  static const String appName = 'MysticaTarot';
  static const String appNameZh = '神秘塔罗';
  static const String packageName = 'com.mystica.tarot';
  static const String version = '0.1.0';

  /// Storage
  static const String boxSettings = 'settings';
  static const String boxReadingHistory = 'reading_history';
  static const String boxDailyCard = 'daily_card';
  static const String boxFavorites = 'favorites';

  /// Notification
  static const String notificationChannelId = 'daily_card_channel';
  static const String notificationChannelName = 'Daily Card Reminder';
  static const String notificationChannelDescription =
      'Reminds you to draw your daily card';
  static const String notificationPayload = 'daily_card';

  /// Feature defaults
  static const int maxHistoryCount = 500;
  static const String defaultLocale = 'en';
  static const String defaultCardBack = 'default';
  static const String defaultNotificationTime = '09:00';
  static const bool defaultSoundEnabled = true;
  static const bool defaultDailyNotification = true;

  /// Animation durations
  static const Duration cardFlipDuration = Duration(milliseconds: 800);
  static const Duration shuffleDuration = Duration(seconds: 4);
  static const Duration cutDuration = Duration(milliseconds: 1500);
  static const Duration cardFlyInDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration buttonPressDuration = Duration(milliseconds: 150);
  static const Duration splashDuration = Duration(seconds: 2);
}
