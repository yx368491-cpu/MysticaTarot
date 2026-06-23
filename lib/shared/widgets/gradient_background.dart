import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Gradient background widget for mystical theme
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final bool animate;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = colors ??
        (isDark
            ? [
                AppColors.darkBackground,
                const Color(0xFF0D1B2A),
              ]
            : [
                AppColors.lightBackground,
                AppColors.rosePinkLight.withValues(alpha: 0.3),
                AppColors.softPurpleLight.withValues(alpha: 0.2),
              ]);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
