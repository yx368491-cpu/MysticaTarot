import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/supported_locales.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';

class MysticaTarotApp extends StatelessWidget {
  const MysticaTarotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

      // Router
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,

      // Home
      home: const HomePage(),
    );
  }
}
