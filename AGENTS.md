# AGENTS.md — Flutter GetX Boilerplate

Review-oriented guidance for this repo (**Flutter** app; stack: **GetX** routing/DI/state
+ **Dio** network). Use it as a **PR-review checklist**: flag violations of the conventions
below — they are the things most often gotten wrong and the ones that quietly break the
architecture. `CLAUDE.md` is the full convention reference (where every folder lives and how
a request flows); `RULES.md` is the how-to-write-code rulebook; this file is the review subset.
When in doubt, prefer the existing pattern in the touched module over a new one.

## How to run the checks

- Analyze (must be clean): `flutter analyze` (lints from `analysis_options.yaml` / `flutter_lints`).
- Tests: `flutter test`.
- Format: `dart format lib/`.
- Run the app: `flutter run` (sample login `emilys` / `emilyspass` — see README).
- A PR that does not pass `flutter analyze` clean should not be approved.

## Highest-signal things to catch in review

### Layer flow (these silently rot the architecture)
The one-way path is **View → Controller → Repository → ApiClient → Dio**. Never skip or reverse it.
- **View** (`GetView<Controller>`): reject business logic, `Dio`, direct `repository`/`ApiClient`
  calls, or `setState` for business state. Reactive UI must be wrapped in `Obx` — and wrap the
  *smallest* reactive subtree, not the whole screen.
- **Controller** (`GetxController`): holds `.obs` state + logic, calls the repository, maps
  JSON → Model. Reject any `Dio` import, widget construction, or **hardcoded endpoint URL**.
- **Repository**: owns endpoint path strings, calls `apiClient.<verb>`, wraps failures as
  `ServerException`. Reject held state, model parsing, or touching `Dio` directly.
- **Model**: pure data, `fromJson`/`toJson` only. Reject state, network, or business logic.
- **ApiClient** (`services/api_client/`): the **only** place that imports/uses `Dio`. Reject
  endpoint path strings here and feature logic here.
- **Binding**: `Get.lazyPut` repo + controller only. Reject logic.

### Correctness gotchas (these cause silent bugs)
- **Loading flag must reset in `finally`.** `isLoading(true)` in `try`, reset in `finally` —
  never only on the success path (an early return/throw leaves the spinner stuck forever).
- **Reactive lists:** update with `.assignAll(...)`, never reassign the `RxList`. A plain
  reassignment drops the reactivity and the `Obx` stops rebuilding.
- **DI, not `new`:** dependencies come from `Get.find()` / bindings. Reject `AuthController(...)`
  or `AuthRepository(...)` constructed by hand inside a view/controller.
- **Dispose what you create:** `TextEditingController`s and animation controllers created in a
  controller must be disposed in `onClose()`.
- **No blocking work in `build()` or constructors** — no API calls, no heavy compute. Auto-fetch
  belongs in `onInit()`.
- **Session-kill is centralized:** 401/500 → `Helpers.clearToken()` is handled once in
  `ApiClient._handleResponse`. Reject duplicated logout logic inside controllers.

### Memory leaks & lifecycle (must-catch)
The most common silent bug class here. Reject a PR that:
- Creates a `TextEditingController`, `AnimationController`, `Timer`, `StreamSubscription`,
  `CancelToken`, `ScrollController`, or `FocusNode` **without disposing it** in `onClose()`
  (controllers) / `dispose()` (State). One undisposed ticker/listener = a permanent leak.
  Quick scan: `grep -rn "Controller(\|Timer(\|\.listen(\|CancelToken(\|FocusNode(" lib` — every hit
  needs a matching cancel/dispose.
- Marks a dep `permanent: true` or `fenix: true` **without cause** — it then never auto-disposes.
  Only app-lifetime services (`initServices()`) are `permanent`; only genuinely cross-route
  controllers are `fenix`. Everything else is plain `lazyPut` so GetX frees it on route pop.
- Registers a controller/service but never removes it when done (`Get.delete<T>()`), or holds a
  `Get.find` reference past the owning route.
- Grows an `.obs` list unbounded (streaming `.add` with no cap/clear) or keeps full-resolution images
  in memory (missing `cacheWidth`).
- Starts a `Connectivity`/stream/animation listener in `onInit` but doesn't cancel it in `onClose`.
- Runs an animation/timer while off-screen, or animates by calling `update()`/`setState` every frame.

### Performance & adaptive (must-catch)
- Non-`const` widget that could be `const`; a whole-screen `Obx` where a tight one would do; a mapped
  `Column` of unbounded data instead of `ListView.builder`; API/heavy work in `build()`.
- Raw layout pixels instead of Sizer (`.w/.h/.sp/.r`); hand-styled widget instead of the theme.
- Layout that assumes phone width (overflow / stretched on tablet/desktop) — should branch via
  `context.responsive`/`isTablet` and cap `contentMaxWidth` (ADAPTIVE.md).

### API & data-flow conventions
- All network goes through `apiClient.get/post/put/delete` — never a raw `Dio()` in a feature.
- Controllers check `res?.statusCode == 200` before parsing; non-200 surfaces via `AppSnackBar`.
- Errors are never swallowed silently — either snackbar the user or `Log.info(...)`. Reject a bare
  `catch (_) {}`.
- New base URL / endpoint host → `shared/constants.dart` (`BASE_URL`, `NEWS_URL`). Reject a
  literal `https://...` inside a feature/controller.
- Persistence: SharedPreferences access **only** through `Prefs` (`helpers/utils/prefs_utils.dart`);
  token/user **only** through `AuthPrefs` (`helpers/app_key.dart`, saved as `"Bearer <jwt>"`).
  Reject reading `token_key` raw anywhere else.

### UI conventions (enforced — see DESIGN.md)
- **One screen foundation:** every screen is an `AppbarTemplate` (status bar + SafeArea + app bar).
  Reject a raw `Scaffold`/`AppBar` in a screen (only a tab shell is a plain `Scaffold`). Modes:
  `showBack: false` (root/tab), `showAppBar: false` (custom header), `children:` (padded scroll form).
- **Text/inputs/buttons come from the global theme, not wrappers:** raw `Text('x', style: kTitle)`
  (bare `Text` → `appTextTheme`), raw `TextFormField` (`inputDecorationTheme`), raw `ElevatedButton`
  (`elevatedButtonTheme`). There are no `TextApp`/`TextFieldApp` (deleted) — reject reintroducing them.
- **Safe area is owned by `AppbarTemplate`.** Reject a second `SafeArea` inside a screen, or a shell
  `SafeArea` wrapping tab pages that are each an `AppbarTemplate` (double inset).
- **App bar changes go into `AppbarTemplate`**, not per-screen, so title style/height/colors stay identical.
- **Sizing via Sizer:** design px (`16.w`, `18.sp`, `12.r`) or percentage (`.wp`/`.hp`). Reject
  hardcoded pixel layout dimensions (borders/radius are fine).
- **Type scale (DESIGN.md):** `fontSize` on the allowed scale; body/paragraph ≥ 16sp; labels/
  metadata ≥ 14sp; no 9/10 sizes.
- **Colors from theme:** use `k*Color` tokens (`shared/theme.dart`) or `appTheme`. Reject a
  hardcoded `Color(0x..)`/hex inside a widget.
- **`const` constructors wherever possible**; no business logic in `build()`.

### Routing
- A new screen is wired in this exact order: (1) `routes/routes.dart` route const, (2)
  `routes/app_bindings.dart` `<Feature>Binding` (`lazyPut` repo + controller), (3)
  `routes/app_pages.dart` `GetPage(name, page, bindings)`. Reject a screen missing any of the three.
- Navigate with `Get.toNamed` / `Get.offAllNamed` using `Routes.*` consts — reject raw path strings.

### Folder placement (see CLAUDE.md §3)
- New code lands in the right folder. Reject a new top-level `lib/` folder introduced without a
  matching CLAUDE.md update. Feature-local widget → `modules/<feature>/components/`; app-wide
  widget → `shared/widgets/components/`; system addon (dialog/snackbar/sheet) → `helpers/system/`.

## Naming (reject deviations)

| Thing | Rule | Example |
|-------|------|---------|
| Custom Flutter-widget wrapper (behavioural) | suffix `App` | `LoadingApp` |
| System addon (static methods) | prefix `App` | `AppSnackBar.error(...)` |
| Repository | `<Domain>Repository` | `AuthRepository` |
| Controller | `<Feature>Controller` | `HomeController` |
| Model | `<Name>Model` | `NewsModel` |
| Binding | `<Feature>Binding` | `AuthBinding` |
| Template | suffix `Template` | `WebViewTemplate` |
| Route const | `SCREAMING_SNAKE` in `Routes` | `Routes.DASHBOARD` |
| File | `snake_case.dart` | `auth_controller.dart` |

## Review scope & style
- Focus on the diff and its blast radius; do not rewrite untouched code.
- Prefer concrete, actionable findings tied to `file:line` and the specific rule above.
- Distinguish **must-fix** (layer violation, silent error swallow, stuck loading flag, session
  logic duplicated, raw endpoint/color/Scaffold) from **nits** (naming, `const`, style) and label them.
- Verify the add-a-feature checklist (CLAUDE.md §10 / RULES.md §11) was followed for new screens.
