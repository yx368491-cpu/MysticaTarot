@Tags(['slow'])
library;

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

// WHY THIS FILE IS TAGGED 'slow':
// On Windows, pumpAndSettle() driving the OnboardingPage's PageView + Hive
// tempDir setup has been observed to hang beyond 5 minutes when running this
// file directly. The PageView's internal AnimationController may not reach
// idle inside the isolated harness. See docs/bug-log.md Bug #003.
//
// CI default:  `flutter test --exclude-tags=slow`
// Local opt-in: `flutter test --tags=slow`

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
    // Order matters on Windows: delete the box on disk first so file handles
    // are released before we delete the parent directory. Without this,
    // Hive.close() can race with Directory.delete on slow filesystems.
    await Hive.deleteBoxFromDisk('settings');
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  setUp(() async {
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

      final pageView = find.byType(PageView);
      await tester.drag(pageView, const Offset(-10000, 0));
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
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

      expect(find.text('Welcome to\nMysticaTarot'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Explore Divination'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Fully Offline'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Multi-Language'), findsOneWidget);
      expect(find.text('Skip'), findsNothing);
    });
  });
}
