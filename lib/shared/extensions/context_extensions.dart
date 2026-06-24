import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

/// BuildContext extensions for convenience
extension ContextExtensions on BuildContext {
  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get localized strings
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Check if dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Safe area padding
  EdgeInsets get padding => mediaQuery.padding;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => mediaQuery.viewInsets.bottom > 0;

  /// Show snackbar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Primary text color — adapts to dark mode automatically.
  /// Replaces hardcoded [AppColors.textPrimary] which is invisible on
  /// dark surfaces (same color as [AppColors.darkSurface]).
  Color get textPrimary => AppColors.primaryText(this);

  /// Secondary text color — adapts to dark mode automatically.
  Color get textSecondary => AppColors.secondaryText(this);
}
