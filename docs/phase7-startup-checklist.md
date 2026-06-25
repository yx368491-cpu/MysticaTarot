# Phase 7 Startup Checklist

**Audience**: maintainer / next contributor working on real-device performance.
**Input**: `docs/profiling-recipe.md` (DevTools walkthrough) +
`docs/development-log.md` Phase 7 entry + bug-log entries #001-#004.

---

## Golden rule

**Profilio FIRST, optimize SECOND.** Do not touch code in the form below
until DevTools (`flutter run --profile`) confirms the suspected hot red bars.

Phantom optimizations (e.g. blanket `const` audit, pre-warm 78-card image
cache, move Hive loading to isolate) are flagged with **DON'T** so they
don't pull you into a 2-day yak shave without a measurement to back it.

---

## Priority order (by ROI)

### P0 — Profile first (mandatory)

- [ ] Run `docs/profiling-recipe.md` Steps 1-6 end to end on the 6 GB Android
      target phone.
- [ ] Capture all six traces (cold start, shuffle, reading render, fortune,
      astrology, oracle, daily card).
- [ ] Save the resulting timeline JSON files under
      `docs/profile-traces/2026-XX-XX/` for diff comparison next pass.

**Why first**: any optimization without a measurement is guessing. Spend
half a day here before touching code.

---

### P1 — Image decode budget (high ROI / low effort)

**Trigger**: if `Image.asset` shows up in the memory allocation track OR
heap grows >150 MB across 5 spread renders.

- [ ] Add `cacheWidth` and `cacheHeight` parameters to every `Image.asset` call.
- [ ] Logical pixel size = widget size × 3 (typical phone DPR).
- [ ] Audit `lib/features/tarot/presentation/widgets/tarot_card_widget.dart`
      and `lib/features/home/presentation/widgets/daily_card_widget.dart` first.
- [ ] **DON'T** pre-warm the cache with 78 cards on app startup — that path
      loads ALL card PNGs into RAM and will OOM older devices.

**Why now**: the 78-card asset catalog is the largest single RAM consumer
in the app; caching with explicit size is a one-line fix.

---

### P2 — Repaint boundaries (high ROI for animation tracks)

**Trigger**: yellow Raster bars where the **Raster** phase > 8 ms during
`shuffle_animation` or `card_flip_animation`.

- [ ] Wrap the top-level `Stack` in
      `lib/features/tarot/presentation/widgets/shuffle_animation.dart`
      inside a `RepaintBoundary`.
- [ ] Wrap the 3D `Transform` in
      `lib/features/tarot/presentation/widgets/card_flip_animation.dart`
      inside a `RepaintBoundary`.
- [ ] **Optionally** switch `Transform.translate/rotate` to
      `SlideTransition`/`RotationTransition` so Flutter's animation
      pipeline can layer-cache automatically.

---

### P3 — JSON decode on main isolate (medium ROI)

**Trigger**: when the user navigates to Astrology / Fortune / Oracle, the
UI phase shows `_jsonParse` or `JsonCodec.decode` calls. Use **30 ms**
(not 16 ms) as the boundary — 16 ms is the per-frame budget on a hot
device; on the 6 GB Android 12 target, a single JSON parse easily reads
in 18-25 ms without user-facing jank; the user-visible stutter floor is
closer to 30-40 ms. Anything under the lower threshold is fine to leave
on the main isolate.

- [ ] Wrap the `json.decode(...)` call in
      `lib/features/astrology/services/astrology_service.dart`,
      `lib/features/fortune_slip/services/fortune_slip_service.dart`, and
      `lib/features/oracle_cards/services/oracle_reading_service.dart`
      inside `compute(json.decode, str)` to parse on a background isolate.
- [ ] **DON'T** move Hive loading to isolate by default — only if DevTools
      shows `Hive.openBox` blocking startup. (See P4 below — moving JSON
      parse to a background isolate is independent from deferring Hive
      box opens; both are valid but solve different problems.)

**Why still here**: the rootBundle read is async; the parse is what
blocks. Until profile confirms.

---

### P4 — Hive lazy-load (medium-low ROI)

**Trigger**: cold-start timeline shows `Hive.openBox` taking >8 ms.

- [ ] Audit `lib/main.dart` for how many boxes are opened synchronously.
- [ ] If `reading_records` and `daily_cards` are both opened inline,
      defer the non-critical one until first feature access (e.g. open
      `reading_records` lazily in the History page's `initState`).
- [ ] **DON'T** close Hive boxes from the splash screen unless
      DevTools shows disk IO contention.

---

### P5 — `const` audit (low ROI / high volume)

**Trigger**: DevTools shows `Build` (not Raster) phase >8 ms in widget
trees with no animation.

- [ ] Run `dart fix --apply` to get free `prefer_const_constructors`
      conversions.
- [ ] For static list/map literals in widgets, add `const` manually.
- [ ] **DON'T** blanket-wrap everything — focus only on widgets inside
      dynamic trees (e.g. inside `Consumer<...>` builders).

---

### P6 — `Provider` scope audit (low ROI)

**Trigger**: DevTools shows `notifyListeners()` callbacks causing full
subtree rebuilds even though only one leaf needs updating.

- [ ] Change top-level `ChangeNotifierProvider<X>` to scoped per feature
      page when a notify is mostly relevant only locally.
- [ ] Use `Selector<X, Y>` (or `context.select<X, Y>((x) => x.field)`)
      for hot computations.

---

### P7 — i18n lazy-load (low ROI)

**Trigger**: localized string tables grow past 10 KB.

- [ ] If `resources/l10n/*.arb` files cross ~30 KB total,
      split per-feature.
- [ ] Use `GenLocalizations.of(context).translate(key)` only where
      needed; avoid eager fetching in `init()`.

---

## Premature-optimization risks (explicit DO-NOT list)

These cost more time than they save without a measurement to back them:

- ❌ Pre-loading all 78 card PNGs at app startup.
- ❌ Moving `Hive.openBox` to a background isolate.
- ❌ Hashing the entire `ReadingRecord.toJson()` on every save (Hive stores
   raw maps — no need to hash unless diffing).
- ❌ Replacing `Provider` with `Riverpod` solely for performance.
- ❌ Switching to `Skia` → `Impeller` (default already; only if low-end
   phones stutter with `Impeller` — which they don't in recent Flutter).
- ❌ Writing a custom `ShaderMask` for card backs without measuring jank.

---

## Acceptance criteria (what it means to be done)

- [ ] All six user flows covered in `docs/profiling-recipe.md` show
      **Acceptable** frame rate (≥55 fps avg) on the 6 GB Android target.
- [ ] Memory returns to baseline within 5 minutes of background.
- [ ] No frame-rate drop > 300 ms in 30 minutes of mixed use.
- [ ] Cold start ≤ 2.5 s.
- [ ] 30-minute battery drain < 8% (tested via `dumpsys batterystats`).
- [ ] No new exception types reported in Play Console pre-release track.
- [ ] All changes linked to a real DevTools measurement — no
      "I thought this would be faster" PRs.

---

## Future-phase hooks (not Phase 7, but worth tracking)

* `flutter run --profile` automated in CI via integration_test +
  `flutter_driver` extension → frame-rate budgets enforced on every PR.
* APM SDK (Sentry / Firebase Crashlytics / AppDynamics) for production
  frame-rate + ANR tracking once app has real installs.
* Per-locale content delivery (e.g. en/zh only on cold install, tl
  on first-time visit) — minor storage savings at scale.
