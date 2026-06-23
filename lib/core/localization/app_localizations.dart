import 'package:flutter/material.dart';
import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';
import 'app_localizations_tl.dart';

/// AppLocalizations for multi-language support
class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale) {
    _localizedStrings = _getTranslations(locale.languageCode);
  }

  /// Delegate for Flutter's localization system
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Map<String, String> _getTranslations(String languageCode) {
    switch (languageCode) {
      case 'zh':
        return AppLocalizationsZh.translations;
      case 'tl':
        return AppLocalizationsTl.translations;
      case 'en':
      default:
        return AppLocalizationsEn.translations;
    }
  }

  /// Convenience accessor
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Translate a key to localized string
  String translate(String key) {
    return _localizedStrings[key] ?? '** $key **';
  }
}

/// Private delegate class
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'zh', 'tl'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
