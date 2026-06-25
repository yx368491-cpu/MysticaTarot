# MysticaTarot Accessibility Audit

> Last reviewed: 2026-06-23
> Scope: Phase 6 preliminary baseline — covers touch targets, contrast, semantics, and i18n considerations for EN/ZH/TL.

## Touch Target Sizes

| Widget | Min size | Status |
|--------|----------|--------|
| `MysticalButton` | 52 dp height | OK (>48 dp Material guideline) |
| Settings tiles | full-width, ≥48 dp | OK |
| Bottom nav items | icon 24 + label, vertical 56 dp | OK |
| Card grid (HomePage) | 1:1 cards, ≥140 dp | OK on 360 dp+ screens |
| Mystical CTA dot indicators | 8 dp wide hit area | **Borderline** — recommend 24 dp tap target |

**Recommendation**: wrap onboarding dots in a `Semantics(label: 'page X of Y')` widget with tappable area expansion.

## Color & Contrast

### Light theme

- Primary text on light card: `AppColors.textPrimary` (#2D1B3E-ish deep violet) on white — AA passes (≥7:1)
- Secondary text: `textSecondary` on white — passes AA for body text
- Decorative gradient (rose → purple) used as background — body text on this gradient uses the high-contrast text color, never the gradient itself

### Dark theme

- `textOnDark` (light lavender, ~#E8C8E0) on `darkBackground` (~#1A1025) — passes AA
- `gold` accent (#E8C87A) on dark background — passes AA for headings ≥ 18 dp

**Note**: contrast on particle backgrounds may dip below WCAG AA threshold when many particles overlap; tested positions still keep text within AA compliance.

## Semantics Coverage

| Area | Semantics status |
|------|-------------------|
| Tarot card images | Add `Semantics(label: 'The Fool, upright meaning')` |
| Divination cards (home grid) | Add `Semantics(label: 'Tarot reading')` |
| Reading result positions | `Text` widgets already-announce position names; OK |
| Settings switches | Material Switch has built-in On/Off semantics; OK |
| Onboarding Skip/Next/Get Started buttons | `TextButton`/`MysticalButton` have built-in button semantics; OK |

## Text Scaling (large font mode)

**Status**: untested. Default `MediaQuery.textScaleFactor` accepts up to ~1.5× on Android. Risk:

- Daily-divination grid (5 cards) in HomePage may overflow at 1.3×
- About page column with 5 OSS credits should reflow — already in `SingleChildScrollView` ✅
- Settings list with — already in `ListView` ✅

**Recommendation**: smoke-test on emulator with `TextScale.linear(1.5)` to identify overflow.

## Localization Layout

| Locale | Read direction | Status |
|--------|----------------|--------|
| en | LTR | Reference layout |
| zh | LTR | Tested |
| tl | LTR | Tested |

**RTL support**: not warranted — none of en/zh/tl is RTL. Skip `Directionality` work for now.

## Reduced Motion

**Status**: not handled. Animations use fixed durations regardless of OS-level "Reduce Motion" setting.

**Recommendation**: check `MediaQuery.disableAnimations` (or platform's `Reduce Motion`) and disable:

- Shuffle animation (use static state)
- Card flip 3D rotation (snap to revealed state)
- Onboarding entrance fade

## Color-Blindness

Status: not explicitly tested. The `gold`/`success` colors used for upright-card badges may be indistinguishable for deuteranopia/protanopia users.

**Recommendation**: add a small text label ✕/✓ or short text suffix on badge ("Reversed" alone is fine since `Reversed` text is already shown).

---

## Cross-references

- Particle-background contrast concerns: see `docs/performance-audit.md`
- Material Switch semantics coverage (built-in On/Off): tracked as adequate; revisit if custom toggle widgets are added
- Onboarding dot hit-area: see `docs/development-log.md` Phase 5 onboarding flow
- Sound-effects accessibility (no haptics yet): see `docs/development-log.md` Phase 4.5

---

> Following WCAG 2.1 AA. Full screen-reader test (TalkBack) pending a real device.
