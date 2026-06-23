import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../tarot/presentation/pages/tarot_home_page.dart';
import '../../../astrology/presentation/pages/astrology_page.dart';
import '../../../numerology/presentation/pages/numerology_page.dart';
import '../../../fortune_slip/presentation/pages/fortune_slip_page.dart';
import '../../../oracle_cards/presentation/pages/oracle_cards_page.dart';
import '../../../daily_card/presentation/pages/daily_card_page.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../../settings/presentation/pages/settings_page.dart';
import '../../providers/daily_card_provider.dart';
import '../widgets/divination_card.dart';

/// Home page - main entry point with bottom navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeContent(),
          const HistoryPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBottomNav
            : AppColors.lightCard,
        border: Border(
          top: BorderSide(
            color: AppColors.softPurpleLight.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _NavItem(
                icon: Icons.history,
                label: 'History',
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _NavItem(
                icon: Icons.settings,
                label: 'Settings',
                isSelected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.rosePink : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? AppColors.rosePink : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// Home content - divination grid + daily card
class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dailyProvider = context.watch<DailyCardProvider>();

    return GradientBackground(
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
              const SizedBox(height: 16),
              // Daily card banner
              _DailyCardBanner(
                hasDrawn: dailyProvider.isDrawn,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DailyCardPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                l10n.translate('homeSubtitle'),
                style: AppTextStyles.headingSmall,
              ),
              const SizedBox(height: 12),
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TarotHomePage())),
                    ),
                    DivinationCard(
                      icon: Icons.star,
                      title: l10n.translate('divAstrology'),
                      subtitle: l10n.translate('divAstrologyDesc'),
                      color: AppColors.softPurple,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AstrologyPage())),
                    ),
                    DivinationCard(
                      icon: Icons.tag,
                      title: l10n.translate('divNumerology'),
                      subtitle: l10n.translate('divNumerologyDesc'),
                      color: AppColors.moonBlue,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NumerologyPage())),
                    ),
                    DivinationCard(
                      icon: Icons.auto_awesome,
                      title: l10n.translate('divFortuneSlip'),
                      subtitle: l10n.translate('divFortuneSlipDesc'),
                      color: AppColors.gold,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FortuneSlipPage())),
                    ),
                    DivinationCard(
                      icon: Icons.psychology,
                      title: l10n.translate('divOracle'),
                      subtitle: l10n.translate('divOracleDesc'),
                      color: AppColors.rosePinkDark,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OracleCardsPage())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyCardBanner extends StatelessWidget {
  final bool hasDrawn;
  final VoidCallback onTap;

  const _DailyCardBanner({required this.hasDrawn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.rosePink.withValues(alpha: 0.15),
              AppColors.softPurple.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.rosePink.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 68,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.softPurple, AppColors.rosePink],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_stories, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate('dailyCard'),
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasDrawn ? 'Tap to see today\'s card' : l10n.translate('dailyCardSubtitle'),
                    style: AppTextStyles.cardSubtitle,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.rosePink.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}
