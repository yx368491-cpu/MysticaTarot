import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_card.dart';
import '../../domain/entities/zodiac_sign.dart';
import '../../providers/astrology_provider.dart';

/// Zodiac sign selection and horoscope page
class AstrologyPage extends StatelessWidget {
  const AstrologyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AstrologyProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('astrologyTitle')),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Zodiac grid
                    Expanded(
                      flex: provider.selectedSign != null ? 2 : 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.translate('selectZodiac'),
                                style: AppTextStyles.headingMedium),
                            // Error banner
                            if (provider.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.red, size: 16),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        provider.errorMessage!,
                                        style: const TextStyle(
                                          fontSize: 12, color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.85,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: provider.allSigns.length,
                                itemBuilder: (context, index) {
                                  final sign = provider.allSigns[index];
                                  final isSelected = provider.selectedSign == sign;
                                  return _ZodiacGridTile(
                                    sign: sign,
                                    icon: provider.getZodiacIcon(index),
                                    isSelected: isSelected,
                                    onTap: () => provider.selectSign(sign),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Selected zodiac detail
                    if (provider.selectedSign != null)
                      Expanded(
                        flex: 4,
                        child: _ZodiacDetail(sign: provider.selectedSign!),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ZodiacGridTile extends StatelessWidget {
  final ZodiacSign sign;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ZodiacGridTile({
    required this.sign,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).locale.languageCode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.rosePink.withValues(alpha: 0.2)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.rosePink : AppColors.softPurpleLight.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                sign.localizedName(locale),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.rosePink : AppColors.primaryText(context),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZodiacDetail extends StatefulWidget {
  final ZodiacSign sign;
  const _ZodiacDetail({required this.sign});

  @override
  State<_ZodiacDetail> createState() => _ZodiacDetailState();
}

class _ZodiacDetailState extends State<_ZodiacDetail> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).locale.languageCode;
    final provider = context.watch<AstrologyProvider>();
    final sign = provider.selectedSign!;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Tab bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                _TabButton(
                  label: 'Daily',
                  isSelected: _tabIndex == 0,
                  onTap: () => setState(() => _tabIndex = 0),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  label: 'Weekly',
                  isSelected: _tabIndex == 1,
                  onTap: () => setState(() => _tabIndex = 1),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  label: 'Monthly',
                  isSelected: _tabIndex == 2,
                  onTap: () => setState(() => _tabIndex = 2),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personality
                  _buildSection(
                    icon: Icons.face,
                    title: 'Personality',
                    content: sign.localizedPersonality(locale),
                  ),
                  const SizedBox(height: 12),
                  // Info row
                  Row(
                    children: [
                      _buildInfoChip(
                          '${provider.getElementIcon(sign.element)} ${sign.localizedElement(locale)}'),
                      const SizedBox(width: 8),
                      _buildInfoChip('⭐ ${sign.dates}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Horoscope
                  if (_tabIndex == 0)
                    _buildSection(
                      icon: Icons.today,
                      title: 'Daily Horoscope',
                      content: sign.localizedDaily(locale),
                    ),
                  if (_tabIndex == 1)
                    _buildSection(
                      icon: Icons.date_range,
                      title: 'Weekly Horoscope',
                      content: sign.localizedWeekly(locale),
                    ),
                  if (_tabIndex == 2)
                    _buildSection(
                      icon: Icons.calendar_month,
                      title: 'Monthly Horoscope',
                      content: sign.localizedMonthly(locale),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required String content}) {
    return MysticalCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.rosePink, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.rosePink)),
                const SizedBox(height: 6),
                Text(content, style: TextStyle(
                  fontSize: 14, color: AppColors.primaryText(context), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.softPurpleLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(
        fontSize: 12, color: AppColors.softPurpleDark, fontWeight: FontWeight.w500)),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rosePink : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.rosePink : AppColors.softPurpleLight,
          ),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.softPurpleDark,
        )),
      ),
    );
  }
}
