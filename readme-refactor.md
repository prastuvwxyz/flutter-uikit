# 🛠 Refactor Guide – Flutter Monorepo (Web-First Rental Fleet Portal)

This document explains how to refactor our existing Flutter project into a **scalable monorepo structure**, starting with **`apps/rental_fleet_portal`** (web-first), and keeping the door open for Android/iOS/tablets later.

It’s written so both humans and AI assistants can follow along and safely move code.

---

## 🎯 Goals

We want our Flutter codebase to:

- Ship a **web-first portal** quickly (**rental_fleet_portal**)
- Support **multiple apps** later (service, customer, admin, IoT)
- Share **common code** (design system, core services, utils)
- Stay **modular** (feature/domain isolation + testable)
- Be **easy to scale and maintain** across platforms

---

## 📂 New Project Layout (target)

After refactor, the repo should look like this:

```
repo/
  apps/
    rental_fleet_portal/  # web-first portal (initial focus)
    service_app/          # (next)
    customer_app/         # (next)
    admin_portal/         # (next)
  packages/
    design_system/        # shared UI kit (tokens, themes, widgets, layouts)
    core/                 # shared logic: auth, networking, offline, analytics
    utils/                # helpers, extensions
    icons/                # custom icons (optional)
  tooling/
    melos.yaml            # monorepo manager config
    analysis_options.yaml
    scripts/
  README.md

```

> For now, only apps/rental_fleet_portal is required. Mobile/tablet shells can be added later without breaking structure.
> 

---

## 🧭 App Structure (rental_fleet_portal)

```
apps/rental_fleet_portal/
  lib/
    app/
      app.dart
      routes.dart         # go_router routes & guards
      di.dart             # dependency wiring
    features/
      auth/
      dashboard/
      vehicles/
      rentals/
      maintenance/
      partners/
      reports/
      settings/
    shared/               # app-specific helpers (not global)
    main_web.dart         # web entry (PathUrlStrategy, etc.)
    main_mobile.dart      # placeholder for later (Android/iOS)
  web/                    # web config (manifest, icons, sw.js)
  pubspec.yaml

```

---

## 🔑 Refactor Rules

1. **Move shared UI** (colors, typography, buttons, inputs, cards, layouts) → `packages/design_system/`
    - Export via `design_system.dart`
    - Replace old imports with `package:design_system/...`
2. **Move shared services** (auth, API/Dio clients, persistence, logging, analytics) → `packages/core/`
    - **Apps must not call raw APIs directly**; always go through `core`.
3. **Move helpers & extensions** (date formatting, validators, parsing) → `packages/utils/`
4. **Keep feature code inside each app**
    - Example: `apps/rental_fleet_portal/lib/features/vehicles/...`
5. **No duplication** between apps. If ≥ 2 apps need it → move to `core` or `design_system`.

---

## 🎨 Design System Structure

Inside `packages/design_system/`:

```
design_system/
  lib/
    src/
      tokens/         # colors, spacing, typography
      foundation/     # ThemeData, ColorScheme, component subthemes
      components/     # Button, Card, Input, DataTable, Snackbar
      patterns/       # FilterBar, SplitView, PageScaffold, SideNav
      utils/          # responsive utilities, breakpoints
    design_system.dart
  example/            # demo app showing all widgets
  test/               # golden tests for UI

```

> Tip: add Widgetbook later to preview components in isolation (nice-to-have, not blocking refactor).
> 

---

## 🧩 Core Package (shared logic)

Inside `packages/core/`:

```
core/
  lib/
    auth/             # OIDC/OAuth2, token storage, session
    http/             # Dio client, interceptors, retry
    storage/          # local storage abstractions (web: IndexedDB)
    analytics/        # events, audit log
    rbac/             # role/permission checks
    env/              # env config & flavors
    offline/          # (optional) queue/sync layer

```

---

## 🔁 Mapping From Existing Project

Use this table to decide where existing files go:

| If your current file looks like… | Move it to… |
| --- | --- |
| Theme, colors, spacing, text styles, widgets | `packages/design_system/` |
| Buttons, inputs, cards, tables, layout scaffolds | `packages/design_system/` |
| API services, auth, interceptors, storage, analytics | `packages/core/` |
| Date/number format, validation, string/collection utils | `packages/utils/` |
| Screens & state for vehicles/rentals/maintenance | `apps/rental_fleet_portal/features/` |
| App router/DI/shell | `apps/rental_fleet_portal/app/` |
| App-specific helpers (not useful outside) | `apps/rental_fleet_portal/shared/` |

> After moving, fix imports to use package:design_system/..., package:core/..., package:utils/....
> 

---

## ✅ Step-by-Step Migration Checklist

1. **Create folders** `apps/` and `packages/`
2. **Scaffold** `apps/rental_fleet_portal` (keep old app compiling during the move if needed)
3. **Extract UI** into `packages/design_system` (theme → tokens/foundation, then components/patterns)
4. **Extract services** into `packages/core` (auth, http/dio, storage, analytics)
5. **Extract helpers** into `packages/utils`
6. **Move features** (vehicles, rentals, maintenance, dashboard) into `apps/rental_fleet_portal/features/...`
7. **Wire routing** in `routes.dart` (go_router) and **guards** (RBAC, auth)
8. **Make web entry** `main_web.dart` (PathUrlStrategy, PWA later)
9. **Update imports** across the repo
10. Run `flutter analyze`, fix errors; run tests
11. (Optional) Add **Widgetbook** + golden tests to `design_system`
12. Configure **CI** to build web (`flutter build web`) and deploy

---

## 🌐 Web-First Tweaks (important)

- Use **path URL** (no `#`) in `main_web.dart`:
    
    ```dart
    import 'package:flutter_web_plugins/url_strategy.dart';
    void main() {
      setUrlStrategy(PathUrlStrategy());
      runApp(const App());
    }
    
    ```
    
- Consider **CanvasKit** renderer for fidelity; switch to HTML if size becomes an issue.
- Add **PWA** (manifest + service worker) for faster reloads and offline read.
- Desktop UX: keyboard shortcuts, focus states, resizable tables, printable pages.

---

## 🧭 Example Routes (go_router)

```dart
final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (_, __, child) => DsShell(child: child), // shared layout
      routes: [
        GoRoute(path: '/', name: 'dashboard', builder: (_, __) => const DashboardPage()),
        GoRoute(path: '/vehicles', builder: (_, __) => const VehiclesPage(), routes: [
          GoRoute(path: 'new', builder: (_, __) => const VehicleFormPage()),
          GoRoute(path: ':id', builder: (_, st) => VehicleDetailPage(id: st.pathParameters['id']!)),
        ]),
        GoRoute(path: '/rentals', builder: (_, __) => const RentalsPage()),
        GoRoute(path: '/maintenance', builder: (_, __) => const MaintenancePage()),
        GoRoute(path: '/reports', builder: (_, __) => const ReportsPage()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
      ],
    ),
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
  ],
  redirect: guardWithAuth, // implement in core/rbac + core/auth
);

```

---

## 🚦 How AI Should Help (Refactor Rules for Assistants)

- If file defines **theme, colors, typography, buttons, inputs, cards, data tables, layout** → move to `packages/design_system`
- If file defines **business logic, networking (Dio), auth, storage, analytics, RBAC** → move to `packages/core`
- If file defines **helpers** (formatting, parsing, validators, extensions) → move to `packages/utils`
- If file is **feature UI/logic specific to rental_fleet_portal** → keep in `apps/rental_fleet_portal/features/...`
- Always **update imports** after moving files
- Ensure **routes** are registered in `app/routes.dart` and guarded

---

## 🧪 Quality Gates

- `flutter analyze` passes with `-fatal-infos --fatal-warnings`
- Unit/widget tests run green
- (Optional) Golden tests for `design_system` components
- Web build works: `flutter build web` and serves without console errors

---

## ⚙️ Melos (monorepo)

Add `melos.yaml` at repo root, then:

```bash
dart pub global activate melos
melos bs
melos run analyze
melos run test

```

> We keep shared lints in tooling/analysis_options.yaml and include them in each package/app.
> 

---

## 📚 References

- **Melos** – monorepo management: [https://melos.invertase.dev](https://melos.invertase.dev/)
- **Widgetbook** – UI kit previews: [https://widgetbook.io](https://widgetbook.io/)
- **Flutter state mgmt overview**: https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro

---

## 🔜 Next: Mobile & Tablet

Once web is stable:

- Create `main_mobile.dart` using a mobile shell (bottom nav / nav rail)
- Reuse all features; only swap shell & responsive layouts from `design_system`
- Test on Android phone/tablet and iPhone/iPad
