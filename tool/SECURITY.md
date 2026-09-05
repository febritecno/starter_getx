# tool/SECURITY.md — Security Audit Playbook

Advanced, **runnable** security guide for this app (Flutter + GetX + Dio). Written for an AI agent
and humans: every section has commands, what to look for, and the concrete fix. Run
`bash tool/security_audit.sh` for the static pass; use the sections below for the deeper manual
review. Pairs with `AGENTS.md` (review gates) and `tool/PERFORMANCE.md`.

> Threat model for a mobile client: the device and the app binary are **untrusted** — anyone can
> unpack the APK/IPA, read strings, and MITM the network. So: no secrets in the app, secure the
> token at rest, secure the transport, and never trust client-side checks for authorization.

---

## 0. One-shot audit

```bash
bash tool/security_audit.sh      # static scan: secrets, http, token logging, storage, deps
```
Read-only. Triage every finding against the sections below before shipping.

---

## 1. Secrets — nothing sensitive in the binary

- **No hardcoded** API keys, passwords, tokens, private URLs with creds. A string in Dart ships in
  the binary and is trivially extractable. Scan:
  ```bash
  grep -rniE '(api[_-]?key|secret|client[_-]?secret|password|passwd|token|bearer |authorization)\s*[:=]\s*["'"'"']' lib
  ```
  (The sample login creds in comments — `emilys/emilyspass` — are public demo creds, fine to delete.)
- **Config via `--dart-define` / `.env`** (git-ignored), not committed constants. Keys that must reach
  the client (e.g. a public Maps key) should be **restricted server-side** (referrer/bundle-id lock),
  never a privileged secret.
- **Scan git history** (a removed secret still lives in history):
  ```bash
  git log -p | grep -niE 'api[_-]?key|secret|password|BEGIN (RSA|PRIVATE)' | head
  ```
  Rotate anything found; history-scrub with BFG/`git filter-repo` if real.
- `.gitignore` must cover `.env`, `*.keystore`, `key.properties`, `*.jks`, `google-services.json`
  (if sensitive), `ios/**/GoogleService-Info.plist` where applicable.

---

## 2. Token & data at rest — SharedPreferences is NOT secure

- This boilerplate stores the auth token via `AuthPrefs` → `Prefs` (**SharedPreferences**), which is
  **plaintext** on device (readable on rooted/jailbroken devices and in backups). For a real app,
  put the token/refresh-token in the OS keystore:
  ```bash
  flutter pub add flutter_secure_storage
  ```
  Keep the `AuthPrefs` API, swap its backing store to `FlutterSecureStorage` (Keychain / Keystore).
  Non-sensitive prefs (theme, flags) can stay in SharedPreferences.
- **Don't back up secrets:** Android — `android:allowBackup="false"` (or exclude the token) in the
  manifest; iOS — Keychain items default out of iCloud unless you opt in.
- Clear all sensitive storage on logout (already: `Helpers.clearToken()` → `AuthPrefs.clearAll()`).
- No secrets/PII written to disk (files, logs, cache), no sensitive data in screenshots (consider
  `FLAG_SECURE` on Android / blur on backgrounding for sensitive screens).

---

## 3. Transport — HTTPS only, no MITM foothold

- **All endpoints HTTPS.** No `http://` (except `localhost` in dev). Scan:
  ```bash
  grep -rniE 'http://(?!localhost|127\.0\.0\.1)' lib
  ```
- **Block cleartext at the platform** (after `flutter create`): Android — ensure
  `android:usesCleartextTraffic` is **not** true (default false on API 28+); add a
  `network_security_config.xml` denying cleartext for prod. iOS — keep **ATS** on (no
  `NSAllowsArbitraryLoads = true` in `Info.plist`).
- **Certificate pinning** for high-value apps — pin via Dio's `HttpClientAdapter` / a pinning
  interceptor so a rogue CA can't MITM. Optional but recommended for finance/health.
- **Dio hardening:** never disable cert validation (`badCertificateCallback => true` is a red flag);
  set sane timeouts (already: 60s); `validateStatus` shouldn't hide real failures from security logic.

---

## 4. Logging — no secrets in logs

- `pretty_dio_logger` is **debug-only** (already guarded by `kDebugMode` in `ApiClient`) — keep it.
  Verify it never runs in release, and it does not log the `Authorization` header / request bodies
  with credentials in any build you ship.
- No `print`/`Log.info` of tokens, passwords, PII, full auth responses. Scan:
  ```bash
  grep -rniE '(print|log|debugPrint).*(token|password|authorization|secret)' lib
  ```
- Strip verbose logging from release; consider redacting known-sensitive fields before logging.

---

## 5. Auth & authorization

- Session invalidation on 401/500 is centralised in `ApiClient` — keep logout logic there only.
- **Never trust the client for authorization.** Hiding a button/route is UX, not security — the
  backend must enforce every permission. Don't gate sensitive data purely with client-side role checks.
- Token format `"Bearer <jwt>"`; don't decode a JWT to *trust* claims client-side for access control
  (fine for display only). Handle expiry/refresh; don't extend sessions client-side.
- Deep links / routes: validate arguments; don't let a crafted route open a privileged screen without
  a real auth check.

---

## 6. Platform & build hardening

- **Release obfuscation + symbol stripping:**
  ```bash
  flutter build apk --obfuscate --split-debug-info=build/symbols
  flutter build ipa --obfuscate --split-debug-info=build/symbols
  ```
  Keep the `build/symbols` to de-obfuscate crash traces; don't ship them.
- **Android:** `minifyEnabled`/`shrinkResources` on for release (R8); no `android:debuggable="true"`;
  no unnecessary `exported="true"` components; request only needed permissions (this app needs just
  `INTERNET`). WebView (standard mode): `javascriptMode` only if required, no `allowFileAccess`, load
  only trusted URLs.
- **iOS:** ATS on; no debug entitlements in release; Keychain for secrets.
- No `debugPrint`/asserts leaking info in release; `debugShowCheckedModeBanner: false` (already).

---

## 7. Dependencies — known vulns & supply chain

```bash
flutter pub outdated                     # stale/abandoned packages
dart pub global activate pana && pana .   # package health/score (optional)
# OSV scanner (Google) against the lockfile:
osv-scanner --lockfile=pubspec.lock
```
- Pin versions; review new/updated deps before adding (a plugin runs with app privileges).
- Remove unused deps (fewer transitive risks) — see `tool/PERFORMANCE.md §1`. Slim mode already drops
  webview/pdf/file_picker.

---

## 8. Repeatable AI security loop

1. `bash tool/security_audit.sh` → triage every hit (secrets, http, token-logging, insecure storage).
2. Confirm token at rest is in secure storage (§2), transport is HTTPS + no cleartext (§3).
3. `flutter pub outdated` / `osv-scanner` → update/replace vulnerable deps.
4. Build release with `--obfuscate --split-debug-info`; verify no debug logging ships.
5. Manual: authorization enforced server-side (§5), no secrets in git history (§1).
6. Record findings + fixes in the PR; add any new rule to `AGENTS.md`.
