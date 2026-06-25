import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Mystical-styled card with frosted glass effect
class MysticalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const MysticalCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? AppColors.darkSurface.withValues(alpha: 0.85)
        : AppColors.lightCard;
    final borderColor = isDark
        ? AppColors.softPurpleDark.withValues(alpha: 0.3)
        : AppColors.rosePinkLight.withValues(alpha: 0.3);

    return Card(
      margin: margin ?? EdgeInsets.zero,
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        side: BorderSide(
          color: borderColor,
          width: 0.5,
        ),
      ),
      color: cardColor,
      surfaceTintColor: Colors.transparent,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(
          color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimary,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
