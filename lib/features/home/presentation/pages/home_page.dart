import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../tarot/presentation/pages/tarot_home_page.dart';
import '../widgets/divination_card.dart';

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
                      DivinationCard(
                        icon: Icons.auto_stories,
                        title: l10n.translate('divTarot'),
                        subtitle: l10n.translate('divTarotDesc'),
                        color: AppColors.rosePink,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TarotHomePage(),
                            ),
                          );
                        },
                      ),
                      DivinationCard(
                        icon: Icons.star,
                        title: l10n.translate('divAstrology'),
                        subtitle: l10n.translate('divAstrologyDesc'),
                        color: AppColors.softPurple,
                        onTap: () {},
                      ),
                      DivinationCard(
                        icon: Icons.tag,
                        title: l10n.translate('divNumerology'),
                        subtitle: l10n.translate('divNumerologyDesc'),
                        color: AppColors.moonBlue,
                        onTap: () {},
                      ),
                      DivinationCard(
                        icon: Icons.auto_awesome,
                        title: l10n.translate('divFortuneSlip'),
                        subtitle: l10n.translate('divFortuneSlipDesc'),
                        color: AppColors.gold,
                        onTap: () {},
                      ),
                      DivinationCard(
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


