# Phase 7 Step 3 — Real-Device Flutter DevTools Profiling Recipe

**Target device**: Mid-range Android phone with 6-8 GB RAM running Android 12+
(Samsung A-series, Xiaomi Note, or similar; raw Flutter behavior on these
matches the 50th-percentile of active installs).

**Mode**: ALWAYS use `flutter run --profile`. Debug builds lie; release
builds obscure hot-path tracing. Profile mode is close to release while
still letting us connect DevTools.

---

## Step 1 — Enable developer mode on the phone

1. `Settings → About phone` → tap `Build number` 7 times
2. `Settings → System → Developer options` → enable `USB debugging`
3. Plug phone into PC via USB cable
4. Accept "Allow USB debugging" prompt on the phone (check "Always allow" if this is your dev phone)
5. Verify the phone is visible to adb: `adb devices` should list it.

> **OEM footnote** — Xiaomi / MIUI and Samsung One UI hide `Developer options`
> differently: on MIUI the path is `Settings → Additional settings →
> Developer options`; on One UI under `Settings → Developer options` is buried
> near the bottom. Functionality identical once you find it.

---

## Step 2 — Compile, launch, and connect DevTools

```bash
# From the project root (E:\APP).
flutter run --profile
```

The terminal will print:

```
A Dart VM Service is listening on http://127.0.0.1:xxxxx/
```

Press `v` (lowercase) in the terminal to spawn DevTools in your browser.
If `v` doesn't work, manually launch DevTools via:

```bash
flutter pub global activate devtools
flutter pub global run devtools
# Paste the VM Service URL from the previous step into the connection field.
```

---

## Step 3 — Frame trace (jank hunting)

1. In DevTools, open the **Performance** tab.
2. Click the settings gear → enable **Track Widget Builds** and **Track Layouts**.
3. Click **Record**.
4. **Reproduce the worst case** (the path thought to be most janky):

   | Step | Action |
   | ---- | ------ |
   | 1 | Launch app cold (kill it from recent apps first, then re-open). |
   | 2 | Skip onboarding (it has its own `@Tags(['slow'])`-isolated tests). |
   | 3 | From Home, tap **Tarot** → **3-Card Spread** → **Shuffle** (kicks off `shuffle_animation` for 3 s). |
   | 4 | Wait for draw to finish → open **Reading Result** page (renders 3 cards). |
   | 5 | Close → tap **Fortune Slip** (kicks off `drawSlip()`). |
   | 6 | Close → tap **Astrology** (kicks off zodiac JSON parse). |
   | 7 | Close → tap **Oracle Cards** (kicks off oracle JSON parse). |
   | 8 | Close → tap **Daily Card**. |
   | 9 | Force-quit and re-launch. |

5. **Click Stop**. Look at the timeline:
   * **Frame budget**: 16.6 ms = 60 fps; >16.6 ms = drop.
   * **Red bars** = UI (Build/Layout) phase — fix by `const` constructors, smaller Provider scopes.
   * **Yellow bars** = Raster (GPU) phase — fix by `RepaintBoundary` around repainting subtrees.
   * **Garbage-collection pauses**: spikes in the Raster phase around 200-300 ms — reduce allocation rate, cache images long-lived.

### Likely hotspots to look for (just prediction, not measured)

| Region | Phase | Likely cause | First attempt |
| ------ | ----- | ------------ | ------------- |
| Shuffle animation (0-3 s) | Raster | `Transform.translate` + `Transform.rotate` inside `AnimatedBuilder` repaint whole stack. | Wrap top-level `Stack` in `RepaintBoundary`; switch to `SlideTransition`/`RotationTransition` (auto-optimized). |
| Card flip animation | Raster | Manual `Matrix4.rotationY` rebuilds. | Wrap `Transform` in `RepaintBoundary`. |
| Reading result page render | UI | `Image.asset` decodes at full resolution; multiple rebuilds. | Add `cacheWidth`/`cacheHeight` to `Image.asset` (logical pixels × DPR). |
| First navigation to Astrology / Fortune / Oracle | JSON parse stall | `json.decode(await rootBundle.loadString(...))` runs on main isolate. | Move parse into `compute(json.decode, str)`. |

---

## Step 4 — Memory baseline

1. Open the **Memory** tab in DevTools.
2. Click **Snapshot** to capture the **baseline**.
   * Note `Dart Heap (Old)` and `Dart Heap (New)` separately.
   * Note `Rss` (resident set — total).
3. **Stress test**: open `Reading Result` 5 times in a row with different spreads.
4. Snapshot again.
5. **What to flag**:
   * Heap growth > 150 MB across 5 spread renders → image cache is bleeding.
   * `Rss` growth > 250 MB and not returning to baseline after closing reading page → leaks, audit `Dispose()` chains in `TarotReadingProvider`, `OnboardingProvider`, etc.
   * Snapshot shows `Retained Size` hotspots → potential leaks; check provider `dispose()` and `AnimationController.dispose()`.

### Memory sub-tab readings to interpret
* **Dart Heap Cap**: currently unconstrained (`null`). Consider setting
  `--dart-vm-options=--max-old-space-size=512` for safety on older devices.

---

## Step 5 — CPU profile (isolate stalls)

1. Open **CPU Profiler** tab. Click **Record**.
2. Navigate to **Astrology** (forces `json.decode` of zodiac_content.json).
3. Stop.
4. Bottom-Up tree → look at `_jsonParse` (or `decode` underneath `JsonCodec`).
5. **If `_jsonParse` runs on the main isolate for >16 ms**:
   * Wrap the `json.decode` call in `compute()` for background-isolate parsing.
   * Or pre-parse at app startup before any navigation begins.

---

## Step 6 — Battery / energy profiling

Most actionable via Android system tooling, NOT DevTools:

```bash
# Reset baseline.
adb shell dumpsys batterystats --reset

# Use the app for 10 minutes: onboarding, 3 spreads, daily card, oracle, fortune slip, history.

# Dump.
adb shell dumpsys batterystats mystica_tarot > /tmp/batterystats.txt

# Inspect.
grep -E "Wakelock|wakeup|move to background" /tmp/batterystats.txt
```

Look for:
* Excessive **partial wake lock** from `hive.box.compaction` or notifications.
* **Alarm wakeups** from `flutter_local_notifications` polling (if any).
* Excessive CPU time even when app is foreground-only — indicates main isolate is doing background work that should be in `compute()`.

---

## Frame-rate targets (acceptance criteria for "performance is good")

| Metric | Target | Acceptable | Unacceptable |
| ------ | ------ | ---------- | ------------ |
| Cold-start time (lock → home) | < 1.5 s | < 2.5 s | > 3 s |
| Frame rate during reading render (cool device) | sustained 60 | avg ≥ 55 | < 50 |
| Frame rate during shuffle / flip (cool device) | sustained 60 | avg ≥ 55 | < 50 |
| **Frame rate during shuffle / flip (thermal-throttled)** | ≥ 50 | ≥ 40 | < 35 |
| Frame rate during page push (route transition) | 60 | ≥ 55 | < 50 |
| Heap size after 30 min of normal use | < 200 MB | < 350 MB | > 500 MB (GC thrash) |
| Cold start battery drain (10 min session) | < 5% | < 8% | > 15% |

> Annotated row 4 explicitly accounts for reality: a 6 GB Android 12+ device
> running the 3 s `shuffle_animation` continuously will thermally throttle
> to 45–55 fps. This is not a regression — set expectations correctly.

---

## When to call Step 3 done

* The four standard user flows (tarot / fortune / astrology / oracle + daily) all stay
  above the "Acceptable" threshold on the test phone.
* No frame-rate drop >300 ms in 30 minutes of mixed use.
* Memory returns to baseline within 5 minutes of app going to background.
* All four JSON-decode stalls → moved to `compute()` if any of them >16 ms.
* Image cache pre-warming sized to logical pixels × DPR (no full-res decode).

---

## References

- Flutter Performance docs: https://docs.flutter.dev/perf
- DevTools Performance view: https://docs.flutter.dev/tools/devtools/performance
- DevTools Memory view: https://docs.flutter.dev/tools/devtools/memory
- `compute()` for background isolates: https://api.flutter.dev/flutter/foundation/compute.html
- Best practices for image cache: https://api.flutter.dev/flutter/widgets/Image/Image.asset.html
