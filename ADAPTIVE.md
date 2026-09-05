# ADAPTIVE.md — Multiplatform Adaptive UI

How to build **one codebase** that looks right on phone, tablet, desktop and web — perfect and
maintainable. `DESIGN.md` = how it looks, this file = how it **adapts**. Golden rule: **scale by
default, restructure only at breakpoints, style only from the theme.**

---

## 1. The two layers of adaptivity

Use both, in this order — don't reach for the second until the first isn't enough.

1. **Scale everything with Sizer** (the default). `.w` / `.h` (layout px), `.sp` (font), `.r`
   (radius), `.wp` / `.hp` (percent). You write the design-spec pixel; Sizer scales it from the
   375×812 baseline to the real device. This alone handles ~90% of screen-size variation. **No raw
   pixel literals for layout.**
2. **Restructure at breakpoints** when proportional scaling would look wrong (a phone form stretched
   across a desktop is ugly, not adaptive). Switch *layout*, not just size: columns, rails, split views.

```dart
// layer 1 — scaling (always)
Padding(padding: EdgeInsets.all(16.w), child: Text('x', style: kBody));

// layer 2 — breakpoint restructure (only when needed)
final cols = context.responsive(phone: 1, tablet: 2, desktop: 3);
```

---

## 2. Breakpoints & the responsive helper

`helpers/utils/responsive.dart` (extensions on `BuildContext`, backed by Sizer):

| API | Use |
|-----|-----|
| `context.isPhone / isTablet / isDesktop` | branch layout by width class |
| `context.screenClass` | `ScreenClass.phone/tablet/desktop` |
| `context.responsive(phone:, tablet:, desktop:)` | pick a value per class (tablet/desktop fall back down) |
| `context.isPortrait / isLandscape` | orientation branch |
| `context.isDesktopPlatform` | true platform (web/mac/win/linux), not just a wide window |
| `context.contentMaxWidth` | cap body width on big screens |
| `context.screenW / screenH` | live size |

Breakpoints (width): **phone < 600 ≤ tablet < 1024 ≤ desktop**. Change in one place (`Breakpoints`).

**Decide by width class, not device brand.** A large tablet and a small desktop window should get the
same layout — that's why the class is width-based, with `isDesktopPlatform` reserved for genuine
platform behaviour (hover, right-click, menus).

---

## 3. Layout patterns (maintainable)

- **`LayoutBuilder`** for component-level adaptivity (a card that reflows inside its own box) — prefer
  it over `MediaQuery` so a widget adapts to *its* space, not the whole screen. Reusable + testable.
- **Grid that adapts column count:** `GridView` with
  `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 360.w)` — columns fall out of the
  available width automatically, no manual breakpoint math.
- **Cap line length on wide screens:** wrap page bodies in
  `Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: context.contentMaxWidth), ...))`.
  Full-bleed text across a desktop is unreadable.
- **Phone→tablet navigation:** bottom nav / stacked pages on phone; a persistent side rail + detail
  pane (master-detail) on tablet/desktop. Branch once at the shell (`DashboardPage`), keep the tab
  *pages* identical — they're `AppbarTemplate`s either way.
- **Orientation:** don't fight it per-widget; let scaling handle it, restructure only for genuine
  landscape layouts (media, split view).
- **Keyboard/insets:** `AppbarTemplate` handles safe area top+bottom; use `children:` for scrollable
  forms and `resizeToAvoidBottomInset` for pinned footers (RULES.md §7, §8).

---

## 4. Platform adaptivity (iOS / Android / web / desktop)

- **Visual language:** this app uses one Material design system across platforms for consistency
  (single source of truth beats per-OS drift). Keep it unless a screen genuinely needs Cupertino.
- **Behaviour that must differ** — gate with `context.isDesktopPlatform` / `defaultTargetPlatform`:
  hover states, tooltips, right-click menus, keyboard shortcuts, scrollbar visibility, mouse drag.
- **Input:** desktop/web need visible focus + scrollbars (`Scrollbar`), larger hit areas stay ≥ 44px
  on touch. Don't rely on hover for anything essential on touch.
- **Back / system:** `AppbarTemplate`'s `PopScope` + `Get.back()` work everywhere; web also needs
  sane named routes (already the case via GetX routing).
- **Web:** cap `contentMaxWidth`, avoid infinite-height unbounded lists, test text selection.

---

## 5. Appearance is ONE source — `theme.dart`

The whole point of `theme.dart`: **define appearance once, reuse everywhere, so every widget is
uniform** and a restyle is a one-file change. Never restyle per-screen.

- **Text:** `k*` styles (`kH1/kH2/kTitle/kBody/kBodySm/kCaption/kButton`) → `appTextTheme`. Bare
  `Text('x')` inherits `kBody`; use `Text('x', style: kTitle)` otherwise.
- **Inputs / buttons:** raw `TextFormField`, `ElevatedButton`, `TextButton`, `OutlinedButton` — all
  styled by `appTheme` (`inputDecorationTheme`, `*ButtonTheme`). No per-field decoration.
- **Surfaces:** raw `Card`, `Divider`, `Chip`, `Dialog`, bottom sheet, `SnackBar`, progress indicator —
  all themed in `appTheme`. Use them raw; they come out uniform.
- **Colors / radii / spacing:** `k*Color` tokens, `rSm/rMd/rLg`, the whitespace scale (DESIGN.md §5).
- **App bar / status bar:** `kAppBarTitle` + `AppbarTemplate` (consistent, overridable).

**Rule:** if two screens style the same kind of widget differently by hand, that's a bug — push the
style into `theme.dart` and delete the local override. Adding a new reusable appearance? It goes in
`theme.dart` (a token or a component theme), not inline.

---

## 6. Checklist — perfect & maintainable adaptive UI

- [ ] All sizes via Sizer (`.w/.h/.sp/.r`), zero raw layout pixels.
- [ ] Layout restructures at width breakpoints via `context.responsive` / `isTablet` — not per device brand.
- [ ] `LayoutBuilder` / max-extent grids for component-level reflow; content width capped on desktop/web.
- [ ] Phone vs tablet nav branched once at the shell; tab pages unchanged.
- [ ] Platform-specific behaviour gated by `isDesktopPlatform` / `defaultTargetPlatform`, not scattered.
- [ ] Every widget's appearance comes from `theme.dart`; no per-screen restyle.
- [ ] Safe area + status bar via `AppbarTemplate`; no overflow at any size (RULES.md §7).
- [ ] Verified at phone / tablet / desktop widths and both orientations.
