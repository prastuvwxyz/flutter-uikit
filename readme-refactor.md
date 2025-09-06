# 🛠 Refactor Guide – Flutter Project Structure

This document explains how to refactor our existing Flutter project into a **scalable monorepo structure**.

It’s written so both humans and AI assistants can follow along and safely move code.

---

## 🎯 Goal

We want our Flutter codebase to:

- Support **multiple apps** (rental, service, customer, admin, IoT, etc.)
- Share **common code** (design system, core services, utils)
- Stay **modular** (each feature or domain is isolated and testable)
- Be **easy to scale and maintain**

---

## 📂 New Project Layout

After refactor, the repo should look like this:

```
repo/
  apps/
    rental_app/        # customer-facing rental app
    service_app/       # technician / service app
    customer_app/      # rider/customer app
    admin_portal/      # dashboard / web-heavy app
  packages/
    design_system/     # shared UI kit (tokens, themes, widgets, layouts)
    core/              # shared logic: auth, networking, offline, analytics
    utils/             # helpers, extensions
    icons/             # custom icon set if needed
  tooling/
    melos.yaml         # monorepo manager config
    analysis_options.yaml
    scripts/
  README.md

```

---

## 🔑 Refactor Rules

1. **Move shared UI** (colors, typography, buttons, inputs, cards, layouts) → `packages/design_system/`
    - Export them via `design_system.dart`
    - Replace old imports in apps with `package:design_system/...`
2. **Move shared services** (auth, api clients, persistence, logging) → `packages/core/`
    - Apps should not talk to raw APIs, only via `core`.
3. **Move helpers & extensions** (date format, validators, string utils) → `packages/utils/`
4. **Keep feature code inside each app**
    - Example: `apps/rental_app/lib/features/...`
5. **Do not duplicate code** between apps. If 2+ apps need something → move it to `core` or `design_system`.

---

## 🎨 Design System Structure

Inside `packages/design_system/`:

```
design_system/
  lib/
    src/
      tokens/         # colors, spacing, typography
      foundation/     # ThemeData, extensions, component themes
      components/     # Button, Card, Input, Table, Snackbar
      patterns/       # complex UI (filter bar, scaffold, split view)
      utils/          # responsive, breakpoints
    design_system.dart
  example/            # demo app showing all widgets
  test/               # golden tests for UI

```

Use **Widgetbook** to preview components in isolation.

---

## ✅ Checklist for Migration

- [ ]  Create `apps/` and `packages/` folders
- [ ]  Move shared UI into `design_system`
- [ ]  Move common logic into `core`
- [ ]  Move helpers into `utils`
- [ ]  Update imports in all apps
- [ ]  Add `example/` inside `design_system` to demo components
- [ ]  Configure `melos.yaml` to manage all packages/apps
- [ ]  Run `flutter analyze` and fix errors
- [ ]  Add golden tests for critical UI components

---

## 🚦 How AI Should Help

When assisting in refactoring:

- If code looks like UI (buttons, cards, colors, themes) → move to `design_system`
- If code looks like business logic, networking, or DB → move to `core`
- If code looks like helpers or small functions → move to `utils`
- If code is feature-specific (rental, IoT, asset) → keep inside the app’s folder

Always update imports after moving files.

---

## 📚 References

- **Melos** for monorepo management: https://melos.invertase.dev
- **Widgetbook** for UI kit previews: https://widgetbook.io
- **Flutter Clean Architecture** guide: https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro