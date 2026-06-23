import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/core/localization/app_localizations.dart';
import 'package:mystica_tarot/core/localization/supported_locales.dart';
import 'package:mystica_tarot/core/theme/app_theme.dart';
import 'package:mystica_tarot/settings/presentation/pages/about_page.dart';

/// Minimal harness — no asset bundles or plugins are required.
Widget _buildHarness(String initialLocale) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: Locale(initialLocale),
    supportedLocales: SupportedLocales.locales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: const Scaffold(body: AboutPage()),
  );
}

void main() {
  group('AboutPage', () {
    testWidgets('renders hero, all 6 sections, and version string (EN)',
        (tester) async {
      await tester.pumpWidget(_buildHarness('en'));
      await tester.pumpAndSettle();

      // Hero
      expect(find.text('MysticaTarot'), findsWidgets);
      expect(find.text('Version 0.1.0'), findsOneWidget);

      // Section headers (EN)
      expect(find.text('Features'), findsOneWidget);
      expect(find.text('Card Artwork'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Open Source Acknowledgements'), findsOneWidget);
      expect(find.text('License'), findsOneWidget);
      expect(find.text('Disclaimer'), findsOneWidget);

      // Attribution + URL
      expect(find.textContaining('Wikimedia Commons'), findsWidgets);
      expect(find.textContaining('opensource.org/licenses/MIT'), findsOneWidget);

      // Open source dependencies listed
      expect(find.textContaining('Flutter'), findsWidgets);
      expect(find.textContaining('Provider'), findsWidgets);
      expect(find.textContaining('Hive'), findsWidgets);
    });

    testWidgets('localizes section titles in Chinese', (tester) async {
      await tester.pumpWidget(_buildHarness('zh'));
      await tester.pumpAndSettle();

      expect(find.text('功能列表'), findsOneWidget);
      expect(find.text('塔罗牌插画'), findsOneWidget);
      expect(find.text('隐私'), findsOneWidget);
      expect(find.text('开源致谢'), findsOneWidget);
      expect(find.text('免责声明'), findsOneWidget);
      expect(find.text('版本 0.1.0'), findsOneWidget);
    });

    testWidgets('localizes section titles in Tagalog', (tester) async {
      await tester.pumpWidget(_buildHarness('tl'));
      await tester.pumpAndSettle();

      expect(find.text('Mga Tampok'), findsOneWidget);
      expect(find.text('Sining ng Card'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Pagkilala sa Open Source'), findsOneWidget);
      expect(find.text('Disclaimer'), findsOneWidget);
      expect(find.text('Bersyon 0.1.0'), findsOneWidget);
    });

    test('localization keys exist in all three locales', () {
      const keys = [
        'aboutTitle', 'aboutTagline', 'aboutSectionFeatures',
        'aboutSectionArt', 'aboutSectionPrivacy',
        'aboutSectionOpenSource', 'aboutSectionLicense',
        'aboutSectionDisclaimer',
      ];
      for (final code in ['en', 'zh', 'tl']) {
        final l10n = AppLocalizations(Locale(code));
        for (final k in keys) {
          expect(
            l10n.translate(k),
            isNot(equals('** $k **')),
            reason: 'Locale "$code" missing key "$k"',
          );
        }
      }
    });
  });
}
