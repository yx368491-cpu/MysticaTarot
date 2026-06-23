import 'package:flutter/material.dart';

/// Supported locales configuration
class SupportedLocales {
  SupportedLocales._();

  static const List<Locale> locales = [
    Locale('en', 'US'),
    Locale('zh', 'CN'),
    Locale('tl', 'PH'),
  ];

  static const Map<String, String> localeNames = {
    'en': 'English',
    'zh': '简体中文',
    'tl': 'Tagalog',
  };

  static const Map<String, String> localeNamesLocalized = {
    'en': 'English',
    'zh': '简体中文',
    'tl': 'Tagalog',
  };

  /// Get display name in the locale's own language
  static String getLocalizedName(String languageCode) {
    return localeNamesLocalized[languageCode] ?? languageCode;
  }

  /// Get display name in English
  static String getEnglishName(String languageCode) {
    return localeNames[languageCode] ?? languageCode;
  }
}
