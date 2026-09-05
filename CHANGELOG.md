# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Removed
- `TextApp`, `TextFieldApp`, `ScaffoldApp`, `AppBarApp` widget wrappers. Text/input/button styling
  now comes from the **global theme** (`appTheme`: `appTextTheme`, `inputDecorationTheme`,
  `elevatedButtonTheme`) — screens use raw `Text('x', style: kTitle)` / `TextFormField` /
  `ElevatedButton`. `AppbarTemplate` is the single screen foundation for scaffold + app bar.

### Added
- `ADAPTIVE.md` — multiplatform adaptive-UI guide (Sizer scaling + breakpoints; phone/tablet/
  desktop/web; theme as the single appearance source).
- `helpers/utils/responsive.dart` — `BuildContext` extensions (`isPhone/isTablet/isDesktop`,
  `responsive(phone:,tablet:,desktop:)`, `contentMaxWidth`, orientation, platform) for one-codebase
  adaptive layout.
- `appTheme` extended into a full appearance system: `textButtonTheme`, `outlinedButtonTheme`,
  `cardTheme`, `dividerTheme`, `chipTheme`, `dialogTheme`, `bottomSheetTheme`, `snackBarTheme`,
  `progressIndicatorTheme` — raw `Card`/`Chip`/`Dialog`/`SnackBar`/… come out uniform, no per-screen styling.
- Animation playbook (RULES.md §6A) and a Memory-leak/lifecycle + Performance/adaptive review
  section (AGENTS.md).
- `setup.sh`: auto-normalises the package name to lowercase_snake ("My App"/"my-app" → "my_app"),
  lowercases org, and sets the display name across Android + iOS (`CFBundleDisplayName`/`CFBundleName`)
  + web (`index.html` title, `manifest.json` name/short_name).
- `setup.sh` is now **in-place by default**: the cloned folder itself becomes the finished app —
  no sibling/extra folder is created (fixes the confusing two-folder flow). It generates platform
  dirs into the clone, renames, applies mode, then removes the boilerplate git history + `setup.sh`.
  New `-y` (non-interactive, defaults) enables a true one-command scaffold
  (`git clone --depth 1 <repo> "$APP" && cd "$APP" && ./setup.sh -y -n "$APP"`); `-p DIR` keeps the
  old build-into-a-new-dir behaviour. Verified end-to-end (single folder, renamed, analyze clean).
- `setup.sh -m slim|standard`: **slim** (default) strips `webview_flutter` / `flutter_pdfview` /
  `file_picker` (+ unused `path_provider` / `timeago` / `form_field_validator`) and their template
  files for a smaller, fewer-native-deps build; **standard** keeps everything.
- Global `inputDecorationTheme` + `elevatedButtonTheme` in `appTheme` so raw fields/buttons are
  consistent app-wide.

### Removed
- Dead `textScale` map from `theme.dart` (was only used by the deleted `TextApp`).
- `HomePage` and `LoginPage` refactored onto `AppbarTemplate` as reference samples of the foundation.
- `AppbarTemplate` full-custom hooks: `titleStyle`, `titleWidget`, `leading`, `systemOverlayStyle`,
  `bottomSafe` (iOS/Android bottom inset), `resizeToAvoidBottomInset`. Shared `kAppBarTitle` style so
  every screen's title font is identical by default yet overridable.
- RULES.md + DESIGN.md + GETX_CHEATSHEET.md substantially expanded (grounded in the mature
  reference app): folder-structure reminder, Obx-vs-GetBuilder decision, full DI lifecycle
  (call/delete/reset/reload/replace/fenix), performance & memory, zero-overflow layout, whitespace
  scale, four-state UI/UX defaults, safe area (top+bottom), consistent+customisable status bar.
- `AppBarApp` — single global app bar wrapper (`shared/widgets/app_bar_app.dart`) so every
  screen's top bar shares one title style / height / color.
- `appTheme` `ThemeData` in `shared/theme.dart`, wired into `GetMaterialApp` (`main.dart`).
- Adaptive status bar `appOverlayStyle(brightness)`, `.sp`-scaled text styles
  (`kH1`/`kH2`/`kTitle`/`kBody`/`kBodySm`/`kCaption`/`kButton`) + `appTextTheme`, and radii
  tokens (`rSm`/`rMd`/`rLg`) in `shared/theme.dart` (adopted from the reference app).
- Optional `modules/<feature>/datas/` convention for hardcoded / mock slice data, with an
  example (`modules/home/datas/news_sample.dart`).
- `GETX_CHEATSHEET.md` — GetX patterns (state, DI, routing, workers) mapped to this repo.
- `tool/PERFORMANCE.md` + `tool/audit.sh` — advanced runnable playbook for perf/size/memory audit,
  unused-import/file/dep cleanup, speed tuning and app-size shrinking (AI-oriented).
- `tool/SECURITY.md` + `tool/security_audit.sh` — security audit playbook + static scanner (hardcoded
  secrets, cleartext http, secrets-in-logs, disabled TLS, insecure token storage, git-history, deps).
  Added secrets/signing entries to `.gitignore`; pdfview sample URL switched to https.
- Perf/hygiene lints enabled in `analysis_options.yaml` (`prefer_const_*`, `avoid_unnecessary_containers`,
  `prefer_final_locals`, …); ran `dart fix --apply` (47 fixes) so the boilerplate ships lint-clean.

### Changed
- `AGENTS.md` rewritten as a Flutter/GetX PR-review checklist (was a stale non-Flutter copy).
- `DESIGN.md` rewritten for Flutter (Sizer `.sp`/`.w`/`.r`, `*App` wrappers, safe area, app bar,
  text styles, adaptive overlay).
- `AppbarTemplate` upgraded to the reference's smart single-wrapper (`showAppBar`/`showBack`/
  `actions`/`bottom`/`body`|`children` scroll form, `PopScope`, `SafeArea(top: !showAppBar)`).
- `HomePage` now uses `ScaffoldApp` + `AppBarApp` (demonstrates centralized safe area + app bar).
- `DashboardPage` shell no longer double-wraps `SafeArea` (tab pages own it via `ScaffoldApp`).
