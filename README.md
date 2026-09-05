# Flutter GetX Boilerplate

An opinionated, maintainable, core-only Flutter starter (GetX + Dio) with a full set of
AI-friendly convention docs (see [Docs](#docs-read-these-before-adding-code)). The repo tracks only
the **core** — `lib/`, `assets/`, `pubspec.yaml`, `setup.sh`, docs, `tool/`. Platform folders
(`android/ios/web/...`) are generated on demand by `setup.sh` via `flutter create`, so there is
nothing platform-specific to maintain.

## Quick start (one command)

Set `APP` to your app name (lowercase_snake) — it's the only thing you change:

```bash
APP=my_app
git clone --depth 1 https://github.com/febritecno/starter_getx "$APP" && cd "$APP" && ./setup.sh -y -n "$APP"
flutter run
```

**In-place**: the folder you cloned into (`$APP`) *becomes* the finished app — no second
folder is created. `setup.sh` generates the platform dirs, renames everything, applies the
mode, resolves deps, then removes the boilerplate's git history and itself. `-y` uses defaults
(org `com.example`, slim mode); drop `-y` to be prompted.

Interactive (pick everything):

```bash
git clone --depth 1 https://github.com/febritecno/starter_getx my_app && cd my_app && ./setup.sh
```

| flag | meaning |
|------|---------|
| `-n` | package name (`lowercase_snake`; auto-normalised — "My App" → `my_app`) |
| `-o` | organization (reverse-domain, e.g. `com.acme`) — default `com.example` |
| `-d` | display name (shown under the launcher icon) — default = package name |
| `-m` | mode: `slim` (default) or `standard` (all plugins) |
| `-i` | app/launcher icon png, 1024×1024 — *optional* |
| `-l` | in-app logo png (login + splash) — *optional* |
| `-y` | non-interactive (use defaults for anything not passed; needs `-n`) |
| `-p` | **advanced:** build into a *new* dir instead of in-place (keeps the clone) |

### Modes

- **slim** *(default)* — network-only. Drops `webview_flutter`, `flutter_pdfview`, `file_picker`
  (+ unused `path_provider`/`timeago`/`form_field_validator`) and their template files. Fewer native
  deps, smaller build. Keeps the essentials: Dio, GetX, `cached_network_image`, Sizer, loading. Add
  any plugin back later with `flutter pub add <pkg>`.
- **standard** — everything: network + webview + pdf + file_picker.

## What you get

- **GetX** — state (`.obs`/`Obx` + `GetBuilder`), routing, DI (bindings, lazy/`fenix`/permanent).
- **Dio `ApiClient`** — single owner of the auth header (per-request token), connection + error
  handling, session-kill on 401/500; thin repositories (`try/catch` → `ServerException`).
- **One screen foundation** — `AppbarTemplate` handles safe area (top+bottom, iOS/Android),
  adaptive status bar, and the app bar. No raw `Scaffold`/`AppBar` per screen.
- **Global theme = single appearance source** — `appTheme` styles text, inputs, buttons, cards,
  dialogs, sheets, snackbars. Use raw `Text`/`TextFormField`/`ElevatedButton`; they come out uniform.
- **Adaptive, proportional UI** — write design px (`16.w`, `18.sp`, `12.r`) off a 375×812 baseline;
  Sizer scales so phone/tablet/desktop look the same in proportion. Breakpoint helpers in
  `helpers/utils/responsive.dart` for real layout switches.
- **Slim / standard modes** — ship only the plugins you use.
- **Sample flow** — login (`dummyjson.com/auth/login`, try `emilys`/`emilyspass`) → dashboard news
  feed (`spaceflightnewsapi.net`), both keyless so it runs out of the box.

## Structure

```
lib/
  main.dart                    initServices() → GetMaterialApp (routes + appTheme + Sizer)
  routes/     routes, app_pages, app_bindings   (route consts + DI wiring)
  modules/<feature>/           controllers/ models/ views/ components/ datas/
                               auth (login) + home (news feed + dashboard shell)
  repository/                  endpoint paths → ApiClient → ServerException
  services/                    api_client (Dio owner) + app_services (DI bootstrap)
  shared/     theme.dart       colors, k* text styles, appTheme (the design system)
              constants.dart   APP_NAME, base URLs, asset paths
              widgets/         loading_app + components/ + templates/ (AppbarTemplate)
  helpers/    system/ (dialog/snackbar/bottomsheet)  utils/ (Prefs, responsive, ...)  third_party/ (sizer)
assets/                        fonts, icons, images
setup.sh                       in-place scaffolder (flutter create + rename + mode)
tool/                          audit.sh (perf) + security_audit.sh + playbooks
```

Edit `lib/` + `assets/`; `setup.sh` handles the platform + rename.

## Docs (read these before adding code)

| File | What it answers |
|------|-----------------|
| `CLAUDE.md` | **Where** — folder map, data-flow (View→Controller→Repository→ApiClient→Dio), add-a-feature checklist |
| `RULES.md` | **How to write** — layer boundaries, state, networking, naming, hygiene |
| `DESIGN.md` | **How it looks** — safe area, global app bar, type scale, color, whitespace, UX states |
| `ADAPTIVE.md` | **How it adapts** — one codebase → phone/tablet/desktop/web (Sizer + breakpoints) |
| `GETX_CHEATSHEET.md` | Copy-paste GetX patterns — `.obs`/`Obx`, bindings/DI, routing, workers |
| `AGENTS.md` | PR-review checklist — the violations to catch |
| `tool/PERFORMANCE.md` | Runnable playbook — perf/size/memory audit + fixes (`bash tool/audit.sh`) |
| `tool/SECURITY.md` | Runnable security audit — secrets, token storage, TLS, deps (`bash tool/security_audit.sh`) |

Baked-in, ready to go: one **screen foundation** `AppbarTemplate` (centralized safe area + adaptive
status bar + app bar), a single global **theme** (`appTheme` in `theme.dart` — text styles, input &
button themes; use raw `Text`/`TextFormField`/`ElevatedButton`), responsive **Sizer**, and a thin
**Dio** `ApiClient` with auth-header injection and session-kill on 401/500.
