#!/usr/bin/env bash
#
# setup.sh — turn this boilerplate into your ready-to-run Flutter app.
#
# Default = IN-PLACE: the folder you cloned into becomes the app (no second
# folder is created). It generates the platform dirs (android/ios/web), renames
# the "myapp" token to your package, sets the display name, applies the chosen
# mode, resolves deps, then removes the boilerplate's git history + this script.
#
# One command (recommended):
#   APP=my_app; git clone --depth 1 <repo-url> "$APP" && cd "$APP" \
#     && ./setup.sh -y -n "$APP"
#   # -> ./$APP is the finished app.  then:  flutter run
#
# Interactive:
#   ./setup.sh                 # prompts for everything
#
# Flags:
#   -n package name (auto-lowercased; "My App"/"my-app" -> "my_app")   [required with -y]
#   -o org (reverse-domain, auto-lowercased)          default: com.example
#   -d display name (verbatim; android/ios/web)        default: package name
#   -m mode: slim (default; network-only, no webview/pdf/file_picker) | standard
#   -i app/launcher icon png (1024x1024, optional)     -l in-app logo png (optional)
#   -p output dir  (ADVANCED: build into a NEW dir instead of in-place; keeps the clone)
#   -y non-interactive (use defaults for anything not passed; needs -n)
#
# Rename covers: pubspec name, package:myapp/ imports, bundle/app id (via
# flutter create --org), and display name across Android/iOS/web.
#
set -euo pipefail

# ---- pretty output --------------------------------------------------------
c_reset=$'\033[0m'; c_blue=$'\033[34m'; c_green=$'\033[32m'; c_red=$'\033[31m'; c_dim=$'\033[2m'
info()  { printf "%s➜%s %s\n" "$c_blue" "$c_reset" "$*"; }
ok()    { printf "%s✓%s %s\n" "$c_green" "$c_reset" "$*"; }
die()   { printf "%s✗%s %s\n" "$c_red" "$c_reset" "$*" >&2; exit 1; }

BOILERPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOKEN="myapp"   # placeholder package name baked into the boilerplate

# ---- name normalisation (rename-package style) ----------------------------
# A Dart/Flutter package name MUST be lowercase_snake. Normalise whatever the
# user types instead of only rejecting it: "My App" / "my-app" -> "my_app".
normalize_pkg() {
  local s="$1"
  s="$(printf '%s' "$s" | tr '[:upper:]' '[:lower:]')"        # always lowercase first
  s="$(printf '%s' "$s" | tr ' -' '__')"                      # spaces / hyphens -> _
  s="$(printf '%s' "$s" | LC_ALL=C sed 's/[^a-z0-9_]//g')"    # drop non-ascii/invalid
  s="$(printf '%s' "$s" | sed 's/^[0-9_]*//')"                # must start with a letter
  s="$(printf '%s' "$s" | sed 's/__*/_/g; s/_$//')"           # collapse/trim underscores
  printf '%s' "$s"
}
# Org / bundle prefix is also lowercased (reverse-domain, dots kept).
normalize_org() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | LC_ALL=C sed 's/[^a-z0-9._]//g'; }

# ---- args -----------------------------------------------------------------
PKG=""; ORG=""; DISPLAY=""; ICON=""; LOGO=""; OUT=""; MODE=""; NONINT=0
while getopts "n:o:d:i:l:p:m:yh" opt; do
  case "$opt" in
    n) PKG="$OPTARG" ;;
    o) ORG="$OPTARG" ;;
    d) DISPLAY="$OPTARG" ;;
    i) ICON="$OPTARG" ;;
    l) LOGO="$OPTARG" ;;
    p) OUT="$OPTARG" ;;
    m) MODE="$OPTARG" ;;
    y) NONINT=1 ;;
    h) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown flag (use -h)";;
  esac
done

# ---- prerequisites --------------------------------------------------------
command -v flutter >/dev/null || die "flutter not found in PATH"

# ---- prompts (skipped entirely with -y) -----------------------------------
ask() {
  local q="$1" def="${2:-}" ans
  if [ "$NONINT" = 1 ]; then printf '%s' "$def"; return; fi
  read -rp "$q${def:+ [$def]}: " ans; printf '%s' "${ans:-$def}"
}

[ -z "$PKG" ]     && PKG="$(ask 'Package name (lowercase_snake, e.g. my_app)')"
[ -z "$ORG" ]     && ORG="$(ask 'Organization (reverse-domain)' 'com.example')"
[ -z "$DISPLAY" ] && DISPLAY="$(ask 'Display name (shown under the icon)' "$PKG")"
[ -z "$MODE" ]    && MODE="$(ask 'Mode: slim (network-only) or standard (all plugins)' 'slim')"
[ -z "$ICON" ]    && ICON="$(ask 'App icon path (1024x1024 png, blank = keep default)' '')"
[ -z "$LOGO" ]    && LOGO="$(ask 'In-app logo path (login+splash, blank = keep default)' '')"
# Blank OUT = in-place (this folder becomes the app).
[ -z "$OUT" ]     && OUT="$(ask 'Output dir (blank = set up THIS folder in place)' '')"

# ---- normalise then validate ----------------------------------------------
MODE="$(printf '%s' "$MODE" | tr '[:upper:]' '[:lower:]')"
[[ "$MODE" == "slim" || "$MODE" == "standard" ]] || die "mode must be 'slim' or 'standard' (got: $MODE)"
RAW_PKG="$PKG"; RAW_ORG="$ORG"
PKG="$(normalize_pkg "$PKG")"
ORG="$(normalize_org "$ORG")"
[ "$RAW_PKG" != "$PKG" ] && info "package name normalised: $c_dim$RAW_PKG$c_reset -> $c_green$PKG$c_reset"
[ "$RAW_ORG" != "$ORG" ] && info "org normalised: $c_dim$RAW_ORG$c_reset -> $c_green$ORG$c_reset"

[ -n "$PKG" ] || die "package name required (pass -n my_app)"
[[ "$PKG" =~ ^[a-z][a-z0-9_]*$ ]] || die "package name must be lowercase_snake (got: $PKG)"
[[ "$PKG" != "$TOKEN" ]]          || die "pick a name other than the placeholder '$TOKEN'"
[[ "$ORG" =~ ^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$ ]] || die "org must be reverse-domain (got: $ORG)"
[ -n "$ICON" ] && [ ! -f "$ICON" ] && die "icon file not found: $ICON"
[ -n "$LOGO" ] && [ ! -f "$LOGO" ] && die "logo file not found: $LOGO"

# in-place vs new-dir
if [ -z "$OUT" ]; then
  IN_PLACE=1; OUT="$BOILERPLATE_DIR"
else
  IN_PLACE=0
  OUT="$(cd "$(dirname "$OUT")" 2>/dev/null && pwd)/$(basename "$OUT")" || die "bad output path: $OUT"
  [ -e "$OUT" ] && die "output dir already exists: $OUT"
fi

APP_ID="$ORG.$PKG"
info "Creating $c_dim$APP_ID$c_reset ($([ "$IN_PLACE" = 1 ] && echo in-place || echo "$OUT"))"

# ---- 1+2. platform dirs + boilerplate -------------------------------------
if [ "$IN_PLACE" = 1 ]; then
  # Generate platform folders in a temp project, then copy just those in.
  # lib/ assets/ pubspec.yaml analysis_options.yaml are already here (the clone).
  TMP="$(mktemp -d)"
  flutter create --org "$ORG" --project-name "$PKG" \
    --platforms android,ios,web "$TMP" >/dev/null
  for d in android ios web .metadata; do
    rm -rf "${OUT:?}/$d"
    cp -R "$TMP/$d" "$OUT/$d"
  done
  rm -rf "$TMP"
  ok "generated platform dirs (android/ios/web) — in place"
else
  flutter create --org "$ORG" --project-name "$PKG" \
    --platforms android,ios,web "$OUT" >/dev/null
  ok "flutter create"
  rm -rf "$OUT/lib" "$OUT/test"
  cp -R "$BOILERPLATE_DIR/lib"                   "$OUT/lib"
  cp -R "$BOILERPLATE_DIR/assets"                "$OUT/assets"
  cp    "$BOILERPLATE_DIR/pubspec.yaml"          "$OUT/pubspec.yaml"
  cp    "$BOILERPLATE_DIR/analysis_options.yaml" "$OUT/analysis_options.yaml"
  [ -d "$BOILERPLATE_DIR/test" ] && cp -R "$BOILERPLATE_DIR/test" "$OUT/test"
  ok "injected lib / assets / pubspec"
fi

# ---- 2b. slim mode: drop heavy plugins + the files that use them ----------
# Removes webview / pdf / file_picker (+ transitive path_provider) and the two
# unused-by-default template files that import them. Core stays: network
# (cached_network_image), loading, sizer, dio, get. See README "Modes".
if [ "$MODE" = "slim" ]; then
  rm -f "$OUT/lib/shared/widgets/templates/webview_template.dart" \
        "$OUT/lib/shared/widgets/templates/pdfview_template.dart"
  for dep in webview_flutter flutter_pdfview file_picker path_provider timeago form_field_validator; do
    perl -0pi -e "s/^[ \t]*$dep:.*\n//mg" "$OUT/pubspec.yaml"
  done
  [ -f "$OUT/lib/routes/routes.dart" ] && \
    perl -0pi -e 's/^[ \t]*static const WEBVIEW = .*\n//mg' "$OUT/lib/routes/routes.dart"
  ok "slim mode — removed webview / pdf / file_picker (+ unused deps)"
else
  ok "standard mode — all plugins kept"
fi

# ---- 3. rename token + names ---------------------------------------------
python3 - "$OUT" "$PKG" "$DISPLAY" <<'PY'
import sys, re, os, glob
out, pkg, display = sys.argv[1], sys.argv[2], sys.argv[3]

# package token: lib + test + pubspec name
for f in glob.glob(f"{out}/lib/**/*.dart", recursive=True) + \
         glob.glob(f"{out}/test/**/*.dart", recursive=True) + \
         [f"{out}/pubspec.yaml"]:
    if not os.path.exists(f): continue
    s = open(f).read()
    s = s.replace("myapp", pkg)          # package:myapp/  +  name: myapp
    open(f, "w").write(s)

# display name in constants + login header (targeted, keeps `class MyApp`)
consts = f"{out}/lib/shared/constants.dart"
if os.path.exists(consts):
    s = open(consts).read()
    s = re.sub(r'const APP_NAME = ".*?";', f'const APP_NAME = "{display}";', s)
    open(consts, "w").write(s)

login = f"{out}/lib/modules/auth/views/login_page.dart"
if os.path.exists(login):
    s = open(login).read().replace("Welcome to MyApp", f"Welcome to {display}")
    open(login, "w").write(s)
PY
ok "renamed token '$TOKEN' -> '$PKG'"

# ---- 4. platform tweaks (display name + INTERNET permission) --------------
MANIFEST="$OUT/android/app/src/main/AndroidManifest.xml"
if [ -f "$MANIFEST" ]; then
  perl -0pi -e "s/android:label=\"[^\"]*\"/android:label=\"$DISPLAY\"/" "$MANIFEST"
  grep -q 'android.permission.INTERNET' "$MANIFEST" || \
    perl -0pi -e 's/(<manifest[^>]*>)/$1\n    <uses-permission android:name="android.permission.INTERNET"\/>/' "$MANIFEST"
fi
PLIST="$OUT/ios/Runner/Info.plist"
if [ -f "$PLIST" ]; then
  # CFBundleDisplayName = shown under the icon; CFBundleName = short app name.
  perl -0pi -e "s|(<key>CFBundleDisplayName</key>\s*<string>)[^<]*|\${1}$DISPLAY|" "$PLIST"
  perl -0pi -e "s|(<key>CFBundleName</key>\s*<string>)[^<]*|\${1}$DISPLAY|" "$PLIST"
fi
# Web: page title + PWA manifest name.
WEB_INDEX="$OUT/web/index.html"; WEB_MANIFEST="$OUT/web/manifest.json"
[ -f "$WEB_INDEX" ] && perl -0pi -e "s|<title>[^<]*</title>|<title>$DISPLAY</title>|" "$WEB_INDEX"
if [ -f "$WEB_MANIFEST" ]; then
  perl -0pi -e "s|(\"name\"\s*:\s*\")[^\"]*|\${1}$DISPLAY|" "$WEB_MANIFEST"
  perl -0pi -e "s|(\"short_name\"\s*:\s*\")[^\"]*|\${1}$DISPLAY|" "$WEB_MANIFEST"
fi
ok "set display name (android/ios/web) + INTERNET permission"

# ---- 5. deps + assets -----------------------------------------------------
if [ -n "$LOGO" ]; then
  mkdir -p "$OUT/assets/images"
  cp "$LOGO" "$OUT/assets/images/app_logo.png"
  ok "in-app logo set"
fi

( cd "$OUT" && flutter pub get >/dev/null ) && ok "flutter pub get"

# App/launcher icon (needs deps resolved first)
if [ -n "$ICON" ]; then
  cp "$ICON" "$OUT/assets/icons/app_icon.png"
  ( cd "$OUT" && dart run flutter_launcher_icons >/dev/null 2>&1 ) && ok "app icon generated"
fi

# ---- 6. in-place cleanup (fresh app, no boilerplate leftovers) -------------
if [ "$IN_PLACE" = 1 ]; then
  rm -rf "$OUT/.git"            # drop boilerplate history
  ( cd "$OUT" && git init -q 2>/dev/null ) && info "fresh git repo initialised"
  rm -f "$OUT/setup.sh"        # one-shot; safe to remove while running (already loaded)
  ok "cleaned up (removed boilerplate git history + setup.sh)"
fi

# ---- done -----------------------------------------------------------------
printf "\n%s✓ Done.%s  %s (%s) — %s mode\n" "$c_green" "$c_reset" "$DISPLAY" "$APP_ID" "$MODE"
[ "$MODE" = "slim" ] && printf "  %sadd webview/pdf/file_picker later with 'flutter pub add <pkg>'%s\n" "$c_dim" "$c_reset"
if [ "$IN_PLACE" = 1 ]; then
  printf "  %sflutter run%s   %s(you're already in the app folder)%s\n\n" "$c_dim" "$c_reset" "$c_dim" "$c_reset"
else
  printf "  %scd %s && flutter run%s\n\n" "$c_dim" "$OUT" "$c_reset"
fi
