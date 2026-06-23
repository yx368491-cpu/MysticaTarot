# MysticaTarot Performance Audit

> Last reviewed: 2026-06-23
> Scope: Phase 6 preliminary baseline — desktop-mode run, no on-device profiling yet.

## Asset Inventory

| Asset | Format | Size | Source |
|-------|--------|------|--------|
| Playfair Display (regular + italic) | Variable OTF | ~560 KB | Google Fonts |
| Noto Serif SC | Variable TTF | **~11 MB** | Google Fonts |
| Tarot card images (78) | PNG | varies | Wikimedia Commons |
| Sound effects (4) | WAV (placeholder) | small | local |

## Hot Paths & Cost-Relevant Code

### Loading

| Path | Mechanism | Cost |
|------|-----------|------|
| Tarot JSON | `rootBundle.loadString` once, cached in `_allCards` | < 50 ms |
| Zodiac JSON | `rootBundle.loadString` once, cached in `_allSigns` | < 20 ms |
| Oracle JSON | `rootBundle.loadString` once, cached in `_allCards` | < 20 ms |
| Fortune-slips JSON | `rootBundle.loadString` once, cached | < 20 ms |
| Hive boxes | `Hive.openBox` × 4 on app start | ~100–200 ms |

### Animation Cost

| Animation | Duration | Notes |
|-----------|----------|-------|
| Card flip (3D) | 800 ms × N cards | `AnimationController` per card |
| Shuffle | 3 s | Single controller |
| Mystical CTA | implicit (Curves.easeOutCubic) | GPU-cheap |
| Page transitions | 300 ms | Standard Material |
| Onboarding entrance | staggered fade + scale | 4 slides, low cost |

### Memory Considerations

- All 78 tarot Json objects kept in memory after first load (`TarotProvider._allCards`) — typical megabyte residence
- Particle effect widget spawns up to 25 light circles — negligible
- Reading history capped at `maxHistoryCount` (500) — bounded growth in Hive

## Known Concerns & Recommendations

### High Priority

1. **Noto Serif SC 11 MB** — dominant onboarding cost on first install
   - **Recommendation**: ship a character-subset font (Chinese 6,000 most-used glyphs ≈ 3 MB) or use Google Fonts dynamic loading via `google_fonts` package
2. **Tarot PNG images** — many are 300×520 px with no compression
   - **Recommendation**: convert to WebP at 80% quality → ~30-40% size reduction; or bundle as `assets/images/cards.webp` listing in pubspec
3. **78 card images are decoded individually** on grid/list views
   - **Recommendation**: prefetch visible cards with `precacheImage` in the HomePage / TarotHomePage initState

### Medium Priority

4. **No memoization of `CardInterpretation`** — `interpretCard()` returns a fresh CardInterpretation on each call (acceptable since answer depends on `isReversed`)
5. **OnboardingProvider `init()` re-reads Hive every app launch** — fine in practice but if profile grows consider an in-memory cache invalidation flag
6. **`ParticleEffect` widget uses 25 individual `AnimatedBuilder`s** — would benefit from a single CustomPainter-based particle system

### Low Priority

7. **Day-of-week judgment strings** are computed every build for numerology — could be memoized but cost is sub-millisecond
8. **Sound effect players** are short-lived `AudioPlayer` instances — confirm proper `.dispose()` to avoid leaks (currently in `playShuffle/playFlip/playReveal`)

## Profiling Recipe

When investigating jank on device:

```bash
flutter run --profile
# Open DevTools → Performance tab → Record
# Verify frames stay below 16ms (60 Hz target)
```

Hot spots to look at during a shuffle → flip → reveal session:

1. `TarotReadingService.shuffleCards()` — List.of+shuffle cost
2. `TarotCardContent.loadAll()` — JSON parse
3. `Provider.notifyListeners()` cascade on language switch — MaterialApp rebuild
4. `MysticalButton` ripple paint

## Multi-Device Compatibility Notes

- **SafeArea** wrapped at every screens with `IndexedStack` body — handles notches
- **Touch targets** — base `MysticalButton` height 52 dp (above 48 dp minimum)
- **DPI scaling** — image assets are 300 px wide; safe down to 360 dp screens; below 320 dp shows visible pixelation on 78-card grids (test target: minimum 360 dp width)
- **Orientation** — locked to portrait via Flutter system (not explicitly enforced yet but design assumes portrait; horizontal layout not validated)

## Open Follow-ups

- [ ] Add `google_fonts` for runtime font loading (current Noto Serif SC is 11 MB)
- [ ] Convert 78 PNGs to WebP via `cwebp` script (~30-40% size reduction)
- [ ] Mobile-device Flutter run with `--profile` + Perfetto trace on Pixel 4a / Pixel 6
- [ ] CustomPainter-based particle effect (replace 25 AnimatedBuilder)
- [ ] Single-widget SharedAxis transition during Refresh history vs cache

---

## Cross-references

- Test-hang Windows investigation (PageView + Hive tempBox): see `docs/bug-log.md` Bug #003
- Phase 4 daily-card cache decisions that affect hot-path: see `docs/development-log.md` Phase 4
- Sound player lifecycle (currently created on demand): tracked under Bug #003 follow-up

---

> This document is intentionally modest — full perf profiling will follow once we have a device available.
