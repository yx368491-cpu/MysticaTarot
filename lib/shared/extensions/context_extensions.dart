import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

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
}
