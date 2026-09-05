# RULES.md — Flutter GetX Boilerplate

Hard rules for writing code in this repo. `CLAUDE.md` = *where* code goes, `DESIGN.md` = *how it
looks*, this file = *how to write it*, `GETX_CHEATSHEET.md` = copy-paste GetX snippets. Break a rule
only with a comment saying why.

---

## 0. Prime directives

1. **Respect the layer flow.** View → Controller → Repository → ApiClient → Dio. Never skip or reverse. (CLAUDE.md §1.)
2. **New code lands in the right folder** (see §1 below). Don't invent top-level folders without updating CLAUDE.md.
3. **Reuse before you build.** Search `shared/`, `helpers/`, the theme, and `AppbarTemplate` before writing anything new. Duplicate = tech debt.
4. **Performance & memory first.** Lazy deps, `const`, builders, dispose, smallest rebuild. (§6.)
5. **Nothing overflows, everything is safe-area correct, every size goes through Sizer.** (§7, §8.)

---

## 1. Folder structure (memorise this)

```
lib/
  main.dart                     initServices() → runApp(GetMaterialApp: routes + appTheme + Sizer)
  routes/    routes.dart        route consts (SCREAMING_SNAKE)
             app_pages.dart     GetPage: route → page + bindings
             app_bindings.dart  <Feature>Binding: lazyPut repo + controller
  modules/<feature>/
             controllers/       GetxController — .obs state + logic
             models/            data classes — fromJson/toJson only
             views/             screens (GetView<Controller>)
             components/        (optional) widgets used ONLY in this feature
             datas/             (optional) hardcoded/mock slice data while building UI
  repository/                   endpoint paths + ApiClient calls → ServerException
  services/                     app-wide singletons (initServices / Get.put permanent)
  shared/    theme.dart         GLOBAL design system (colors, text styles, appTheme)
             constants.dart     APP_NAME, base URLs, asset paths
             widgets/           loading_app + components/ + templates/ (AppbarTemplate)
  helpers/   system/            AppDialog / AppSnackBar / AppBottomSheet
             utils/             Prefs, Log, FormatNumber, Utils
             third_party/       vendored libs (sizer, shimmer, check_auth, ...)
```

Decision table (full version in CLAUDE.md §3):

| Adding | Goes in |
|--------|---------|
| Screen / feature | `modules/<feature>/` (+ route + binding) |
| Widget used across whole app | `shared/widgets/components/` |
| Widget used in one feature only | `modules/<feature>/components/` |
| Mock/hardcoded data for one feature | `modules/<feature>/datas/` |
| Text/input/button styling | the theme — raw `Text(style: kBody)` / `TextFormField` / `ElevatedButton` |
| Full-screen scaffold | `AppbarTemplate` (never a raw `Scaffold`) |
| Endpoint path | `repository/<domain>_repository.dart` |
| Color / font / size token | `shared/theme.dart` |
| Global constant / URL | `shared/constants.dart` |

---

## 2. Layer boundaries (enforced)

| Layer | MUST | MUST NOT |
|-------|------|----------|
| View | `GetView<Controller>`, `Obx` for reactive UI | logic, Dio, repository calls, `setState` for business state |
| Controller | `.obs` state, call repository, map JSON→Model | touch Dio, build widgets, hardcode endpoint URLs |
| Repository | own endpoint path, call `ApiClient`, wrap `ServerException` | hold state, parse into models, touch Dio directly |
| Model | `fromJson`/`toJson`, pure data | state, network, business logic |
| ApiClient | only place touching Dio | hold endpoint paths, feature logic |
| Binding | `lazyPut` repo + controller (may seed args, e.g. `openRecord`) | UI, heavy logic |

- Endpoint strings live **only** in repositories. Dio lives **only** in `services/api_client/`.
- `Get.find()` a dependency — never `new` a repository/controller in a view.

---

## 3. State — know when to use what

### `.obs` + `Obx` (reactive)
Use for values the UI must track live (lists, loading flags, toggles, current tab).
- Declare: `final news = <NewsModel>[].obs;` `final isLoading = false.obs;`
- Read/write value types via `.value` (`isLoading.value = true`, or shorthand `isLoading(true)`).
- **Lists/maps: mutate with `.assignAll(...)` / `.add(...)`** — never reassign the Rx (kills reactivity).
- Wrap the **smallest** subtree in `Obx`, not the whole screen. Each `Obx` must read an `.obs` inside it.
- Model objects: `final _record = Model().obs; Model get record => _record.value;`

### `GetBuilder` + `update()` (manual, lighter)
Use when you don't need per-value reactivity and want the cheapest rebuild — e.g. a tab index, a
form step, anything you update in discrete batches.
- `int tab = 0; void setTab(int i){ tab = i; update(); }`
- `GetBuilder<C>(builder: (c) => ...)`. Scope with `update(['id'])` + `GetBuilder(id: 'id')`.

**Rule of thumb:** live/streaming value or list → `Obx`. Coarse "redraw this section now" → `GetBuilder`.
Don't mix both for the *same* piece of state.

### Loading + async discipline (from the mature app)
- `isLoading(true)` in `try`, reset in **`finally`** — always, even on early return/throw.
- **Stale-response guard:** after `await`, verify you're still on the same target before assigning
  (`if (record.id == id) list.assignAll(res);`). Prevents a slow response overwriting fresh state.
- **Cancel in-flight work:** debounce rapid input with a `Timer`; cancel the previous Dio call with a
  `CancelToken` so a stale response can't land. Cancel both in `onClose()`.
- **Parallelise independent calls** with `Future.wait([...])` instead of awaiting in series.

---

## 4. Dependency injection (call / delete / reset / reload)

Register in **Bindings**; retrieve with `Get.find()`. Never `new`.

| Need | API |
|------|-----|
| Build on first use (per route) | `Get.lazyPut(() => C())` |
| Keep alive after route closes (reuse across screens) | `Get.lazyPut(() => C(), fenix: true)` |
| Eager singleton for app lifetime | `Get.put(Service(), permanent: true)` (in `initServices()`) |
| Async init before UI | `await Get.putAsync(() => Service().init())` |
| Retrieve anywhere | `Get.find<C>()` |
| Seed args into an existing controller | binding calls `Get.find<C>().openX(Get.arguments)` |
| Remove one dep | `Get.delete<C>()` (respects `fenix`; force with `Get.delete<C>(force: true)`) |
| Check registered | `Get.isRegistered<C>()` / `Get.isPrepared<C>()` |
| Replace an instance | `Get.replace<C>(newC)` / `Get.lazyReplace(() => newC())` |
| Reload one / all | `Get.reload<C>()` / `Get.reset()` (wipes DI — tests / full logout) |

- `GetView<C>` auto-`find`s its controller. Bindings on the `GetPage` create the deps when the route opens
  and GetX auto-disposes non-`permanent`, non-`fenix` deps when the route pops (that's the memory win).
- Use `fenix: true` only when a controller is genuinely shared across a navigation (e.g. list → detail).
- App-wide services (DB, storage, analytics) → create in `services/`, register in `initServices()`, as
  `GetxService` (never auto-disposed) when they must live forever.

---

## 5. Network & errors

- Call through `apiClient.get/post/put/delete` only. Endpoint host → `shared/constants.dart`.
- Repository wraps failures: `throw ServerException(error.toString(), stacktrace)`.
- Controller checks `res?.statusCode == 200/201` before parsing; surface non-2xx via `AppSnackBar`.
- Never swallow silently — snackbar the user or `Log.info`. 401/500 session-kill is centralised in
  `ApiClient`; don't duplicate logout in controllers.
- Persistence: SharedPreferences only through `Prefs`; token/user only through `AuthPrefs` (`"Bearer <jwt>"`).

---

## 6. Performance & memory

- **Lazy + auto-dispose DI** (§4) is the primary memory tool — don't hold controllers you don't need.
- `const` constructors everywhere possible — `const` widgets are skipped on rebuild.
- **Lists:** `ListView.builder` / `.separated` (lazy), never a mapped `Column` in a `SingleChildScrollView`
  for long/unbounded data. Add `itemExtent`/`prototypeItem` when rows are uniform.
- **Images:** network images through `ImgNetwork` / `cached_network_image`; pass `cacheWidth` to decode
  downscaled; always give `errorBuilder` + a placeholder.
- **Smallest rebuild:** tight `Obx` scope; extract expensive static subtrees into `const` widgets; wrap
  independently-animating subtrees in `RepaintBoundary`.
- **Never** do API calls / heavy compute / allocations in `build()` or constructors — auto-fetch in `onInit()`.
- Parallelise with `Future.wait`; debounce input; cancel stale requests (`CancelToken`).
- **Dispose** every `TextEditingController`, `Timer`, `StreamSubscription`, `CancelToken`, animation
  controller you create, in `onClose()`.

---

## 6A. Animation (playbook)

Animate to communicate (state change, spatial continuity), never as decoration. Keep it cheap.

- **Durations:** 150–300ms for UI feedback, ≤ 500ms for larger transitions. Use `Curves.easeInOut` /
  `easeOutCubic` — no linear for UI. Keep durations consistent (reuse one const).
- **Implicit first:** prefer `AnimatedContainer` / `AnimatedOpacity` / `AnimatedSwitcher` /
  `AnimatedAlign` / `TweenAnimationBuilder` — no controller to leak, minimal code. Reach for explicit
  `AnimationController` only for looping, gesture-driven, or multi-stage sequences.
- **Explicit controllers:** create with `vsync: this` (`SingleTickerProviderStateMixin` on the State,
  or GetX `GetSingleTickerProviderStateMixin` on the controller). **Always `dispose()` in `onClose()`
  / `dispose()`** — an undisposed controller ticks forever = leak + jank (AGENTS.md).
- **Route transitions:** set via GetX (`Get.toNamed(..., transition: Transition.rightToLeft)`) or the
  app default in `GetMaterialApp` — don't hand-roll per screen.
- **Rebuild scope:** wrap only the animated subtree in the builder; wrap independently-repainting
  animations in `RepaintBoundary` so they don't repaint siblings.
- **Never** animate in `build()` by mutating state each frame; never run animations off-screen; stop/
  reset controllers when not visible. Respect reduced-motion (`MediaQuery.disableAnimationsOf(context)`).
- **Lists:** stagger with `flutter_staggered_animations`-style index delays sparingly; keep list item
  builders `const` where possible so scrolling stays smooth.

---

## 7. Layout & overflow (zero overflow errors)

- A `Row`/`Column` child that can exceed its axis must be wrapped: `Expanded` / `Flexible` for share-of-space,
  `Wrap` for chips/tags that should reflow, `SingleChildScrollView` / `ListView` for scrollable content.
- **Text:** always give a `maxLines` + `overflow: TextOverflow.ellipsis` for anything that can be long
  (titles, names, list rows). Use `Flexible`/`Expanded` around text inside a `Row`.
- Constrain images/boxes with `AspectRatio`, `SizedBox`, or `ConstrainedBox` — never an unbounded child
  in an unbounded parent.
- Use `FittedBox` for must-fit content; `LayoutBuilder` / `MediaQuery` when layout depends on space.
- Forms: `AppbarTemplate(children: [...])` gives a scroll view so fields clear the keyboard; set
  `resizeToAvoidBottomInset` when a fixed footer must stay above the keyboard.

---

## 8. Sizing, safe area, status bar

### 8.1 Same proportional look on every device (the core rule)
The app must look **identical in proportion** on a small phone, a big phone, and a tablet — same
relative font size, same relative widget size, same spacing ratio — only the absolute pixels differ.

- **Every size goes through Sizer, always.** Design px: `.w` `.h` (width/height), `.sp` (font),
  `.r` (radius); proportional: `.wp` `.hp`. Author every number against the 375×812 baseline; Sizer
  scales it to the real device so the element-to-screen ratio stays constant everywhere.
- **No raw pixel literals** for layout/font/radius, and **no raw `MediaQuery.size` math** for sizing —
  that breaks the proportion. Fixed hairline borders (0.5–1px) are the only exception.
- **Fonts scale too** — use `k*` styles (`.sp`-based) or `.sp`; never a bare `fontSize: 16`. Text keeps
  the same visual weight relative to the screen on phone and tablet alike.
- **Proportional gaps** — `SizedBox(height: 12.h)`, padding in `.w`/`.wp`; never a fixed `SizedBox(20)`.
- `.sp`/`.r` use the **min** width/height ratio, so nothing distorts or overflows on tall-narrow or
  short-wide screens — proportions hold in both orientations.
- **This is the default and it is enough for ~90% of screens.** Do NOT hand-tune sizes per device.
  Restructuring layout (1→2→3 columns, master-detail) is a *separate, opt-in* decision at real
  breakpoints — see `ADAPTIVE.md`; until you deliberately branch, every screen is one proportional layout.
- Verify: the same screen at phone and tablet widths should look like the same design zoomed, not
  re-laid-out or stretched. If a widget looks too big/small on tablet, the fix is correct Sizer units,
  not a magic per-device number.
### 8.2 Safe area & status bar
- **Safe area is owned once by `AppbarTemplate`** — top handled by the app bar (or `SafeArea top` when
  `showAppBar: false`), bottom by `bottomSafe` (default on) for the iOS home-indicator / Android nav bar.
  Never add a second `SafeArea` inside a screen.
- **Status bar / app-bar title is consistent by default and fully customisable:**
  - Title style = `kAppBarTitle` (one size/weight app-wide). Override per screen with
    `AppbarTemplate(titleStyle: ...)` or a full `titleWidget:` (logo, search field).
  - Status-bar overlay = adaptive `appOverlayStyle(brightness)`; override with `systemOverlayStyle:`.
  - Custom leading/back via `leading:` / `showBack:` / `onBack:`.

---

## 9. Screen construction

- Every screen is an `AppbarTemplate` (§8 / DESIGN.md). No raw `Scaffold`/`AppBar` (only the tab shell is a
  plain `Scaffold` holding `AppbarTemplate` pages).
- Text/inputs/buttons come from the theme: `Text('x', style: kTitle)` (bare `Text` → `appTextTheme`),
  raw `TextFormField` (`inputDecorationTheme`), raw `ElevatedButton` (`elevatedButtonTheme`).
- No hardcoded colors/fonts — use `k*Color` / `k*` text styles from `theme.dart`.
- Global small widgets → `shared/widgets/components/`; feature-only → `modules/<feature>/components/`.

---

## 10. Naming

| Thing | Rule | Example |
|-------|------|---------|
| Custom Flutter-widget wrapper (behavioural) | suffix `App` | `LoadingApp` |
| System addon (static methods) | prefix `App` | `AppSnackBar.error(...)` |
| Repository / Controller / Model / Binding | `<X>Repository/Controller/Model/Binding` | `AuthController` |
| Template | suffix `Template` | `AppbarTemplate` |
| Route const | `SCREAMING_SNAKE` in `Routes` | `Routes.DASHBOARD` |
| File | `snake_case.dart` | `auth_controller.dart` |

---

## 11. Routing

1. `routes/routes.dart` — route const. 2. `routes/app_bindings.dart` — `<Feature>Binding`.
3. `routes/app_pages.dart` — `GetPage(name, page, bindings)`.
Navigate with `Get.toNamed` / `Get.offAllNamed` using `Routes.*` — no raw path strings. Pass data with
`arguments:` and read via `Get.arguments` (a binding may seed it into the controller).

---

## 12. Hygiene

- `flutter analyze` clean before done. No `print` (use `Log.info` / `debugPrint`). No dead/commented code.
- Comments explain **why**, not what; match existing density. One responsibility per file.

---

## 13. Before you finish

- [ ] Code in correct layer + folder (§1, §2).
- [ ] Reused theme / `AppbarTemplate` / existing widget instead of rebuilding.
- [ ] Right state tool (`Obx` vs `GetBuilder`); smallest rebuild scope.
- [ ] Loading flag reset in `finally`; stale-response guarded; requests cancelled/debounced where relevant.
- [ ] Everything you created is disposed in `onClose()`.
- [ ] No overflow (Expanded/Flexible/Wrap/ellipsis); all sizes via Sizer.
- [ ] Same proportional look on phone + tablet (all font/widget/spacing via Sizer, no raw px / MediaQuery math).
- [ ] Safe area correct top+bottom (iOS + Android); status bar consistent.
- [ ] Endpoint only in repository, Dio only in ApiClient; errors surfaced not swallowed.
- [ ] Route wired: const → binding → GetPage. `flutter analyze` clean.
