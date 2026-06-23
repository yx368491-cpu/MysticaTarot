import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/supported_locales.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/home/providers/daily_card_provider.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/tarot/providers/tarot_provider.dart';
import 'features/tarot/providers/reading_history_provider.dart';
import 'features/astrology/providers/astrology_provider.dart';
import 'features/numerology/providers/numerology_provider.dart';
import 'features/fortune_slip/providers/fortune_slip_provider.dart';
import 'features/oracle_cards/providers/oracle_provider.dart';
import 'settings/providers/settings_provider.dart';

class MysticaTarotApp extends StatefulWidget {
  const MysticaTarotApp({super.key});

  @override
  State<MysticaTarotApp> createState() => _MysticaTarotAppState();
}

class _MysticaTarotAppState extends State<MysticaTarotApp> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    try {
      await NotificationService().init();
      final box = Hive.box('settings');
      final time = box.get('notificationTime', defaultValue: '09:00') as String;
      final enabled = box.get('dailyNotification', defaultValue: true) as bool;
      if (enabled) {
        final parts = time.split(':');
        await NotificationService().scheduleDailyReminder(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (_) {
      // Notification init failed - app continues without notifications
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Settings is the source of truth for locale/theme.
        ChangeNotifierProvider(create: (_) => SettingsProvider()..init()),
        // TarotProvider stays in sync with SettingsProvider.locale via ProxyProvider.
        // init() runs once at construction; setLocale() hydrates the locale
        // from Settings every time settings changes.
        ChangeNotifierProxyProvider<SettingsProvider, TarotProvider>(
          create: (_) => TarotProvider()..init(),
          update: (_, settings, tarot) {
            final p = tarot ?? TarotProvider();
            p.setLocale(settings.locale);
            return p;
          },
        ),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()..init()),
        ChangeNotifierProvider(create: (_) => ReadingHistoryProvider()..init()),
        ChangeNotifierProvider(create: (_) => AstrologyProvider()..init()),
        ChangeNotifierProvider(create: (_) => NumerologyProvider()),
        ChangeNotifierProvider(create: (_) => FortuneSlipProvider()..init()),
        ChangeNotifierProvider(create: (_) => OracleProvider()..init()),
        ChangeNotifierProvider(create: (_) => DailyCardProvider()..init()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'MysticaTarot',
            debugShowCheckedModeBanner: false,

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,

            // Localization
            locale: Locale(settings.locale),
            supportedLocales: SupportedLocales.locales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return const Locale('en');
            },

            // Home: route to Onboarding (first launch) or HomePage.
            // OnboardingProvider.markCompleted() triggers Consumer rebuild
            // which swaps home to HomePage automatically.
            home: Consumer<OnboardingProvider>(
              builder: (context, onboarding, _) {
                if (onboarding.isLoaded && !onboarding.isCompleted) {
                  return const OnboardingPage();
                }
                return const HomePage();
              },
            ),
          );
        },
      ),
    );
  }
}
