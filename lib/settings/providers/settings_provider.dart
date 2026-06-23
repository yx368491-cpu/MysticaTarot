import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/sound_utils.dart';

/// Settings provider for managing app preferences
class SettingsProvider extends ChangeNotifier {
  late Box _settingsBox;

  String _locale = AppConstants.defaultLocale;
  bool _dailyNotification = AppConstants.defaultDailyNotification;
  String _notificationTime = AppConstants.defaultNotificationTime;
  bool _soundEnabled = AppConstants.defaultSoundEnabled;
  int _maxHistoryCount = AppConstants.maxHistoryCount;
  String _cardBackStyle = AppConstants.defaultCardBack;
  ThemeMode _themeMode = ThemeMode.system;

  // Getters
  String get locale => _locale;
  bool get dailyNotification => _dailyNotification;
  String get notificationTime => _notificationTime;
  bool get soundEnabled => _soundEnabled;
  int get maxHistoryCount => _maxHistoryCount;
  String get cardBackStyle => _cardBackStyle;
  ThemeMode get themeMode => _themeMode;

  /// Initialize settings from Hive
  Future<void> init() async {
    _settingsBox = Hive.box('settings');

    _locale = _settingsBox.get('locale', defaultValue: AppConstants.defaultLocale);
    _dailyNotification = _settingsBox.get('dailyNotification',
        defaultValue: AppConstants.defaultDailyNotification);
    _notificationTime = _settingsBox.get('notificationTime',
        defaultValue: AppConstants.defaultNotificationTime);
    _soundEnabled = _settingsBox.get('soundEnabled',
        defaultValue: AppConstants.defaultSoundEnabled);
    _maxHistoryCount = _settingsBox.get('maxHistoryCount',
        defaultValue: AppConstants.maxHistoryCount);
    _cardBackStyle = _settingsBox.get('cardBackStyle',
        defaultValue: AppConstants.defaultCardBack);
    final themeModeStr = _settingsBox.get('themeMode', defaultValue: 'system');
    _themeMode = _parseThemeMode(themeModeStr);

    // Sync sound enabled state to SoundUtils
    SoundUtils.setEnabled(_soundEnabled);

    notifyListeners();
  }

  /// Set locale
  Future<void> setLocale(String locale) async {
    _locale = locale;
    await _settingsBox.put('locale', locale);
    notifyListeners();
  }

  /// Set daily notification
  Future<void> setDailyNotification(bool value) async {
    _dailyNotification = value;
    await _settingsBox.put('dailyNotification', value);
    notifyListeners();
  }

  /// Set notification time
  Future<void> setNotificationTime(String time) async {
    _notificationTime = time;
    await _settingsBox.put('notificationTime', time);
    notifyListeners();
  }

  /// Set sound enabled
  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _settingsBox.put('soundEnabled', value);
    SoundUtils.setEnabled(value);
    notifyListeners();
  }

  /// Set max history count
  Future<void> setMaxHistoryCount(int count) async {
    _maxHistoryCount = count;
    await _settingsBox.put('maxHistoryCount', count);
    notifyListeners();
  }

  /// Set card back style
  Future<void> setCardBackStyle(String style) async {
    _cardBackStyle = style;
    await _settingsBox.put('cardBackStyle', style);
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _settingsBox.put('themeMode', _themeModeToString(mode));
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
