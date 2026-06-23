import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/supported_locales.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/tarot/providers/tarot_provider.dart';
import 'features/tarot/providers/reading_history_provider.dart';
import 'features/astrology/providers/astrology_provider.dart';
import 'features/numerology/providers/numerology_provider.dart';
import 'features/fortune_slip/providers/fortune_slip_provider.dart';
import 'features/oracle_cards/providers/oracle_provider.dart';
import 'settings/providers/settings_provider.dart';

class MysticaTarotApp extends StatelessWidget {
  const MysticaTarotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TarotProvider()..init()),
        ChangeNotifierProvider(create: (_) => ReadingHistoryProvider()..init()),
        ChangeNotifierProvider(create: (_) => AstrologyProvider()..init()),
        ChangeNotifierProvider(create: (_) => NumerologyProvider()),
        ChangeNotifierProvider(create: (_) => FortuneSlipProvider()..init()),
        ChangeNotifierProvider(create: (_) => OracleProvider()..init()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..init()),
      ],
      child: MaterialApp(
        title: 'MysticaTarot',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Localization
        locale: const Locale('en'),
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

        // Home
        home: const HomePage(),
      ),
    );
  }
}
