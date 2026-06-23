import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_card.dart';
import '../../../../shared/widgets/mystical_button.dart';
import '../../../../shared/widgets/particle_effect.dart';
import '../../../tarot/domain/entities/tarot_card.dart';
import '../../../oracle_cards/services/oracle_reading_service.dart';
import '../../../home/services/daily_card_service.dart';
import '../../../home/providers/daily_card_provider.dart';

/// Daily card page with draw and display
class DailyCardPage extends StatelessWidget {
  const DailyCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyCardProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('dailyCard')),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Stack(
          children: [
            const Positioned.fill(child: ParticleEffect(particleCount: 8)),
            SafeArea(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.isDrawn && provider.todayCard != null
                      ? _DailyCardDisplay(result: provider.todayCard!)
                      : _DailyCardDraw(provider: provider),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyCardDraw extends StatelessWidget {
  final DailyCardProvider provider;

  const _DailyCardDraw({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.softPurple, AppColors.rosePink],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.rosePink.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.auto_stories, size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your card for today awaits',
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Draw a card to receive\nyour daily guidance',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 32),
            MysticalButton(
              text: 'Draw Today\'s Card',
              icon: Icons.auto_awesome,
              onPressed: () => provider.drawDailyCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyCardDisplay extends StatelessWidget {
  final DailyCardResult result;

  const _DailyCardDisplay({required this.result});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).locale.languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Date header
          Text(result.date, style: const TextStyle(
            fontSize: 14, color: AppColors.textSecondary, letterSpacing: 2)),
          const SizedBox(height: 4),
          const Text(
            'Today\'s Card',
            style: AppTextStyles.mysticalTitle,
          ),
          const SizedBox(height: 20),

          // Card display
          if (result.cardType == 'tarot' && result.tarotCard != null)
            _TarotCardPreview(card: result.tarotCard!, isReversed: result.isReversed)
          else if (result.oracleCard != null)
            _OracleCardPreview(card: result.oracleCard!),

          const SizedBox(height: 24),

          // Message
          MysticalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_stories, color: AppColors.rosePink, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      result.cardType == 'tarot' ? 'Tarot Guidance' : 'Oracle Guidance',
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.rosePink),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  result.cardType == 'tarot' && result.tarotCard != null
                      ? (result.isReversed
                          ? result.tarotCard!.localizedReversedMeaning(locale)
                          : result.tarotCard!.localizedUprightMeaning(locale))
                      : result.message,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TarotCardPreview extends StatelessWidget {
  final TarotCard card;
  final bool isReversed;

  const _TarotCardPreview({required this.card, required this.isReversed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Transform(
          alignment: Alignment.center,
          transform: isReversed ? Matrix4.rotationZ(3.14159) : Matrix4.identity(),
          child: Image.asset(
            card.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.softPurple.withValues(alpha: 0.3),
                child: Center(
                  child: Text(
                    card.nameEn,
                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OracleCardPreview extends StatelessWidget {
  final OracleCard card;

  const _OracleCardPreview({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 170,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.softPurple, AppColors.gold],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withValues(alpha: 0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            card.nameEn,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
