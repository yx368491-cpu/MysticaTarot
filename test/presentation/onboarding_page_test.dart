import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/core/localization/app_localizations.dart';

// Widget-driven tests for OnboardingPage live in
// `test/presentation/onboarding_page_widget_test.dart`, tagged `slow` to keep
// the default `flutter test` suite fast. Localization-key assertions live
// here and run in milliseconds.

void main() {
  group('AppLocalizations onboarding keys', () {
    test('English welcome copy is non-empty', () {
      final en = AppLocalizations(const Locale('en')).translate('onboardingWelcome');
      expect(en, isNotEmpty);
      expect(en, contains('MysticaTarot'));
    });

    test('Chinese translation exists for onboarding title', () {
      final cn = AppLocalizations(const Locale('zh')).translate('onboardingWelcome');
      expect(cn, '欢迎来到\n神秘塔罗');
    });

    test('Tagalog translation exists for onboarding title', () {
      final tl = AppLocalizations(const Locale('tl')).translate('onboardingWelcome');
      expect(tl, isNotEmpty);
      expect(tl, contains('MysticaTarot'));
    });
  });
}
