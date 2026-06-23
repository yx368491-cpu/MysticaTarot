import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Daily card widget shown on home page
class DailyCardWidget extends StatelessWidget {
  const DailyCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Show today's card
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.rosePink.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.softPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_stories,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Card',
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to draw your card for today',
                    style: AppTextStyles.cardSubtitle,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.rosePink,
            ),
          ],
        ),
      ),
    );
  }
}
