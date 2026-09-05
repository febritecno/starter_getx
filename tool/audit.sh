#!/usr/bin/env bash
# tool/audit.sh — one-shot static performance/hygiene audit (read-only).
# Full guide: tool/PERFORMANCE.md. Run from repo root: bash tool/audit.sh
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

bold() { printf "\n\033[1m== %s ==\033[0m\n" "$1"; }

bold "1. flutter analyze"
flutter analyze || true

bold "2. format check (no writes)"
dart format --output=none --set-exit-if-changed lib/ \
  && echo "format: clean" \
  || echo "format: run 'dart format lib/' to fix"

bold "3. auto-fixable lints (unused imports, const, ...) — preview"
dart fix --dry-run || true
echo "-> apply with: dart fix --apply"

bold "4. unimported lib files (review before deleting)"
found=0
while IFS= read -r f; do
  base=$(basename "$f")
  if ! grep -rql --include=*.dart "$base" lib --exclude="$f" >/dev/null 2>&1; then
    echo "UNIMPORTED: $f"; found=1
  fi
done < <(find lib -name '*.dart' ! -name 'main.dart')
[ "$found" -eq 0 ] && echo "none"

bold "5. unused / missing pub deps"
if dart pub global list 2>/dev/null | grep -q dependency_validator; then
  dart pub global run dependency_validator || true
else
  echo "skip: dart pub global activate dependency_validator (once) to enable"
fi

bold "6. heaviest assets (top 10)"
if [ -d assets ]; then
  find assets -type f -exec du -h {} + 2>/dev/null | sort -rh | head -10
else
  echo "no assets/ dir"
fi

bold "7. dispose sanity — resources that need onClose/dispose"
grep -rn "TextEditingController(\|Timer(\|\.listen(\|CancelToken(\|AnimationController(" lib \
  || echo "none found"
echo "-> each above must have a matching cancel()/dispose() in onClose()/dispose()"

bold "next: size + runtime profiling"
cat <<'EOF'
  flutter build appbundle --analyze-size      # size tree (open in DevTools App Size Tool)
  flutter run --profile                        # then DevTools Performance + Memory
  See tool/PERFORMANCE.md sections 2-4.
EOF
