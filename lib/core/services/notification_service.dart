import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_constants.dart';

/// Service for local notifications (daily card reminders)
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Initialize notification plugin
  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// Schedule daily card reminder notification
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? title,
    String? body,
  }) async {
    await _plugin.cancelAll();

    // Create Android notification channel
    const androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Schedule daily at the specified time
    await _plugin.periodicallyShow(
      0, // ID
      title ?? 'Daily Card Reminder',
      body ?? 'Your daily tarot card is waiting for you.',
      RepeatInterval.daily,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

    );
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Cancel specific notification
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
