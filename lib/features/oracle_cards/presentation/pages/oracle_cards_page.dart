import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_card.dart';
import '../../../../shared/widgets/mystical_button.dart';
import '../../providers/oracle_provider.dart';

/// Oracle cards reading page
class OracleCardsPage extends StatelessWidget {
  const OracleCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OracleProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('oracleTitle')),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Mode selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ModeButton(
                            label: 'Single Card',
                            isSelected: provider.cardMode == 1,
                            onTap: () => provider.setCardMode(1),
                          ),
                          const SizedBox(width: 12),
                          _ModeButton(
                            label: 'Three Cards',
                            isSelected: provider.cardMode == 3,
                            onTap: () => provider.setCardMode(3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Results / drawing area
                      Expanded(
                        child: provider.isDrawing
                            ? _DrawingAnimation()
                            : provider.hasResults
                                ? _OracleResults(provider: provider)
                                : _InitialPrompt(mode: provider.cardMode),
                      ),
                      // Draw button
                      if (!provider.isDrawing)
                        MysticalButton(
                          text: provider.hasResults ? 'Draw Again' : 'Draw Card',
                          icon: Icons.auto_stories,
                          onPressed: () => provider.drawCards(),
                        ),
                      if (provider.hasResults) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => provider.reset(),
                          child: Text('Clear', style: TextStyle(color: AppColors.secondaryText(context))),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rosePink : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.rosePink : AppColors.softPurpleLight),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.primaryText(context),
        )),
      ),
    );
  }
}

class _InitialPrompt extends StatelessWidget {
  final int mode;
  const _InitialPrompt({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.softPurple.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology, size: 40, color: AppColors.softPurple),
          ),
          const SizedBox(height: 20),
          Text(
            mode == 1
                ? 'Draw a single oracle card\nfor daily guidance'
                : 'Draw three oracle cards\nfor past-present-future insight',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _DrawingAnimation extends StatefulWidget {
  @override
  State<_DrawingAnimation> createState() => _DrawingAnimationState();
}

class _DrawingAnimationState extends State<_DrawingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_controller.value * 3.14159 * 2),
                child: Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.softPurple, AppColors.rosePink],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.rosePink.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.psychology, color: Colors.white, size: 36),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('Drawing...', style: TextStyle(
            fontSize: 18, color: AppColors.softPurple, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _OracleResults extends StatelessWidget {
  final OracleProvider provider;

  const _OracleResults({required this.provider});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).locale.languageCode;

    return SingleChildScrollView(
      child: Column(
        children: provider.results.map((result) {
          final positionName = provider.getPositionName(result.position, locale);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MysticalCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Position badge
                  if (provider.cardMode == 3)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.rosePink.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        positionName,
                        style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.rosePink),
                      ),
                    ),
                  if (provider.cardMode == 3) const SizedBox(height: 12),
                  // Card name
                  Text(
                    result.card.localizedName(locale),
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 8),
                  // Divider
                  Container(height: 1, color: AppColors.rosePinkLight.withValues(alpha: 0.3)),
                  const SizedBox(height: 8),
                  // Message
                  Text(
                    '"${result.card.localizedMessage(locale)}"',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.primaryText(context),
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
