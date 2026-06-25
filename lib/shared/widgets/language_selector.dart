import 'package:flutter/material.dart';
import '../../core/localization/supported_locales.dart';
import '../../core/theme/app_colors.dart';

/// Language selector widget
class LanguageSelector extends StatelessWidget {
  final String currentLocale;
  final ValueChanged<String> onLocaleChanged;

  const LanguageSelector({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final locale in ['en', 'zh', 'tl']) ...[
          if (locale != 'en')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('|', style: TextStyle(color: AppColors.secondaryText(context))),
            ),
          GestureDetector(
            onTap: () => onLocaleChanged(locale),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: currentLocale == locale
                    ? AppColors.rosePink.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                SupportedLocales.localeNamesLocalized[locale] ?? locale,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      currentLocale == locale ? FontWeight.w600 : FontWeight.normal,
                  color: currentLocale == locale
                      ? AppColors.rosePink
                      : AppColors.secondaryText(context),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
