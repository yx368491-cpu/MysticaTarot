import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_card.dart';
import '../../../../shared/widgets/particle_effect.dart';
import '../../providers/tarot_provider.dart';
import '../../services/tarot_reading_service.dart';
import '../widgets/tarot_card_widget.dart';

/// Reading result page showing all revealed cards with interpretations
class ReadingResultPage extends StatelessWidget {
  const ReadingResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarotProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('cardMeaning')),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            provider.reset();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality (Phase 4)
            },
          ),
        ],
      ),
      body: GradientBackground(
        child: Stack(
          children: [
            const Positioned.fill(child: ParticleEffect(particleCount: 10)),
            SafeArea(
              child: Column(
                children: [
                  // Spread title (localized)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      provider.selectedSpread?.localizedName(provider.locale) ??
                          l10n.translate('cardMeaning'),
                      style: AppTextStyles.mysticalTitle,
                    ),
                  ),
                  // Cards list
                  Expanded(
                    child: provider.drawnCards.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_stories,
                                    size: 48,
                                    color: AppColors.rosePink.withValues(alpha: 0.5)),
                                const SizedBox(height: 12),              Text(
                'No reading data available',
                style: TextStyle(
                  fontSize: 16, color: AppColors.secondaryText(context)),
              ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: provider.drawnCards.length,
                            itemBuilder: (context, index) {
                              final result = provider.drawnCards[index];
                              final card = provider.getCardByResult(result);
                              final interpretation = provider.getInterpretation(index);

                              if (card == null || interpretation == null) {
                                return const SizedBox();
                              }

                              return _CardDetailCard(
                                interpretation: interpretation,
                                positionName: provider.getPositionName(index),
                                positionDesc: provider.getPositionDescription(index),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardDetailCard extends StatelessWidget {
  final CardInterpretation interpretation;
  final String positionName;
  final String positionDesc;

  const _CardDetailCard({
    required this.interpretation,
    required this.positionName,
    required this.positionDesc,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MysticalCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header with name and position
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card image thumbnail
              SizedBox(
                width: 60,
                height: 90,
                child: TarotCardWidget(
                  card: interpretation.card,
                  isReversed: interpretation.isReversed,
                  width: 60,
                  height: 90,
                ),
              ),
              const SizedBox(width: 16),
              // Card info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Position
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.rosePink.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        positionName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.rosePink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Card name
                    Text(
                      interpretation.name,
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    // Position (upright/reversed, localized)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (interpretation.isReversed
                                ? AppColors.error
                                : AppColors.success)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        interpretation.isReversed
                            ? l10n.translate('reversed')
                            : l10n.translate('upright'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: interpretation.isReversed
                              ? AppColors.error
                              : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Keywords
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: interpretation.keywords.map((kw) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  kw,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.goldDark,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Meaning
          _buildSection(
            context,
            icon: Icons.auto_stories,
            title: l10n.translate('sectionMeaning'),
            content: interpretation.meaning,
          ),
          const SizedBox(height: 10),
          // Love
          _buildSection(
            context,
            icon: Icons.favorite,
            title: l10n.translate('love'),
            content: interpretation.love,
          ),
          const SizedBox(height: 10),
          // Career
          _buildSection(
            context,
            icon: Icons.work,
            title: l10n.translate('career'),
            content: interpretation.career,
          ),
          const SizedBox(height: 10),
          // Advice
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.1),
                  AppColors.rosePink.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb, color: AppColors.gold, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('advice'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.goldDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        interpretation.advice,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryText(context),
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.rosePink, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.rosePink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryText(context),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
