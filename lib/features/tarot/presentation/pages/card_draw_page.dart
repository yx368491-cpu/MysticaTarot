import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/sound_utils.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/particle_effect.dart';
import '../../providers/tarot_provider.dart';
import '../widgets/tarot_card_widget.dart';
import '../widgets/card_back_widget.dart';
import '../widgets/card_flip_animation.dart';
import '../widgets/shuffle_animation.dart';
import 'reading_result_page.dart';

/// Card draw page with shuffle and flip animation
class CardDrawPage extends StatefulWidget {
  const CardDrawPage({super.key});

  @override
  State<CardDrawPage> createState() => _CardDrawPageState();
}

class _CardDrawPageState extends State<CardDrawPage> {
  bool _showShuffle = true;
  int _currentRevealIndex = -1;
  final List<GlobalKey<CardFlipAnimationState>> _flipKeys = [];

  @override
  void initState() {
    super.initState();
    final provider = context.read<TarotProvider>();
    _flipKeys.addAll(
      List.generate(provider.drawnCards.length, (_) => GlobalKey<CardFlipAnimationState>()),
    );
    // Show shuffle for 3 seconds, then reveal cards one by one
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showShuffle = false);
        _revealNextCard();
      }
    });
  }

  void _revealNextCard() {
    if (_currentRevealIndex + 1 < _flipKeys.length) {
      setState(() => _currentRevealIndex++);
      final key = _flipKeys[_currentRevealIndex];
      Future.delayed(const Duration(milliseconds: 300), () {
        SoundUtils.playReveal();
        key.currentState?.flip();
        if (mounted) {
          context.read<TarotProvider>().revealCard(_currentRevealIndex);
        }
      });
    }
  }

  void _goToResults() {
    final provider = context.read<TarotProvider>();
    if (!provider.allRevealed) {
      provider.revealAllCards();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReadingResultPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarotProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('tarotTitle')),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            provider.reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: GradientBackground(
        child: Stack(
          children: [
            // Particle effect background
            const Positioned.fill(child: ParticleEffect(particleCount: 15)),
            // Main content
            SafeArea(
              child: _showShuffle
                  ? Center(
                      child: ShuffleAnimation(
                        onShuffleComplete: () {},
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Tap cards to reveal',
                            style: AppTextStyles.mysticalSubtitle,
                          ),
                          const SizedBox(height: 20),
                          // Card grid showing drawn cards
                          Expanded(
                            child: _buildCardGrid(provider),
                          ),
                          const SizedBox(height: 20),
                          // Reveal all button
                          if (_currentRevealIndex >= 0)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: provider.allRevealed ? _goToResults : null,
                                child: Text(
                                  provider.allRevealed
                                      ? 'View Full Reading'
                                      : 'Revealing cards...',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardGrid(TarotProvider provider) {
    final cards = provider.drawnCards;
    if (cards.isEmpty) return const SizedBox();

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cards.length <= 4 ? cards.length : 3,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final isRevealed = provider.revealedCards[index];
            final isCurrent = index == _currentRevealIndex;
            final card = provider.getCardByResult(cards[index]);

            return Column(
              children: [
                Expanded(
                  child: CardFlipAnimation(
                    key: _flipKeys[index],
                    frontChild: card != null
                        ? TarotCardWidget(
                            card: card,
                            isReversed: cards[index].isReversed,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Container(color: AppColors.softPurple),
                    backChild: CardBackWidget(
                      width: double.infinity,
                      height: double.infinity,
                      onTap: isCurrent ? () => _revealNextCard() : null,
                    ),
                    isFlipped: isRevealed,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  provider.getPositionName(index),
                  style: TextStyle(
                    fontSize: 11,
                    color: isRevealed ? AppColors.rosePink : AppColors.textSecondary,
                    fontWeight: isRevealed ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
