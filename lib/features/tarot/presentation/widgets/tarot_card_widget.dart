import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/tarot_card.dart';

/// Widget to display a tarot card with its image
class TarotCardWidget extends StatelessWidget {
  final TarotCard card;
  final bool isReversed;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool showName;

  const TarotCardWidget({
    super.key,
    required this.card,
    this.isReversed = false,
    this.width = 100,
    this.height = 160,
    this.onTap,
    this.showName = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Transform(
              alignment: Alignment.center,
              transform: isReversed ? Matrix4.rotationZ(3.14159) : Matrix4.identity(),
              child: Image.asset(
                card.imagePath,
                fit: BoxFit.cover,
                // P1 perf: bound the decoded image to the displayed pixel
                // size × DPR so the engine doesn't decode the full PNG.
                // 78 cards at full resolution easily OOM a 6 GB Android
                // phone; this caps each card to ~ width × 3 × height × 3.
                cacheWidth: (width * 3).round(),
                cacheHeight: (height * 3).round(),
                errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.softPurple.withValues(alpha: 0.3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_stories, color: AppColors.rosePink, size: 28),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              card.nameEn,
                              style: const TextStyle(fontSize: 9, color: AppColors.textPrimary),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (showName) ...[
            const SizedBox(height: 6),
            Text(
              card.nameEn,
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
