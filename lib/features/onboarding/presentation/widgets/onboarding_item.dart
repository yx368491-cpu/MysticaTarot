import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Single onboarding slide with illustrated icon, title, and description.
///
/// Designed for use in a PageView. Fades and scales its contents based on
/// the current [animationValue] (0 = not visible, 1 = fully on-screen).
class OnboardingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double animationValue;

  const OnboardingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.animationValue = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Smooth fade + slight upward slide for entrance.
    final fade = Curves.easeOutCubic.transform(animationValue.clamp(0.0, 1.0));
    final slide = (1 - fade) * 24;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decorative gradient halo around the icon
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.rosePink.withValues(alpha: 0.25 * fade),
                  AppColors.softPurple.withValues(alpha: 0.15 * fade),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: Center(
              child: Transform.scale(
                scale: 0.85 + 0.15 * fade,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.rosePinkDark,
                              AppColors.softPurple,
                            ]
                          : [
                              AppColors.rosePink,
                              AppColors.softPurple,
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.rosePink.withValues(alpha: 0.4 * fade),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Title
          Opacity(
            opacity: fade,
            child: Transform.translate(
              offset: Offset(0, slide),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.primaryText(context),
                  height: 1.3,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Opacity(
            opacity: fade,
            child: Transform.translate(
              offset: Offset(0, slide),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.75)
                      : AppColors.secondaryText(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
