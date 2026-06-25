import 'package:flutter/material.dart';

/// MysticaTarot Color Palette
/// Dreamy Magical theme with rose pink primary
class AppColors {
  AppColors._();

  // Primary - Rose Pink
  static const Color rosePink = Color(0xFFE8A0B4);
  static const Color rosePinkLight = Color(0xFFF5C6D4);
  static const Color rosePinkDark = Color(0xFFC47A8F);

  // Secondary - Soft Purple
  static const Color softPurple = Color(0xFFC9B1D0);
  static const Color softPurpleLight = Color(0xFFE1D0E6);
  static const Color softPurpleDark = Color(0xFFA88AB0);

  // Accent - Moon Blue
  static const Color moonBlue = Color(0xFFA8C5DA);
  static const Color moonBlueLight = Color(0xFFCDE0EF);
  static const Color moonBlueDark = Color(0xFF7FA3BF);

  // Gold accent
  static const Color gold = Color(0xFFE8C87A);
  static const Color goldLight = Color(0xFFF2DFA8);
  static const Color goldDark = Color(0xFFD4AD4A);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF1A1025);
  static const Color darkSurface = Color(0xFF2D1B3E);
  static const Color darkBottomNav = Color(0xFF231030);

  // Light theme colors
  static const Color lightBackground = Color(0xFFFDF2F5);
  static const Color lightSurface = Color(0xFFFFF5F8);
  static const Color lightCard = Color(0xB3FFFFFF);

  // Text colors — light mode
  static const Color textPrimary = Color(0xFF2D1B3E);
  static const Color textSecondary = Color(0xFF6B5B7B);

  // Text colors — dark mode (high contrast on darkSurface #2D1B3E)
  static const Color textPrimaryDark = Color(0xFFF5EAF0);
  static const Color textSecondaryDark = Color(0xFFC9B1D0);

  // Deprecated: use textPrimaryDark / textSecondaryDark instead
  static const Color textOnDark = Color(0xFFF5EAF0);
  static const Color textGold = Color(0xFFE8C87A);

  /// Returns the appropriate primary text color for the given brightness.
  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textPrimaryDark
        : textPrimary;
  }

  /// Returns the appropriate secondary text color for the given brightness.
  static Color secondaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textSecondaryDark
        : textSecondary;
  }

  // Semantic colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA000);
}
