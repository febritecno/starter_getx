# Flutter GetX Boilerplate

A maintainable, core-only Flutter starter (GetX + Dio). The repo tracks only
the **core** — `lib/`, `assets/`, `pubspec.yaml`, `setup.sh`. Platform folders
(`android/ios/web/...`) are generated on demand by `setup.sh` via
`flutter create`, so there is nothing platform-specific to maintain.

## Quick start (one line)

```bash
git clone https://github.com/febritecno/starter_getx my_app && cd my_app && ./setup.sh
```

`setup.sh` asks for the app name, package/org, display name, and optional
icon/logo, then scaffolds a ready-to-run project.

Non-interactive:

```bash
./setup.sh -n my_app -o com.acme -d "My App" -i ./icon.png -l ./logo.png -p ../my_app
```

| flag | meaning |
|------|---------|
| `-n` | package name (`lowercase_snake`) |
| `-o` | organization (reverse-domain, e.g. `com.acme`) |
| `-d` | display name (shown under the launcher icon) |
| `-i` | app/launcher icon png, 1024×1024 — *optional* |
| `-l` | in-app logo png (login + splash) — *optional* |
| `-p` | output directory |

Then:

```bash
cd ../my_app && flutter run
```

## What you get

- **GetX** state / routing / DI (bindings, lazy controllers, permanent services)
- **Dio** `ApiClient` — single owner of auth header (per-request token),
  connection + error handling; thin repositories (`try/catch` → `ServerException`)
- **Pixel-design sizer** — write design px (`16.w`, `18.sp`, `12.r`), scaled
  adaptively from a 375×812 baseline; percentage getters (`.wp/.hp`) kept for
  proportional layout
- **Sample flow** — login (`dummyjson.com/auth/login`, try `emilys`/`emilyspass`)
  → dashboard news feed (`spaceflightnewsapi.net`), both keyless so it runs
  out of the box

## Structure

```
lib/
  main.dart
  routes/        app_pages, bindings, routes
  modules/       auth (login) + home (news feed) — views/controllers/models
  repository/    auth_repository, dashboard_repository
  services/      api_client, exceptions
  shared/        theme, constants, reusable widgets
  helpers/       utils, system (dialog/snackbar/bottomsheet), sizer
assets/          fonts, icons, images
setup.sh         scaffolder (flutter create + inject + rename)
```

Edit `lib/` + `assets/`; `setup.sh` handles the rest.
