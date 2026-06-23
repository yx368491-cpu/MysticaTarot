import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_card.dart';
import '../../../../shared/widgets/mystical_button.dart';
import '../../services/fortune_slip_service.dart';
import '../../providers/fortune_slip_provider.dart';

/// Fortune slip drawing page
class FortuneSlipPage extends StatelessWidget {
  const FortuneSlipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FortuneSlipProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('fortuneSlipTitle')),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Shake animation / result area
                  Expanded(
                    child: Center(
                      child: provider.isShaking
                          ? _ShakeAnimation()
                          : provider.currentSlip != null
                              ? _SlipResult(slip: provider.currentSlip!)
                              : _InitialPrompt(),
                    ),
                  ),
                  // Draw button
                  if (!provider.isShaking)
                    MysticalButton(
                      text: provider.currentSlip != null
                          ? 'Draw Again'
                          : l10n.translate('tapToDraw'),
                      icon: provider.currentSlip != null
                          ? Icons.refresh
                          : Icons.auto_awesome,
                      onPressed: () => provider.drawSlip(),
                    ),
                  if (provider.currentSlip != null) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => provider.reset(),
                      child: const Text('Clear', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InitialPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.rosePink.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.auto_awesome, size: 40, color: AppColors.rosePink),
        ),
        const SizedBox(height: 24),
        const Text(
          'Tap the button below\nto draw your fortune',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge,
        ),
      ],
    );
  }
}

class _ShakeAnimation extends StatefulWidget {
  @override
  State<_ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<_ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _shakeAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.rosePink, AppColors.softPurple],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.rosePink.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome, size: 48, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Drawing...', style: TextStyle(
                fontSize: 18, color: AppColors.rosePink, fontWeight: FontWeight.w500)),
            ],
          ),
        );
      },
    );
  }
}

class _SlipResult extends StatelessWidget {
  final FortuneSlip slip;

  const _SlipResult({required this.slip});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).locale.languageCode;
    final emoji = FortuneSlipService.getGradeEmoji(slip.grade);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Grade emoji
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          // Grade text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: _getGradeColor().withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getGradeColor().withValues(alpha: 0.3)),
            ),
            child: Text(
              slip.localizedGrade(locale),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getGradeColor(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Fortune text
          MysticalCard(
            child: Text(
              slip.localizedText(locale),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor() {
    switch (slip.grade) {
      case 'daiji': return Colors.red;
      case 'chukichi': return AppColors.rosePink;
      case 'kichi': return AppColors.goldDark;
      case 'shokichi': return AppColors.moonBlue;
      case 'suekichi': return AppColors.softPurpleDark;
      case 'kyo': return AppColors.textSecondary;
      default: return AppColors.rosePink;
    }
  }
}
