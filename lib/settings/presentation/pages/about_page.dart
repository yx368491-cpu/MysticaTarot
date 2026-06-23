import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/gradient_background.dart';

/// Full About screen.
///
/// Sections:
/// 1. Hero — app name, tagline, version
/// 2. Features — list of divination methods
/// 3. Card Artwork — RWS / Wikimedia Commons attribution
/// 4. Privacy — fully-offline guarantee
/// 5. Open Source — dependency acknowledgements
/// 6. License — MIT link
/// 7. Disclaimer — entertainment-only note
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Hardcoded list — same in every locale (package names are not translated).
  static const List<_OpenSourceCredit> _kOpenSourceCredits = [
    _OpenSourceCredit(name: 'Flutter', license: 'BSD-3-Clause'),
    _OpenSourceCredit(name: 'Provider', license: 'MIT'),
    _OpenSourceCredit(name: 'Hive / Hive Flutter', license: 'Apache-2.0'),
    _OpenSourceCredit(name: 'flutter_local_notifications', license: 'BSD-3-Clause'),
    _OpenSourceCredit(name: 'audioplayers', license: 'MIT'),
    _OpenSourceCredit(name: 'share_plus', license: 'BSD-3-Clause'),
    _OpenSourceCredit(name: 'intl', license: 'BSD-3-Clause'),
  ];

  // Wikimedia Commons category landing page for the RWS Tarot (Geldard).
  static const String _kWikimediaUrl =
      'https://commons.wikimedia.org/wiki/Category:Rider-Waite-Smith_tarot_deck_(Geldard)';

  // MIT license text on the official SPDX page.
  static const String _kMitLicenseUrl =
      'https://opensource.org/licenses/MIT';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('aboutTitle')),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Hero(l10n: l10n),
                const SizedBox(height: 20),
                _Section(
                  icon: Icons.auto_awesome,
                  title: l10n.translate('aboutSectionFeatures'),
                  child: Text(
                    l10n.translate('aboutFeatureList'),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                _Section(
                  icon: Icons.image,
                  title: l10n.translate('aboutSectionArt'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('aboutArtAttribution'),
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      const _ExternalLink(
                        label: 'aboutLinkWikimedia',
                        url: _kWikimediaUrl,
                      ),
                    ],
                  ),
                ),
                _Section(
                  icon: Icons.shield_outlined,
                  title: l10n.translate('aboutSectionPrivacy'),
                  child: Text(
                    l10n.translate('aboutPrivacyBody'),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                _Section(
                  icon: Icons.code,
                  title: l10n.translate('aboutSectionOpenSource'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('aboutOpenSourceIntro'),
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      ..._kOpenSourceCredits.map(
                        (c) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons
                                  .chevron_right_rounded, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${c.name}  ·  ${c.license}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _Section(
                  icon: Icons.gavel_outlined,
                  title: l10n.translate('aboutSectionLicense'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('aboutLicenseBody'),
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      const _ExternalLink(
                        label: 'aboutLinkLicense',
                        url: _kMitLicenseUrl,
                      ),
                    ],
                  ),
                ),
                _Section(
                  icon: Icons.info_outline,
                  title: l10n.translate('aboutSectionDisclaimer'),
                  child: Text(
                    l10n.translate('aboutDisclaimerBody'),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final AppLocalizations l10n;
  const _Hero({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.rosePink.withValues(alpha: 0.18),
            AppColors.softPurple.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.rosePink.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // App mark — concentric gradient halo + symbolic mark.
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.rosePink.withValues(alpha: 0.5),
                  AppColors.softPurple.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.rosePink, AppColors.softPurple],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.rosePink.withValues(alpha: 0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_stories,
                    color: Colors.white, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppConstants.appName,
            style: AppTextStyles.mysticalTitle,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.translate('aboutTagline'),
            style: AppTextStyles.mysticalSubtitle,
          ),
          const SizedBox(height: 6),
          Text(
            '${l10n.translate('version')} ${AppConstants.version}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.rosePink,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.translate('aboutHero'),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _Section({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.rosePink.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.rosePink, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.rosePink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ExternalLink extends StatelessWidget {
  final String label;
  final String url;
  const _ExternalLink({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    // About-page links: render both label (readable attribution like
    // "Wikimedia Commons") and URL (so users can long-press + copy the
    // exact address). MysticaTarot does not depend on url_launcher to keep
    // the surface area small.
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate(label),
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.softPurple.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link, size: 14, color: AppColors.softPurple),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  url,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.softPurple,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OpenSourceCredit {
  final String name;
  final String license;
  const _OpenSourceCredit({required this.name, required this.license});
}
