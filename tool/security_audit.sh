#!/usr/bin/env bash
# tool/security_audit.sh — static security scan (read-only).
# Full guide: tool/SECURITY.md. Run from repo root: bash tool/security_audit.sh
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

bold() { printf "\n\033[1m== %s ==\033[0m\n" "$1"; }
warn() { printf "\033[33m! %s\033[0m\n" "$1"; }
okay() { printf "\033[32m✓ %s\033[0m\n" "$1"; }

bold "1. hardcoded secrets (keys / tokens / passwords)"
# Match secret-looking assignments; drop route consts, UI hints and key-name strings.
if grep -rniE '(api[_-]?key|secret|client[_-]?secret|password|passwd|access[_-]?token|bearer )[ \t]*[:=][ \t]*["'"'"']' lib 2>/dev/null \
     | grep -viE '= *"/|Routes\.|hintText|labelText|_key"|_KEY|const [A-Z_]+ ='; then
  warn "review above — no real secret should live in the binary (SECURITY.md §1)"
else
  okay "none (route consts / UI hints filtered)"
fi

bold "2. cleartext http:// URLs (localhost ok)"
if grep -rniE 'http://' lib 2>/dev/null | grep -viE 'localhost|127\.0\.0\.1|schemas\.android|w3\.org|apache\.org'; then
  warn "use https:// only (SECURITY.md §3)"
else
  okay "none"
fi

bold "3. secrets in logs (token/password/authorization)"
if grep -rniE '(print|debugPrint|Log\.)[^;]*(token|password|authorization|secret)' lib 2>/dev/null; then
  warn "never log secrets/PII (SECURITY.md §4)"
else
  okay "none"
fi

bold "4. TLS validation disabled (MITM foothold)"
if grep -rniE 'badCertificateCallback|allowBadCertificates|onBadCertificate.*true' lib 2>/dev/null; then
  warn "never bypass cert validation (SECURITY.md §3)"
else
  okay "none"
fi

bold "5. token-at-rest storage"
if grep -rniE 'flutter_secure_storage|FlutterSecureStorage' lib pubspec.yaml >/dev/null 2>&1; then
  okay "flutter_secure_storage present"
else
  warn "token stored in SharedPreferences (plaintext). Add flutter_secure_storage for the token (SECURITY.md §2)"
fi

bold "6. pretty_dio_logger guarded to debug only"
if grep -rn "PrettyDioLogger" lib >/dev/null 2>&1; then
  if grep -rn "kDebugMode" lib/services/api_client/api_client.dart >/dev/null 2>&1; then
    okay "network logger present and kDebugMode-guarded"
  else
    warn "PrettyDioLogger not clearly debug-guarded — must not run in release (SECURITY.md §4)"
  fi
else
  okay "no network body logger"
fi

bold "7. secrets in git history (quick scan)"
if command -v git >/dev/null && git rev-parse --git-dir >/dev/null 2>&1; then
  if git log -p -S 'apiKey' -S 'secret' 2>/dev/null | grep -qiE 'api[_-]?key|secret|BEGIN (RSA|PRIVATE)'; then
    warn "possible secret in history — rotate + scrub (SECURITY.md §1)"
  else
    okay "nothing obvious"
  fi
  # .gitignore coverage
  for pat in ".env" "*.keystore" "*.jks" "key.properties"; do
    grep -q -- "$pat" .gitignore 2>/dev/null || warn ".gitignore missing: $pat"
  done
else
  echo "not a git repo — skip"
fi

bold "8. dependency vulnerabilities"
echo "run manually (needs network):"
echo "  flutter pub outdated"
echo "  osv-scanner --lockfile=pubspec.lock   # https://osv.dev"

bold "note: platform hardening (cleartext, allowBackup, ATS, obfuscation)"
echo "checked after 'flutter create' in the generated app — see tool/SECURITY.md §3, §6."
