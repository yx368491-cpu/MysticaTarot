import 'package:flutter/material.dart';

/// App router configuration
class AppRouter {
  AppRouter._();

  // Route names
  static const String home = '/';
  static const String tarotHome = '/tarot';
  static const String spreadSelection = '/tarot/select-spread';
  static const String cardDraw = '/tarot/draw';
  static const String readingResult = '/tarot/result';
  static const String astrology = '/astrology';
  static const String astrologyDetail = '/astrology/detail';
  static const String numerology = '/numerology';
  static const String numerologyDetail = '/numerology/detail';
  static const String fortuneSlip = '/fortune-slip';
  static const String oracleCards = '/oracle-cards';
  static const String oracleResult = '/oracle-cards/result';
  static const String dailyCard = '/daily-card';
  static const String history = '/history';
  static const String readingDetail = '/history/detail';
  static const String settings = '/settings';
  static const String about = '/settings/about';
  static const String onboarding = '/onboarding';

  /// Generate routes
  static Route<dynamic>? generateRoute(RouteSettings routeSettings) {
    // Routes will be implemented in Phase 2-5
    return null;
  }
}
