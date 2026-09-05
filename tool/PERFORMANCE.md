# tool/PERFORMANCE.md — Performance, Size & Memory Playbook

Advanced, **runnable** guide for auditing and fixing this app's performance, memory, code hygiene
and binary size. Written for an AI agent (and humans): every section has copy-paste commands, what
to look for, and the concrete fix tied to `RULES.md` / `DESIGN.md`. Run `tool/audit.sh` for the
one-shot static pass; use the deeper sections for profiling.

> Golden order: **1) clean static → 2) shrink size → 3) profile speed → 4) profile memory.**
> Don't profile a dirty tree; fix analyzer + unused code first so the signal is clean.

---

## 0. One-shot audit

```bash
bash tool/audit.sh          # analyze + format-check + unused imports + dep check + size hint
```
It's read-only except where noted. Fix everything it flags before profiling.

---

## 1. Static hygiene — analyzer, unused imports, dead code

```bash
flutter analyze                     # must be 0 issues (except vendored third_party)
dart fix --dry-run                  # preview auto-fixable lints (unused imports, const, ...)
dart fix --apply                    # apply them
dart format lib/                    # canonical formatting
```

- **Unused imports / locals / `const`** are enabled in `analysis_options.yaml` and auto-fixed by
  `dart fix --apply`. Re-run `flutter analyze` after to confirm 0.
- **Unused files** (nothing imports them): dart won't flag these — find manually:
  ```bash
  # list every lib dart file that is never imported anywhere
  for f in $(find lib -name '*.dart'); do
    base=$(basename "$f");
    grep -rql --include=*.dart "$base" lib --exclude="$f" || echo "UNIMPORTED: $f";
  done
  ```
  Review before deleting (entrypoints like `main.dart` and generated files are expected).
- **Unused pub packages** (declared but never imported):
  ```bash
  dart pub global activate dependency_validator   # once
  dart pub global run dependency_validator        # lists unused / missing / under-promoted deps
  ```
  Remove unused deps from `pubspec.yaml` → smaller build, faster resolves.

Fixes map to: `RULES.md §12` (no dead code), `§6` (`const` skips rebuilds).

---

## 2. App size — measure then shrink

### Measure
```bash
# Android (per-ABI, real download size breakdown)
flutter build apk --analyze-size --target-platform android-arm64
flutter build appbundle --analyze-size            # what Play actually ships
# iOS
flutter build ios --analyze-size
```
`--analyze-size` prints a tree and writes a snapshot you can open in **DevTools → App Size Tool**
(File → Load size analysis). Look for: oversized assets, fonts, a dependency dragging in a big
transitive tree.

### Shrink
- **Split ABIs** (don't ship arm+arm64+x86 in one APK): `flutter build apk --split-per-abi`
  (or ship an **app bundle** — Play splits automatically). Biggest single win.
- **Tree-shake icons** happens automatically in release; keep it working by using `const IconData`
  from `Icons.*`, not dynamic icon lookups.
- **Assets:** compress PNGs, prefer WebP, drop unused files in `assets/`. Only list needed dirs in
  `pubspec.yaml`. Provide only the resolutions you use.
- **Fonts:** ship only weights you use (this repo ships Lato 400/700 — don't add more without need).
- **Remove unused deps** (§1) — each pulls transitive code.
- **R8/ProGuard** (Android release) shrinks + obfuscates Dart-adjacent Kotlin/Java; keep
  `minifyEnabled`/`shrinkResources` on for release (default in newer templates).
- Always compare **release** size, never debug: `flutter build apk --release`.

---

## 3. Speed — profile, find jank, fix rebuilds

**Always profile in profile mode on a real device** (debug is not representative):
```bash
flutter run --profile
```
Then open **DevTools → Performance**:
- **Timeline / Frame chart:** frames must stay under the budget (≈16ms @60Hz, ≈8ms @120Hz). Red
  frames = jank. A tall **UI** bar = expensive `build`/layout; a tall **Raster** bar = expensive
  painting (shadows, opacity, clips, blurs).
- **Rebuild profiler (Widget rebuild stats):** find widgets rebuilding every frame. In code:
  ```dart
  import 'package:flutter/rendering.dart';
  // in main() during a debug session:
  debugProfileBuildsEnabled = true;      // build timings in the timeline
  // spot-check who rebuilds:
  debugPrintRebuildDirtyWidgets = true;  // logs each dirty widget rebuild
  ```

### Fixes (repo-specific, from RULES.md §3/§6, DESIGN.md §8)
- **Tighten `Obx`** to the smallest subtree that reads the `.obs`. A screen-wide `Obx` rebuilds
  everything on any change.
- **`GetBuilder` + `update()`** for coarse/batched state (tab index, form step) — cheaper than `.obs`.
  Scope with `update(['id'])` + `GetBuilder(id:'id')`.
- **`const` everything** you can — const widgets are skipped on rebuild (lints now enforce it).
- **Lists:** `ListView.builder`/`.separated`, never a mapped `Column`. Add `itemExtent` when uniform.
- **Images:** `cacheWidth`/`cacheHeight` to decode downscaled; `cached_network_image` for network.
- **Raster jank:** avoid stacked `Opacity`/`ClipRRect`/`BoxShadow`; wrap independently-animating
  subtrees in `RepaintBoundary`; prefer `borderRadius` on decoration over `ClipRRect` where possible.
- **No work in `build()`** — API calls / heavy compute go to `onInit()`; parallelise with
  `Future.wait`; debounce input; cancel stale requests with `CancelToken`.
- **Startup:** keep `initServices()` lean; `lazyPut` route deps so nothing builds before its screen.

---

## 4. Memory — leaks, retention, growth

Open **DevTools → Memory** (in `--profile` or `--debug`):
- **Watch the trend:** navigate in and out of a screen repeatedly, then GC (🗑). If memory keeps
  climbing and doesn't return, something is retained.
- **Leak checklist (this repo):**
  - Every `TextEditingController`, `Timer`, `StreamSubscription`, `CancelToken`, `AnimationController`
    you create is disposed in `onClose()` (controllers) / `dispose()` (State). Grep:
    ```bash
    grep -rn "TextEditingController\|Timer(\|listen(\|CancelToken(\|AnimationController" lib
    # each hit must have a matching cancel/dispose in onClose/dispose
    ```
  - Non-`permanent`, non-`fenix` GetX deps auto-dispose on route pop — that's the memory model. Don't
    mark things `permanent`/`fenix` unless they must outlive their route (`RULES.md §4`).
  - Remove a dep you no longer need: `Get.delete<C>()`. Hard reset (tests/logout): `Get.reset()`.
  - Large lists: don't hold full-resolution images in memory — decode with `cacheWidth`.
  - Don't keep growing an `.obs` list — `assignAll` replaces; unbounded `.add` in a stream leaks.
- **Snapshot diffing:** take a heap snapshot, do the action, snapshot again, diff to see what class
  count grew. Rising `GetxController`/`State`/`Element` counts across identical navigations = leak.

---

## 5. Repeatable AI audit loop

1. `bash tool/audit.sh` → fix every finding (analyzer, format, unused imports, unused files/deps).
2. `dart fix --apply && flutter analyze` → 0 issues.
3. `flutter build appbundle --analyze-size` → note size, shrink per §2, re-measure.
4. `flutter run --profile` + DevTools Performance → kill red frames per §3.
5. DevTools Memory → run the leak checklist §4; navigate-loop and confirm flat memory.
6. Record before/after (size KB, worst-frame ms, memory MB) in the PR description.

Each fix must trace to a rule in `RULES.md`/`DESIGN.md`; if a needed rule is missing, add it there.
