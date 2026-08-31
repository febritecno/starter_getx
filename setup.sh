#!/usr/bin/env bash
#
# setup.sh — scaffold a new Flutter app from this boilerplate.
#
# Flow:
#   1. flutter create a fresh project (correct org/package + latest platform dirs)
#   2. inject this boilerplate's lib/ assets/ pubspec/ analysis_options/ test/
#   3. rename the placeholder token "myapp" -> your package name
#   4. set display name, INTERNET permission, and (optionally) app icon
#   5. flutter pub get
#
# Usage:
#   ./setup.sh                        # interactive prompts
#   ./setup.sh -n my_app -o com.acme -d "My App" -i ./icon.png -l ./logo.png -p ../my_app
#
# Flags:
#   -n package name (lowercase_snake)   -o org (reverse-domain)
#   -d display name                     -i app/launcher icon png (optional)
#   -l in-app logo png (login+splash)   -p output dir
#
set -euo pipefail

# ---- pretty output --------------------------------------------------------
c_reset=$'\033[0m'; c_blue=$'\033[34m'; c_green=$'\033[32m'; c_red=$'\033[31m'; c_dim=$'\033[2m'
info()  { printf "%s➜%s %s\n" "$c_blue" "$c_reset" "$*"; }
ok()    { printf "%s✓%s %s\n" "$c_green" "$c_reset" "$*"; }
die()   { printf "%s✗%s %s\n" "$c_red" "$c_reset" "$*" >&2; exit 1; }

BOILERPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOKEN="myapp"   # placeholder package name baked into the boilerplate

# ---- args -----------------------------------------------------------------
PKG=""; ORG=""; DISPLAY=""; ICON=""; LOGO=""; OUT=""
while getopts "n:o:d:i:l:p:h" opt; do
  case "$opt" in
    n) PKG="$OPTARG" ;;
    o) ORG="$OPTARG" ;;
    d) DISPLAY="$OPTARG" ;;
    i) ICON="$OPTARG" ;;
    l) LOGO="$OPTARG" ;;
    p) OUT="$OPTARG" ;;
    h) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown flag (use -h)";;
  esac
done

# ---- prerequisites --------------------------------------------------------
command -v flutter >/dev/null || die "flutter not found in PATH"

# ---- prompts (only for what wasn't passed) --------------------------------
ask() { local q="$1" def="${2:-}" ans; read -rp "$q${def:+ [$def]}: " ans; echo "${ans:-$def}"; }

[ -z "$PKG" ]     && PKG="$(ask 'Package name (lowercase_snake, e.g. my_app)')"
[ -z "$ORG" ]     && ORG="$(ask 'Organization (reverse-domain)' 'com.example')"
[ -z "$DISPLAY" ] && DISPLAY="$(ask 'Display name (shown under the icon)' "$PKG")"
[ -z "$ICON" ]    && ICON="$(ask 'App icon path (1024x1024 png, blank = keep default)' '')"
[ -z "$LOGO" ]    && LOGO="$(ask 'In-app logo/image path (login+splash, blank = keep default)' '')"
[ -z "$OUT" ]     && OUT="$(ask 'Output directory' "../$PKG")"

# ---- validation -----------------------------------------------------------
[[ "$PKG" =~ ^[a-z][a-z0-9_]*$ ]] || die "package name must be lowercase_snake (got: $PKG)"
[[ "$PKG" != "$TOKEN" ]]          || die "pick a name other than the placeholder '$TOKEN'"
[[ "$ORG" =~ ^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$ ]] || die "org must be reverse-domain (got: $ORG)"
[ -e "$OUT" ] && die "output dir already exists: $OUT"
[ -n "$ICON" ] && [ ! -f "$ICON" ] && die "icon file not found: $ICON"
[ -n "$LOGO" ] && [ ! -f "$LOGO" ] && die "logo file not found: $LOGO"

APP_ID="$ORG.$PKG"
info "Creating $c_dim$APP_ID$c_reset at $c_dim$OUT$c_reset"

# ---- 1. fresh flutter project --------------------------------------------
flutter create --org "$ORG" --project-name "$PKG" \
  --platforms android,ios,web "$OUT" >/dev/null
ok "flutter create"

# ---- 2. inject boilerplate ------------------------------------------------
rm -rf "$OUT/lib" "$OUT/test"
cp -R "$BOILERPLATE_DIR/lib"                  "$OUT/lib"
cp -R "$BOILERPLATE_DIR/assets"               "$OUT/assets"
cp    "$BOILERPLATE_DIR/pubspec.yaml"         "$OUT/pubspec.yaml"
cp    "$BOILERPLATE_DIR/analysis_options.yaml" "$OUT/analysis_options.yaml"
[ -d "$BOILERPLATE_DIR/test" ] && cp -R "$BOILERPLATE_DIR/test" "$OUT/test"
ok "injected lib / assets / pubspec"

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
  perl -0pi -e "s|(<key>CFBundleDisplayName</key>\s*<string>)[^<]*|\${1}$DISPLAY|" "$PLIST"
fi
ok "set display name + INTERNET permission"

# ---- 5. deps + assets -----------------------------------------------------
# In-app logo (login + splash screens) -> assets/images/app_logo.png
if [ -n "$LOGO" ]; then
  mkdir -p "$OUT/assets/images"
  cp "$LOGO" "$OUT/assets/images/app_logo.png"
  ok "in-app logo set"
fi

( cd "$OUT" && flutter pub get >/dev/null ) && ok "flutter pub get"

# App/launcher icon -> assets/icons/app_icon.png (needs deps resolved first)
if [ -n "$ICON" ]; then
  cp "$ICON" "$OUT/assets/icons/app_icon.png"
  ( cd "$OUT" && dart run flutter_launcher_icons >/dev/null 2>&1 ) && ok "app icon generated"
fi

# ---- done -----------------------------------------------------------------
printf "\n%s✓ Done.%s  %s (%s)\n" "$c_green" "$c_reset" "$DISPLAY" "$APP_ID"
printf "  %scd %s && flutter run%s\n\n" "$c_dim" "$OUT" "$c_reset"
