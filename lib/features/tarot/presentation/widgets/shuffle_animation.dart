import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/sound_utils.dart';

/// Shuffle animation simulating cards being shuffled
class ShuffleAnimation extends StatefulWidget {
  final VoidCallback onShuffleComplete;

  const ShuffleAnimation({super.key, required this.onShuffleComplete});

  @override
  State<ShuffleAnimation> createState() => _ShuffleAnimationState();
}

class _ShuffleAnimationState extends State<ShuffleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _cardAnimations = List.generate(5, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.15, 0.5 + i * 0.1, curve: Curves.easeInOut),
        ),
      );
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onShuffleComplete();
      }
    });
    _controller.forward();
    // Play shuffle sound
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SoundUtils.playShuffle();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(5, (i) {
                  final offset = _cardAnimations[i].value * 30 - 15;
                  final rotation = _cardAnimations[i].value * 0.3 - 0.15;
                  return Transform.translate(
                    offset: Offset(offset * 2, -offset + (i * 3)),
                    child: Transform.rotate(
                      angle: rotation,
                      child: Container(
                        width: 60, height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.softPurple, AppColors.rosePink],
                          ),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(1, 2))],
                        ),
                        child: Center(child: Icon(Icons.auto_stories, color: AppColors.gold.withValues(alpha: 0.7), size: 20)),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Shuffling...', style: TextStyle(fontSize: 18, color: AppColors.rosePink, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.softPurpleLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.rosePink),
                value: _controller.value,
              ),
            ),
          ],
        );
      },
    );
  }
}
