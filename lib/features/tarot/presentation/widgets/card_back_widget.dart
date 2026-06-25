import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Styled card back widget showing the back of a tarot card
class CardBackWidget extends StatelessWidget {
  final double width;
  final double height;
  final String? style;
  final VoidCallback? onTap;

  const CardBackWidget({
    super.key,
    this.width = 100,
    this.height = 160,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.softPurple,
              AppColors.rosePink,
              AppColors.softPurpleDark,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _CardBackPainter(style: style),
          child: Center(
            child: Container(
              width: width * 0.6,
              height: height * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_stories,
                  color: AppColors.gold.withValues(alpha: 0.8),
                  size: width * 0.25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardBackPainter extends CustomPainter {
  final String? style;

  _CardBackPainter({this.style});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw decorative diamond pattern
    final path = Path()
      ..moveTo(size.width / 2, 10)
      ..lineTo(size.width - 10, size.height / 2)
      ..lineTo(size.width / 2, size.height - 10)
      ..lineTo(10, size.height / 2)
      ..close();
    canvas.drawPath(path, paint);

    // Draw star in center
    final starPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.15, starPaint);
  }

  @override
  bool shouldRepaint(covariant _CardBackPainter oldDelegate) => oldDelegate.style != style;
}
