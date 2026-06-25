import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_button.dart';
import '../widgets/onboarding_item.dart';
import '../../providers/onboarding_provider.dart';

/// Onboarding flow shown only on first launch (or after manual reset).
///
/// 4 slides: Welcome → Explore → Offline → Multilingual → Get Started.
/// Uses a [PageView] for swiping, animated dots progress indicator, and
/// tracks per-slide animation value for a polished entrance effect.
///
/// Completion is driven by [OnboardingProvider.markCompleted], which notifies
/// the parent Consumer inside `app.dart` and swaps the home widget
/// automatically — no explicit callback wiring needed.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const int _pageCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _complete();
    }
  }

  void _skip() {
    _complete();
  }

  Future<void> _complete() async {
    if (!mounted) return;
    await context.read<OnboardingProvider>().markCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar: skip button (hidden on last slide)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_currentPage < _pageCount - 1)
                      TextButton(
                        onPressed: _skip,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.rosePink,
                        ),
                        child: Text(
                          l10n.translate('skip'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 64, height: 32),
                  ],
                ),
              ),
              // Sliding pages with per-slide animation tracking
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _kOnboardingSlides.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        final page = _pageController.page;
                        if (page != null) {
                          value = (1 - (page - index).abs()).clamp(0.0, 1.0);
                        }
                        final slide = _kOnboardingSlides[index];
                        return OnboardingItem(
                          icon: slide.icon,
                          title: l10n.translate(slide.titleKey),
                          description: l10n.translate(slide.descKey),
                          animationValue: value,
                        );
                      },
                    );
                  },
                ),
              ),
              // Dot pagination
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pageCount, (i) {
                    final selected = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: selected ? 28 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.rosePink
                            : AppColors.rosePink.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
              // Bottom CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
                child: MysticalButton(
                  text: _currentPage == _pageCount - 1
                      ? l10n.translate('start')
                      : l10n.translate('next'),
                  icon: _currentPage == _pageCount - 1 ? Icons.celebration : null,
                  onPressed: _nextPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideData {
  final IconData icon;
  final String titleKey;
  final String descKey;

  const _SlideData({
    required this.icon,
    required this.titleKey,
    required this.descKey,
  });
}

/// Static slide definitions — kept at class scope so they're not reallocated on
/// every Consumer rebuild (locale/theme changes happen frequently).
const List<_SlideData> _kOnboardingSlides = [
  _SlideData(
    icon: Icons.auto_stories,
    titleKey: 'onboardingWelcome',
    descKey: 'onboardingWelcomeDesc',
  ),
  _SlideData(
    icon: Icons.dashboard_customize,
    titleKey: 'onboardingExplore',
    descKey: 'onboardingExploreDesc',
  ),
  _SlideData(
    icon: Icons.cloud_off,
    titleKey: 'onboardingOffline',
    descKey: 'onboardingOfflineDesc',
  ),
  _SlideData(
    icon: Icons.translate,
    titleKey: 'onboardingMultilingual',
    descKey: 'onboardingMultilingualDesc',
  ),
];
