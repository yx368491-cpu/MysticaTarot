import 'package:flutter/material.dart';
import 'app_colors.dart';

/// MysticaTarot Text Styles
/// Using Playfair Display for English/Tagalog and Noto Serif SC for Chinese
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Mystical / decorative text
  static const TextStyle mysticalTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.rosePink,
    letterSpacing: 1.5,
  );

  static const TextStyle mysticalSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.softPurple,
    letterSpacing: 2.0,
  );

  // Gold accent text
  static const TextStyle goldHeading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
    letterSpacing: 0.5,
  );

  static const TextStyle goldBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.goldLight,
    height: 1.5,
  );

  // Card text
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Button
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // On dark backgrounds
  static const TextStyle onDarkLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnDark,
  );

  static const TextStyle onDarkBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textOnDark,
    height: 1.5,
  );

  static const TextStyle onDarkGold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textGold,
  );
}
