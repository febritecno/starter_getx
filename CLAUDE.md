# CLAUDE.md — Flutter GetX Boilerplate

Flutter app. Stack: **GetX** (routing + DI + state) + **Dio** (network). This file is the information architecture: where every folder lives, what each does, and how a request flows end to end. Read this before adding a feature so new code lands in the right layer.

**Companion docs:** `RULES.md` (how to write code), `DESIGN.md` (how it should look), `ADAPTIVE.md` (multiplatform adaptive UI), `AGENTS.md` (PR-review checklist), `GETX_CHEATSHEET.md` (copy-paste GetX patterns), `tool/PERFORMANCE.md` (perf/size/memory audit playbook + `tool/audit.sh`), `tool/SECURITY.md` (security audit playbook + `tool/security_audit.sh`). Read this file first for *where*, then those for *how*.

---

## 1. Data flow (the golden path)

A feature request travels one direction. Never skip a layer, never reverse it.

```
View (GetView)                UI. Reads controller.obs, calls controller methods.
  └─ Controller (GetxController)   State (.obs) + logic. Calls repository. Maps JSON → Model.
       └─ Repository               Owns endpoint paths. Calls ApiClient. Wraps errors → ServerException.
            └─ ApiClient (service) Single network owner. Auth header, timeouts, error mapping, session kill.
                 └─ Dio            Raw HTTP.
Model                             Plain data class. fromJson / toJson only. No logic, no state.
Binding (routes/)                 Wires Repository + Controller into GetX DI for a route.
```

### Concrete example — login

1. `modules/auth/views/login_page.dart` — `LoginPage extends GetView<AuthController>`. Button calls `controller.onLogin()`.
2. `modules/auth/controllers/auth_controller.dart` — `onLogin()` sets `isLoading(true)`, calls `repository.postLogin({...})`, on 200 parses `AuthModel.fromJson`, saves token via `AuthPrefs`, `Get.offAllNamed(Routes.DASHBOARD)`.
3. `repository/auth_repository.dart` — `postLogin(body)` → `apiClient.post("$BASE_URL/auth/login", body)`. Wraps throw → `ServerException`.
4. `services/api_client/api_client.dart` — injects `Authorization` header, sends via Dio, maps `DioException` → typed exceptions / snackbars, kills session on 401/500.
5. `modules/auth/models/auth_model.dart` — `AuthModel` + `UserModel`, `fromJson`/`toJson`.
6. Wired by `AuthBinding` in `routes/app_bindings.dart`, registered as a route in `routes/app_pages.dart`.

### Concrete example — news feed (read)

`home_page.dart` (Obx on `controller.news`) → `HomeController.fetchNews()` (onInit auto-fetch) → `DashboardRepository.getNews()` → `ApiClient.get("$NEWS_URL/articles/?limit=20")` → `NewsModel.fromJson`. Wired by `HomeBinding`.

---

## 2. Folder map — what goes where

```
lib/
├── main.dart                 App entry. await initServices() → runApp. GetMaterialApp (routes, theme, Sizer).
│
├── routes/                   Navigation + DI wiring. THE hub of the app.
│   ├── routes.dart           Route name constants (abstract class Routes). Add path consts here first.
│   ├── app_pages.dart        GetPage list: route name → page + bindings. Register every screen here.
│   └── app_bindings.dart     Bindings classes: lazyPut Repository + Controller per route/feature.
│
├── modules/                  FEATURE code. One folder per feature. Self-contained.
│   └── <feature>/
│       ├── controllers/      GetxController: .obs state + logic. Calls repository.
│       ├── models/           Data classes for THIS feature. fromJson/toJson only.
│       ├── views/            Screens (GetView<Controller>).
│       ├── components/       (optional) Widgets reused only inside this feature. Create when needed.
│       └── datas/            (optional) Hardcoded / mock slice data for THIS feature (static lists,
│                             dummy fixtures while slicing UI before the API is ready). Not for real
│                             network data — that comes through repository → model.
│
├── repository/               Data sources. Endpoint paths live here. One file per domain.
│                             Thin: call ApiClient, rethrow as ServerException. No Dio logic.
│
├── services/                 App-wide services registered into GetX DI (via initServices / Get.put).
│   ├── app_services.dart     initServices(): PrefsService (async) + ApiClient (permanent). GetxService lives here.
│   ├── api_client/
│   │   ├── api_client.dart    Network owner: interceptors, timeouts, verb methods, error→snackbar mapping.
│   │   └── exceptions/exceptions.dart  Network exception types (BadNetworkException, ApiException, ...).
│   └── exceptions/server_exception.dart  Repository-level ServerException (error + stacktrace).
│
├── shared/                   GLOBAL reusable UI + app-wide constants/theme. Not feature-specific.
│   ├── constants.dart        APP_NAME, BASE_URL, NEWS_URL, asset paths, global consts.
│   ├── theme.dart            The GLOBAL design system: colors (kBlueColor…), font, text styles
│   │                         (kH1/kTitle/kBody…), radii, appOverlayStyle, appTextTheme, appTheme
│   │                         (ThemeData: text/input/button themes wired into GetMaterialApp).
│   └── widgets/
│       ├── loading_app.dart    LoadingApp overlay + CircleLoading.
│       ├── components/         Small GLOBAL reusable widgets (buttons, skeleton, img, tabs).
│       │                       rounded_button, submit_button, switch_tab, img_network,
│       │                       box_skeleton, circle_loading.
│       └── templates/          Reusable TEMPLATES. appbar_template = AppbarTemplate, THE single
│                               screen foundation (status bar + SafeArea + app bar). Also
│                               webview_template, pdfview_template, preview_template.
│
└── helpers/                  Non-UI support code.
    ├── helpers.dart          Helpers: MediaQuery size math, clearToken, back().
    ├── app_key.dart          AuthPrefs: token_key / user_key get/set/clear over Prefs.
    ├── system/               App system add-ons (overlays on top of Flutter): dialog, snackbar, bottomsheet.
    │                         AppDialog, AppSnackBar, AppBottomSheet. Register new system addons here.
    ├── utils/                Specific utility helpers:
    │                         prefs_utils (Prefs = SharedPreferences wrapper), logger_utils (Log),
    │                         number_format (FormatNumber), common_utils (Utils, catch-all).
    └── third_party/          Vendored pub.dev libs we downloaded + customize ourselves:
                              sizer/ (responsive .wp/.hp/.spp extensions), shimmer, animation_indexed,
                              check_auth (CheckAuthScreen splash → route by token).
```

---

## 3. Where do I put a new ___ ?

| Adding | Put it in |
|--------|-----------|
| New screen / feature | `modules/<feature>/` with `controllers/ models/ views/`. Register route + binding. |
| Widget reused across ALL app (button, input) | `shared/widgets/components/` (small) or `shared/widgets/` (core: text/field/scaffold). |
| Widget reused only inside one feature | `modules/<feature>/components/` (create folder). |
| Hardcoded / mock slice data for one feature | `modules/<feature>/datas/` (optional; dummy fixtures while slicing UI). |
| Uniform full-screen/section layout reused | `shared/widgets/templates/`. |
| Text / input / button styling | Use the GLOBAL theme — raw `Text('x', style: kTitle)`, raw `TextFormField` / `ElevatedButton` (both styled via `appTheme`). Don't wrap Flutter widgets per-screen. A genuinely new reusable widget (with real behaviour, not just styling) goes in `shared/widgets/components/`. |
| System addon (dialog, snackbar, sheet, toast) | `helpers/system/`. Static-method class (`AppXxx`). |
| Vendored pub.dev lib we customize | `helpers/third_party/<lib>/`. |
| Specific utility/helper | `helpers/utils/`. |
| App-wide service (DB, AWS, storage...) | `services/`, then register in `services/app_services.dart → initServices()`. |
| API endpoint | `repository/<domain>_repository.dart` (path lives here, uses ApiClient). |
| Global constant / URL | `shared/constants.dart`. |
| Color / font / size | `shared/theme.dart`. |
| Route name | `routes/routes.dart` → then `app_pages.dart` + `app_bindings.dart`. |

---

## 4. Layer rules (do / don't)

- **View**: `GetView<Controller>`, no logic. Wrap reactive UI in `Obx`. No direct repository/ApiClient calls.
- **Controller**: holds `.obs` state, does logic, calls repository, maps JSON → Model. No Dio, no widgets.
- **Repository**: owns endpoint strings, calls `apiClient.<verb>`, wraps errors → `ServerException`. No state, no UI. New endpoints go here.
- **Model**: pure data, `fromJson`/`toJson`. No state, no network.
- **ApiClient**: the ONLY place that touches Dio. Auth header, timeouts, error→snackbar, session invalidation. Don't put endpoint paths here.
- **Binding**: `Get.lazyPut(() => Repo(apiClient: Get.find()))` then controller. Register in `app_pages.dart` GetPage.

---

## 5. Services & DI (GetX)

`main.dart` → `await initServices()` (in `services/app_services.dart`) before `runApp`:
- `Get.putAsync(() => PrefsService().init())` — SharedPreferences ready before first request (token depends on it).
- `Get.put(ApiClient(Dio()), permanent: true)` — global singleton, injected into every repository.

Per-route deps come from **Bindings** (`app_bindings.dart`), attached in `app_pages.dart`. Use `Get.lazyPut` so a feature's repo+controller build only when its route opens.

To add a new global service (DB, AWS, analytics...): create in `services/`, register in `initServices()`, `Get.find()` where needed.

---

## 6. Auth & session

- Token stored via `AuthPrefs` (`helpers/app_key.dart`) over `Prefs` (`helpers/utils/prefs_utils.dart`), key `token_key` (saved as `"Bearer <jwt>"`), user JSON under `user_key`.
- **Inject**: `ApiClient` interceptor reads `AuthPrefs.getToken()` per request (stays fresh after login/logout).
- **Splash gate**: `helpers/third_party/check_auth.dart` `CheckAuthScreen` — 2s splash, routes to login or dashboard by token presence. It's the `INITIAL` route in `app_pages.dart`.
- **Kill session**: `ApiClient._handleResponse` on 401/500 → `Helpers.clearToken()` → clears prefs, `Get.offAllNamed(Routes.LOGIN)`.

---

## 7. Network conventions

- Base URLs in `shared/constants.dart` (`BASE_URL` dummyjson auth, `NEWS_URL` spaceflight news — sample public APIs).
- Verbs: `apiClient.get/post/put/delete`. `_send` maps `DioException`: connectionError → `BadNetworkException` + snackbar; timeouts → snackbar + null; badResponse → returns response (repo/controller checks `statusCode`).
- Controllers check `res?.statusCode == 200` then parse model. Errors surface via `AppSnackBar`.

---

## 8. Responsive / theme

- Sizer extensions (`helpers/third_party/sizer/`): `.w`/`.h` design px, `.wp` width%, `.hp` height%, `.sp` scaled font, `.r` radius. Wrap app in `Sizer` (done in `main.dart`).
- **One screen foundation**: EVERY screen is an `AppbarTemplate` — it handles status bar + SafeArea + app bar. `AppbarTemplate(title, body)` for titled, `showBack: false` for root/tab, `showAppBar: false` for a custom-header screen (login/splash), or pass `children:` for a padded scroll form. The only exception is a tab shell (`DashboardPage`), a plain `Scaffold` holding `AppbarTemplate` tab pages.
- **Text / inputs / buttons come from the theme, not wrappers**: raw `Text('x', style: kTitle)` (or bare `Text` → `appTextTheme`), raw `TextFormField` (styled via `appTheme.inputDecorationTheme`), raw `ElevatedButton` (via `elevatedButtonTheme`). No `TextApp`/`TextFieldApp` — deleted; styling is global.
- **Safe area**: owned once by `AppbarTemplate`. Don't add a second `SafeArea` inside a screen.
- **Status bar**: `appOverlayStyle(brightness)` in `theme.dart` — adaptive; applied automatically by `AppbarTemplate`.
- **Theme**: `appTheme` (ThemeData: `appTextTheme` + input + button themes) in `shared/theme.dart`, wired into `GetMaterialApp` (`main.dart`). Tokens: colors (`kBlueColor`…), `defaultFont`, weights, text styles (`kH1`/`kTitle`/`kBody`…), radii (`rSm`/`rMd`/`rLg`). No hardcoded hex/font in widgets.

---

## 9. Naming conventions

- Routes: `SCREAMING_SNAKE` consts in `Routes`.
- Custom Flutter-widget wrappers (behavioural, not styling): suffix `App` (`LoadingApp`). System addons: prefix `App` (`AppSnackBar`). Templates: suffix `Template` (`AppbarTemplate`).
- System addons: prefix `App` (`AppDialog`, `AppSnackBar`, `AppBottomSheet`).
- Repositories: `<Domain>Repository`. Controllers: `<Feature>Controller`. Models: `<Name>Model`. Bindings: `<Feature>Binding`.
- Templates: suffix `Template`. Global small widgets: descriptive (`RoundedButton`, `BoxSkeleton`).

---

## 10. Add-a-feature checklist

1. `modules/<feature>/` → `controllers/`, `models/`, `views/` (+ `components/` for feature-local widgets, `datas/` for hardcoded mock data — both optional).
2. Model with `fromJson`/`toJson`.
3. `repository/<feature>_repository.dart` — endpoint via `ApiClient`, wrap `ServerException`.
4. Controller — `.obs` state, call repository, map model.
5. View — `GetView<Controller>`, `Obx` for reactive parts.
6. `routes/routes.dart` — add route const.
7. `routes/app_bindings.dart` — `<Feature>Binding` lazyPut repo+controller.
8. `routes/app_pages.dart` — `GetPage(name, page, bindings)`.
