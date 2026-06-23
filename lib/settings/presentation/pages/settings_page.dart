import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/settings_tile.dart';
import '../../../shared/widgets/language_selector.dart';
import '../../providers/settings_provider.dart';

/// Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('settingsTitle')),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Language
              const _SectionHeader(title: 'Language'),
              const SizedBox(height: 4),
              LanguageSelector(
                currentLocale: settings.locale,
                onLocaleChanged: (locale) => settings.setLocale(locale),
              ),
              const SizedBox(height: 20),

              // Notifications
              const _SectionHeader(title: 'Notifications'),
              const SizedBox(height: 4),
              SettingsTile(
                icon: Icons.notifications_active,
                title: l10n.translate('dailyReminder'),
                trailing: Switch(
                  value: settings.dailyNotification,
                  activeThumbColor: AppColors.rosePink,
                  onChanged: (v) => settings.setDailyNotification(v),
                ),
              ),
              if (settings.dailyNotification)
                SettingsTile(
                  icon: Icons.schedule,
                  title: l10n.translate('notificationTime'),
                  subtitle: settings.notificationTime,
                  onTap: () => _pickTime(context, settings),
                ),
              const SizedBox(height: 20),

              // Sound
              const _SectionHeader(title: 'Sound'),
              const SizedBox(height: 4),
              SettingsTile(
                icon: Icons.volume_up,
                title: l10n.translate('sound'),
                trailing: Switch(
                  value: settings.soundEnabled,
                  activeThumbColor: AppColors.rosePink,
                  onChanged: (v) => settings.setSoundEnabled(v),
                ),
              ),
              const SizedBox(height: 20),

              // Theme
              const _SectionHeader(title: 'Theme'),
              const SizedBox(height: 4),
              SettingsTile(
                icon: Icons.brightness_6,
                title: l10n.translate('theme'),
                trailing: DropdownButton<ThemeMode>(
                  value: settings.themeMode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                    DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                    DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                  ],
                  onChanged: (mode) {
                    if (mode != null) settings.setThemeMode(mode);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Card Back
              const _SectionHeader(title: 'Card Back'),
              const SizedBox(height: 4),
              SettingsTile(
                icon: Icons.style,
                title: l10n.translate('cardBack'),
                subtitle: settings.cardBackStyle,
                onTap: () => _showCardBackPicker(context, settings),
              ),
              const SizedBox(height: 20),

              // About
              const _SectionHeader(title: 'About'),
              const SizedBox(height: 4),
              SettingsTile(
                icon: Icons.info_outline,
                title: l10n.translate('about'),
                subtitle: l10n.translate('version'),
                onTap: () => _showAbout(context),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _pickTime(BuildContext context, SettingsProvider settings) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.tryParse(settings.notificationTime.split(':')[0]) ?? 9,
        minute: int.tryParse(settings.notificationTime.split(':')[1]) ?? 0,
      ),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.rosePink,
          ),
        ),
        child: child!,
      ),
    );
    if (time != null) {
      final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      await settings.setNotificationTime(timeStr);
    }
  }

  void _showCardBackPicker(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Card Back Style'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['default', 'mystic', 'gold', 'moon'].map((style) {
            return ListTile(
              title: Text(style.toUpperCase()),
              leading: Icon(
                settings.cardBackStyle == style
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: AppColors.rosePink,
              ),
              onTap: () {
                settings.setCardBackStyle(style);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MysticaTarot',
      applicationVersion: '0.1.0',
      applicationLegalese: 'For entertainment purposes only.',
      children: [
        const Text(
          'MysticaTarot is a free offline tarot and divination app '
          'supporting English, Tagalog, and Chinese.',
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.rosePink.withValues(alpha: 0.8),
          letterSpacing: 2,
        ),
      ),
    );
  }
}
