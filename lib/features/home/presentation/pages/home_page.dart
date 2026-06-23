import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_card.dart';
import '../../../../core/localization/app_localizations.dart';

/// Home page - main entry point with divination method selection
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header
                Center(
                  child: Column(
                    children: [
                      Text(
                        l10n.translate('appName'),
                        style: AppTextStyles.mysticalTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.translate('appNameSubtitle'),
                        style: AppTextStyles.mysticalSubtitle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Subtitle
                Text(
                  l10n.translate('homeSubtitle'),
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 16),
                // Divination methods grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _DivinationMethodCard(
                        icon: Icons.auto_stories,
                        title: l10n.translate('divTarot'),
                        subtitle: l10n.translate('divTarotDesc'),
                        color: AppColors.rosePink,
                        onTap: () {},
                      ),
                      _DivinationMethodCard(
                        icon: Icons.star,
                        title: l10n.translate('divAstrology'),
                        subtitle: l10n.translate('divAstrologyDesc'),
                        color: AppColors.softPurple,
                        onTap: () {},
                      ),
                      _DivinationMethodCard(
                        icon: Icons.tag,
                        title: l10n.translate('divNumerology'),
                        subtitle: l10n.translate('divNumerologyDesc'),
                        color: AppColors.moonBlue,
                        onTap: () {},
                      ),
                      _DivinationMethodCard(
                        icon: Icons.auto_awesome,
                        title: l10n.translate('divFortuneSlip'),
                        subtitle: l10n.translate('divFortuneSlipDesc'),
                        color: AppColors.gold,
                        onTap: () {},
                      ),
                      _DivinationMethodCard(
                        icon: Icons.psychology,
                        title: l10n.translate('divOracle'),
                        subtitle: l10n.translate('divOracleDesc'),
                        color: AppColors.rosePinkDark,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DivinationMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DivinationMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MysticalCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.cardTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.cardSubtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
