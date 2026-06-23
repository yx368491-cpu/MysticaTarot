import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:mystica_tarot/core/localization/app_localizations.dart';
import 'package:mystica_tarot/core/localization/supported_locales.dart';
import 'package:mystica_tarot/core/theme/app_theme.dart';
import 'package:mystica_tarot/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:mystica_tarot/features/onboarding/providers/onboarding_provider.dart';

/// Minimal wrapper that exposes only OnboardingPage + a real
/// OnboardingProvider pointing at a pre-opened Hive 'settings' box.
/// No asset bundles, plugins, or unrelated providers are touched.
Widget _buildHarness(String initialLocale) {
  return ChangeNotifierProvider(
    create: (_) => OnboardingProvider()..init(),
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      locale: Locale(initialLocale),
      supportedLocales: SupportedLocales.locales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const OnboardingPage(),
    ),
  );
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('mystica_onboarding_');
    Hive.init(tempDir.path);
    await Hive.openBox('settings');
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  setUp(() async {
    // Reset persisted onboarding state before each test.
    await Hive.box('settings').delete('onboardingCompleted');
  });

  group('OnboardingPage widget tests', () {
    testWidgets('renders first slide with Skip and Next on first launch',
        (tester) async {
      await tester.pumpWidget(_buildHarness('en'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to\nMysticaTarot'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      // Get Started is rendered only on the final slide.
      expect(find.text('Get Started'), findsNothing);
    });

    testWidgets('Skip button writes onboardingCompleted = true to Hive',
        (tester) async {
      await tester.pumpWidget(_buildHarness('en'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(
        Hive.box('settings').get('onboardingCompleted', defaultValue: false),
        true,
      );
    });

    testWidgets('shows Get Started CTA on the final slide', (tester) async {
      await tester.pumpWidget(_buildHarness('en'));
      await tester.pumpAndSettle();

      // Drag with a huge horizontal offset guarantees a multi-page snap on
      // any viewport width; pumpAndSettle completes the PageView animation.
      final pageView = find.byType(PageView);
      await tester.drag(pageView, const Offset(-10000, 0));
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
      // Skip is hidden on the last slide.
      expect(find.text('Skip'), findsNothing);
    });

    testWidgets('renders localized Chinese content', (tester) async {
      await tester.pumpWidget(_buildHarness('zh'));
      await tester.pumpAndSettle();

      expect(find.text('欢迎来到\n神秘塔罗'), findsOneWidget);
      expect(find.text('下一步'), findsOneWidget);
    });

    testWidgets('progresses through slides via Next button', (tester) async {
      await tester.pumpWidget(_buildHarness('en'));
      await tester.pumpAndSettle();

      // Slide 0
      expect(find.text('Welcome to\nMysticaTarot'), findsOneWidget);

      // Next → Slide 1
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Explore Divination'), findsOneWidget);

      // Next → Slide 2
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Fully Offline'), findsOneWidget);

      // Next → Slide 3
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Multi-Language'), findsOneWidget);
      // Skip is hidden once we reach the final visible slide.
      expect(find.text('Skip'), findsNothing);
    });
  });

  group('AppLocalizations onboarding keys', () {
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
