# DESIGN.md — Flutter GetX Boilerplate

Visual rules for this app. `CLAUDE.md` says *where* code goes, `RULES.md` says *how* to write
it, this file says *how it should look*. Sizes are **design px** fed to Sizer (`.sp` for text,
`.w`/`.h` for layout, `.r` for radius) off a 375×812 baseline — write the number you'd draw in
Figma, Sizer scales it per device.

---

## 1. Use the wrappers, not raw Flutter

Screens are built from the app's own widgets so styling stays uniform. Reach for these first:

| Instead of | Use | Why |
|------------|-----|-----|
| any screen (Scaffold + AppBar) | `AppbarTemplate` | THE foundation: status bar + SafeArea + app bar + optional scroll form |
| `Text` | `Text('x', style: kBody/kTitle…)` | global text styles from `theme.dart` (bare `Text` inherits `appTextTheme`) |
| `TextFormField` | raw `TextFormField` | styled globally via `appTheme.inputDecorationTheme` |
| primary button | raw `ElevatedButton` | styled globally via `appTheme.elevatedButtonTheme` |
| loading spinner | `LoadingApp` / `CircleLoading` | one overlay everywhere |

There are **no** `*App` text/scaffold wrappers — styling lives in the global theme. A raw `Scaffold`
or `AppBar` in a screen is a review flag: use `AppbarTemplate`.

**One foundation, three modes:** titled screen → `AppbarTemplate(title: 'X', body: ...)`;
root/tab screen → add `showBack: false`; custom-header screen (login/splash) → `showAppBar: false`.
Pass `children:` instead of `body:` for a padded scroll form. Tab shell is the only plain `Scaffold`
(it holds `AppbarTemplate` tab pages).

---

## 2. Safe area & the app bar (consistency)

- **Safe area is handled once** — by `AppbarTemplate`. Do not add a second `SafeArea` inside a
  screen. In a tab shell (e.g. `DashboardPage`), the shell is a plain `Scaffold` and each tab page
  (an `AppbarTemplate`) owns its safe area — never both.
- **Bottom safe area too:** `AppbarTemplate` insets the bottom by default (`bottomSafe: true`) so
  content clears the iOS home-indicator and Android nav bar. Works on both platforms, top and bottom.
- **Status bar is consistent AND fully customisable:**
  - Overlay is adaptive by default (`appOverlayStyle(brightness)` — dark icons in light mode, light
    in dark). Override per screen with `AppbarTemplate(systemOverlayStyle: ...)`.
  - App-bar **title font is one size app-wide** (`kAppBarTitle` = 20sp bold). Override for a single
    screen with `titleStyle:`, or replace the title entirely with `titleWidget:` (logo / search field).
  - Custom leading/back via `leading:` / `showBack:` / `onBack:`; custom bar colors via `appBarColor:`.
- **Every top bar is `AppbarTemplate`'s app bar.** Root/tab screens pass `showBack: false`; pushed
  screens use the default back button. App-wide bar changes go into `AppbarTemplate`, not per-screen.
- Full-screen reusable layouts (webview, pdf, preview) use the `*Template` widgets in
  `shared/widgets/templates/`.

---

## 3. Typography scale — strict

Allowed `fontSize` (design px, before Sizer): **12 / 14 / 16 / 18 / 20 / 24 / 28 / 32 / 40 / 48 / 56 / 64**

Rules:
- **No odd numbers**, no `9`/`10`/`11`/`13`/`15`/`17`px, no off-scale evens (`22`→24, `26`→24,
  `30`→32, `36`→32/40, `44`→48).
- **Body / paragraph / list / card text → 16px minimum.**
- **Captions / form labels / metadata → 14px minimum.** Default to 16 when unsure.
- **12px only** for short uppercase eyebrows/tags/badges (≤ ~30 chars) or compact form-control
  value text — never body copy.
- Feed size through Sizer as `.sp`: `Text('News', style: kTitle.copyWith(fontSize: 18.sp))`.

Font weights come from `theme.dart` tokens (`regular`, `medium`, `semiBold`, `bold`, …) — not raw
`FontWeight.w600`.

**Prebuilt text styles** in `theme.dart` (already `.sp`-scaled): `kH1`, `kH2`, `kTitle`, `kBody`,
`kBodySm`, `kCaption`, `kButton`. Use with raw `Text(x, style: kBody)`, or `kBody.copyWith(...)` for
a one-off override; they're wired into `appTheme.textTheme`, so a bare `Text` inherits sensible
defaults. This is the whole point — text styling is global, no per-widget font.

---

## 4. Color

- **Only** theme tokens from `shared/theme.dart`: `kBlueColor`, `kDarkBlueColor`, `kRedColor`,
  `kGreyColor`, `kDarkGreyColor`, … Never a hardcoded `Color(0x..)`/hex inside a widget.
- App-wide surfaces/appbar/seed come from `appTheme` (wired into `GetMaterialApp` in `main.dart`).
- Roles: `kBlueColor` primary/action, `kDarkBlueColor` app bar / headers, `kRedColor` errors/
  destructive, greys for surfaces/dividers/secondary text.

---

## 5. Spacing, whitespace, radius, sizing

- **Every size goes through Sizer** — design px `.w` / `.h` (layout), `.sp` (font), `.r` (radius);
  proportional `.wp` / `.hp`. No hardcoded pixel literals for layout (a fixed hairline border is the
  only exception).
- **Whitespace scale** (design px, use consistently): `4 / 8 / 12 / 16 / 24 / 32`. Section gaps ≥ 16,
  card inner padding 12–16, screen horizontal padding = `defaultMargin` (`.wp`). Don't crowd — generous
  whitespace reads premium; inconsistent gaps read cheap.
- Space between stacked elements with `SizedBox(height: 12.h)` or `Padding`, not `\n` newlines or empty
  containers.
- Radius: `.r` (`BorderRadius.circular(12.r)`) or tokens `rSm` / `rMd` / `rLg`. Keep one radius family
  per surface type (cards, buttons, sheets).
- `const` constructors wherever possible.

---

## 6. No overflow — ever

A yellow-black overflow stripe is a bug. Prevent it structurally:
- Text that can be long → `maxLines` + `overflow: TextOverflow.ellipsis`, and `Expanded`/`Flexible`
  when it sits in a `Row`.
- `Row`/`Column` children that can exceed the axis → `Expanded` / `Flexible` (share space) or `Wrap`
  (reflow chips/tags) or a scroll view (`ListView` / `SingleChildScrollView`).
- Images/boxes → constrain with `AspectRatio` / `SizedBox` / `ConstrainedBox`; never an unbounded child
  in an unbounded parent.
- Must-fit content → `FittedBox`; space-dependent layout → `LayoutBuilder` / `MediaQuery`.
- Keyboard: forms use `AppbarTemplate(children: [...])` (scrolls fields clear); set
  `resizeToAvoidBottomInset` when a pinned footer must ride above the keyboard.

---

## 7. UI/UX state defaults

Every data surface handles four states — never a blank or a raw spinner-forever:
- **Loading:** `CircularProgressIndicator` / `CircleLoading` (or a `BoxSkeleton` shimmer for lists).
- **Empty:** a centered message ("No news yet"), muted color (`kDarkGreyColor`), not a blank screen.
- **Error:** a message + a retry affordance (retry the same controller method).
- **Content:** `ListView.builder`/`.separated`, newest-first where relevant, pull-to-refresh via
  `RefreshIndicator` calling the controller's refresh method.
- Tap targets ≥ 44×44. Give buttons/rows visible pressed feedback (`InkWell`/`ElevatedButton`).
- Show one spinner at a time — e.g. pull-to-refresh passes `spinner: false` so only the
  `RefreshIndicator` shows.

---

## 8. Performance is a design constraint

- Prefer `const` widgets and tight `Obx` scope so rebuilds are cheap (RULES.md §3, §6).
- Long/unbounded lists → `ListView.builder`, never a mapped `Column`.
- Network images through `ImgNetwork` / `cached_network_image` with `cacheWidth` + placeholder + error.
- Wrap independently-repainting subtrees in `RepaintBoundary`. No API calls or heavy work in `build()`.

---

## 9. Font family

`lato` (registered in `pubspec.yaml`, exposed as `defaultFont`). Set globally via `appTheme` and the
`k*` text styles — do not pass `fontFamily:` per widget.
