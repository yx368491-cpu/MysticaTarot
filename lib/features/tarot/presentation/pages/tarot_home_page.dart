import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_card.dart';
import '../../../../shared/widgets/mystical_button.dart';
import '../../providers/tarot_provider.dart';
import '../../domain/entities/spread.dart';
import 'card_draw_page.dart';

/// Tarot home page - spread selection
class TarotHomePage extends StatelessWidget {
  const TarotHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<TarotProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('tarotTitle')),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        l10n.translate('selectSpread'),
                        style: AppTextStyles.headingMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose a spread layout for your reading',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      // Spread grid
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: provider.spreads.length,
                          itemBuilder: (context, index) {
                            final spread = provider.spreads[index];
                            return _SpreadCard(
                              spread: spread,
                              isSelected: provider.selectedSpread?.id == spread.id,
                              onTap: () => provider.selectSpread(spread),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Start reading button
                      if (provider.selectedSpread != null)
                        MysticalButton(
                          text: l10n.translate('startReading'),
                          icon: Icons.auto_stories,
                          onPressed: () {
                            provider.startReading().then((_) {
                              if (!context.mounted) return;
                              if (provider.hasDrawnCards) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CardDrawPage(),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _SpreadCard extends StatelessWidget {
  final Spread spread;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpreadCard({
    required this.spread,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MysticalCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (isSelected ? AppColors.rosePink : AppColors.softPurple)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${spread.cardCount} cards',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.rosePink : AppColors.softPurple,
              ),
            ),
          ),
          const Spacer(),
          Text(
            spread.nameEn,
            style: AppTextStyles.cardTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            spread.descriptionEn,
            style: AppTextStyles.cardSubtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isSelected) ...[
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.rosePink, size: 16),
                SizedBox(width: 4),
                Text('Selected', style: TextStyle(fontSize: 12, color: AppColors.rosePink)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
