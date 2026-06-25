import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/sound_utils.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/particle_effect.dart';
import '../../domain/entities/reading.dart';
import '../../providers/reading_history_provider.dart';
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
  bool _isRevealing = false; // guard against double-fire during animation
  bool _hasSavedToHistory = false; // guard against double-save across navigation
  bool _isCompleting = false; // guard against rapid re-taps on close / "View Full Reading"
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
    if (_isRevealing) return;
    if (_currentRevealIndex + 1 < _flipKeys.length) {
      _isRevealing = true;
      setState(() => _currentRevealIndex++);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (context.mounted) {
          SoundUtils.playReveal();
          // Update provider state — this triggers a rebuild, which causes
          // CardFlipAnimation.didUpdateWidget to detect isFlipped true
          // and start the 3D flip animation. When animation completes,
          // onFlipComplete chains to the next card.
          context.read<TarotProvider>().revealCard(_currentRevealIndex);
        }
        _isRevealing = false;
      });
    }
  }

  Future<void> _goToResults(TarotProvider provider) async {
    // Synchronous re-entry guard. Setting `_isCompleting=true` before any
    // await ensures a rapid double-tap can't schedule two `Navigator.push`
    // calls (the second would pop the just-pushed route out from under us).
    if (_isCompleting) return;
    _isCompleting = true;

    if (!provider.allRevealed) {
      provider.revealAllCards();
    }

    // Persist the completed reading to history (Bug fix: no caller was ever
    // invoking addRecord, so the History page was always empty after a
    // Tarot draw). Guarded by `_hasSavedToHistory` because the user can
    // navigate back from ReadingResultPage and re-tap "View Full Reading".
    await _persistReading(provider);

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReadingResultPage()),
    );
  }

  Future<void> _onCloseTap(TarotProvider provider) async {
    // Synchronous re-entry guard: prevents double-tap of the X button
    // from calling Navigator.pop twice once the first `await` resumes.
    if (_isCompleting) return;
    _isCompleting = true;

    // If the reading was fully revealed but the user closed before tapping
    // "View Full Reading", still persist so the history matches their intent.
    if (provider.drawnCards.isNotEmpty && provider.allRevealed) {
      await _persistReading(provider);
    }
    if (!context.mounted) return;
    provider.reset();
    Navigator.pop(context);
  }

  Future<void> _persistReading(TarotProvider provider) async {
    if (_hasSavedToHistory) return;
    final drawn = provider.drawnCards;
    if (drawn.isEmpty) return;
    // Sync flag-set BEFORE any await: doubles as re-entry guard. If we ever
    // move this past the await, a rapid double-tap can race past the early
    // return and `_persistReading` would call `addRecord` twice.
    _hasSavedToHistory = true;

    final history = context.read<ReadingHistoryProvider>();
    final timestamp = DateTime.now();
    final id =
        '${timestamp.microsecondsSinceEpoch}_${Random().nextInt(10000)}';

    try {
      await history.addRecord(
        ReadingRecord(
          id: id,
          timestamp: timestamp,
          type: DivinationType.tarot,
          spreadId: provider.selectedSpread?.id,
          cards: List<CardResult>.from(drawn),
        ),
      );
    } catch (_) {
      // Persist failed (Hive write error).
      //
      // We deliberately do NOT roll `_hasSavedToHistory` back here. The
      // `ReadingHistoryProvider.addRecord` path mutates `_records` *before*
      // attempting the Hive write, so a thrown write leaves the in-memory
      // list in a partially-mutated state. Allowing a retry would have us
      // re-insert the same record before writing, producing two entries on
      // a successful retry. The rarer-but-bounded outcome (silent failure)
      // is preferable to the deterministic data-layer duplicate. A one-off
      // Hive write failure is rare enough that swallowing it keeps the
      // user navigation flow intact.
    }
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
          onPressed: () => _onCloseTap(provider),
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
                                onPressed: provider.allRevealed ? () => _goToResults(provider) : null,
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
    if (cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 48,
                color: AppColors.rosePink.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              'No cards drawn yet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.secondaryText(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap "Start Reading" to begin',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.secondaryText(context).withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

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
                  onFlipComplete: () => _revealNextCard(),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  provider.getPositionName(index),
                  style: TextStyle(
                    fontSize: 11,
                    color: isRevealed
                      ? AppColors.rosePink
                      : AppColors.secondaryText(context),
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
