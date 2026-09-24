# Portfolio Flutter — Session Memory

## Objective
- Rebuild the user's HTML/CSS/JS portfolio (Houn Panha) as a Flutter app at `~/Desktop/pj/portfolio_flutter`, replicating the same UI.
- Refactored the Flutter portfolio from `ChangeNotifier` + `InheritedWidget` to GetX state management (GetX controllers, Rx, GetMaterialApp, Obx). **DONE.**

## Important Details
- User is Houn Panha, Flutter dev. Original site: `~/Desktop/pj/portfolio` (index.html, style.css, script.js, panh.png, DSC_9317 copy.JPG).
- Flutter 3.44.2, Dart 3.12.2 at `/Users/lyznhara/Desktop/JJJJ/flutter/bin/flutter`.
- Portrait used: `DSC_9317 copy.JPG` (827x1063, 600 DPI) → copied to `assets/images/portrait.JPG` (home hero + fallback `assets/images/portrait_fallback.png`).
- `font_awesome_flutter ^11.0.0` (v10 incompatible because `IconData` is final now): icons are `FaIconData`, rendered with `FaIcon`; `linkedinIn`, `solidEnvelope`, `mapLocationDot` exist.
- Deps: get, google_fonts, url_launcher, shared_preferences, font_awesome_flutter.
- UI uses Poppins via GoogleFonts.poppins; accent `#1E90FF`; light/dark themes; EN/KH i18n; responsive breakpoint 995px.

## GetX Architecture (current)
- Proper **View / Controller / Binding** structure:
  - `lib/controllers/settings_controller.dart` — SettingsController (Rx locale/theme, i18n, prefs load in onInit), AppLocale, L10nX.
  - `lib/controllers/home_controller.dart` — HomeController (scroll, activeSection, scrollTo, isDesktop via Get.width).
  - `lib/bindings/app_bindings.dart` — AppBindings → `Get.put(SettingsController(), permanent: true)` (called in PortfolioApp.initState).
  - `lib/bindings/home_bindings.dart` — HomeBindings → `Get.lazyPut(() => HomeController())` (wired on the `GetPage` route, auto-deleted on route dispose).
  - `lib/views/home_page.dart` — `PortfolioHomePage extends GetView<HomeController>` (no manual Get.put/delete).
  - `lib/app.dart` — `PortfolioApp` (StatefulWidget; initState runs AppBindings().dependencies()); `GetMaterialApp` + `Obx` themeMode + `initialRoute: '/'` + `getPages: [GetPage(name:'/', page:()=>const PortfolioHomePage(), binding: HomeBindings())]`.
- Sections/widgets use `SettingsController.to` / `HomeController.to` (static `Get.find()`).
- `RevealOnScroll` attaches to `HomeController.to.scroll` in didChangeDependencies (once).

## Gotcha
- Do NOT wrap a whole page in an Obx reading no observable → GetX "improper use" warning breaks tests.
- **Locale rebuild:** page body must rebuild on locale change. `PortfolioHomePage.build` wraps body in `Obx(() { SettingsController.to.code; return Scaffold(...); })`. Also `PortfolioApp` Obx reads `settings.code`. Otherwise only header (own Obx) updates and body text stays stale (page is `const` → ancestor rebuild diffed out).
- **Const widgets freeze language:** any subtree built from a `const` instance (identical widget == skip rebuild) never re-executes `build` on locale change. `_HeroText`/`_HeroStats` in `home_section.dart` were `const` → hero stayed English while non-const widgets (buttons, About) translated. Removed `const` from their usage sites. Rule: never `const` a widget that reads `settings.t()` at build.
- Containers with a smaller child and NO `alignment` force tight constraints → child sits top-left (glyph ~13.8px high). `SocialIconButton` now has `alignment: Alignment.center`.
- No `Tooltip`/`find.byTooltip` in app anymore (see mouse_tracker bug below). Tests find header icons via faIcon() codepoint predicate (`FaIconData.codePoint` == `w.icon?.codePoint` — FA v11 FaIcon stores plain `IconData`).
- FA v11: `FaIconData` does NOT extend `IconData`; `FaIcon.icon` is `IconData?`. Compare by `.codePoint`. `FaIcon` = RichText (glyph via font metrics); `leadingDistribution.even`, height 1.0.

## Verification (all green)
- `flutter analyze` → No issues.
- `flutter test` → 10 tests pass (widget_test, smoke_test x2, header_tap_test x5 incl. mobile hamburger nav, header_hover_test mouse-hover toggle).
- `flutter build web --release` → succeeds.

## Known framework bug handled
- On desktop/web debug runs, Flutter can spam `mouse_tracker.dart: '!_debugDuringDeviceUpdate'` asserts (flutter/flutter#85383, #127870, #172414). Debug-only assert; harmless in release/profile. Triggered by Material `Tooltip` overlay MouseRegions over state-changing controls.
- Fix applied: removed Material `Tooltip` from header `_CircleIcon`; icons now wrapped in `Semantics(label, button:true)` (a11y preserved). Rebuilt test finders.

## Relevant Files
- `lib/settings.dart`, `lib/app.dart`, `lib/home_page.dart`, `lib/widgets.dart`, `lib/sections/*.dart` — GetX-ified.
- `lib/strings.dart`, `lib/data.dart`, `lib/theme.dart` — unchanged data/theme layer.
- `test/widget_test.dart`, `test/smoke_test.dart`.
- `web/index.html` + `web/manifest.json` — metadata in Khmer context (Houn Panha Flutter Developer).