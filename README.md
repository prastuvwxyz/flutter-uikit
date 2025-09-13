# UIkit

TODO: description

## ✨ Project Structure

### Architecture Principles
- **MVVM with Riverpod**: State management using providers
- **Clean Separation**: packages/ui (reusable) vs app-specific components
- **Feature-Based**: Organized by business domains
- **Progressive Complexity**: Start simple, add ViewModels when needed
- **Web-First**: Responsive layout with sidebar + header + main content

```
root/
├─ melos.yaml
├─ pubspec.yaml               # root (dev deps untuk tooling)
├─ README.md
├─ apps/
│  ├─ rental-fleet-portal/
│  │  ├─ pubspec.yaml
│  │  ├─ web/                 # untuk Flutter Web
│  │  │  ├─ favicon.png       # app icon
│  │  │  ├─ index.html        # Flutter web entry
│  │  │  ├─ manifest.json     # PWA manifest
│  │  │  └─ config.json       # runtime config (API endpoints, feature flags)
│  │  └─ lib/
│  │     ├─ main.dart
│  │     ├─ core/
│  │     │  ├─ models/              # app-specific data models
│  │     │  │  ├─ motorcycle.dart
│  │     │  │  ├─ rental.dart
│  │     │  │  └─ dashboard_stats.dart
│  │     │  ├─ services/            # API services & business logic
│  │     │  │  ├─ api_client.dart
│  │     │  │  ├─ motorcycle_service.dart
│  │     │  │  └─ dashboard_service.dart
│  │     │  ├─ providers/           # global Riverpod providers
│  │     │  │  ├─ api_providers.dart
│  │     │  │  └─ config_providers.dart
│  │     │  ├─ theme.dart           # theme setup using packages/tokens Theme class
│  │     │  ├─ di.dart              # Riverpod provider registration
│  │     │  ├─ routes.dart          # GoRouter setup
│  │     │  └─ config.dart          # config.json loader
│  │     └─ features/
│  │        ├─ auth/                 # authentication pages (different layout)
│  │        │  ├─ login_page.dart
│  │        │  ├─ forgot_password_page.dart
│  │        │  ├─ reset_password_page.dart
│  │        │  └─ auth_providers.dart
│  │        ├─ dashboard/
│  │        │  ├─ dashboard_page.dart
│  │        │  └─ dashboard_providers.dart  # only for complex features
│  │        ├─ motorcycles/
│  │        │  ├─ stock_page.dart           # simple pages (no providers)
│  │        │  ├─ maintenance_page.dart
│  │        │  └─ motorcycle_providers.dart # shared motorcycle state
│  │        ├─ rentals/
│  │        │  ├─ rentals_page.dart
│  │        │  └─ rental_providers.dart
│  │        └─ shared/               # app-specific shared components
│  │           ├─ layouts/           # layout components
│  │           │  ├─ app_layout.dart      # main app layout (sidebar+header)
│  │           │  └─ auth_layout.dart     # auth pages layout (centered)
│  │           └─ widgets/           # business-specific widgets only
│  │              ├─ motorcycle_card.dart     # uses packages/ui + business logic
│  │              ├─ rental_status_badge.dart # domain-specific components
│  │              └─ fleet_summary_card.dart  # app-specific composites
│  │
│  └─ another-app/
│     ├─ pubspec.yaml
│     ├─ web/
│     └─ lib/
│
└─ packages/
   ├─ tokens/
   │  ├─ pubspec.yaml
   │  └─ lib/
   │     ├─ tokens.dart                 # barrel export
   │     └─ src/
   │        ├─ color.dart        # palette + semantic colors
   │        ├─ spacing.dart      # spacing scale (ThemeExtension)
   │        ├─ radius.dart       # radius scale (ThemeExtension)
   │        ├─ typography.dart   # font family/size/weight/line-height
   │        ├─ elevation.dart    # elevation/shadow presets
   │        ├─ motion.dart       # durations & curves
   │        ├─ breakpoint.dart   # responsive breakpoints
   │        ├─ opacity.dart      # opacities standard (disabled/overlay)
   │        ├─ zindex.dart       # layering (modal, dropdown, toast)
   │        ├─ border.dart       # border width & style
   │        ├─ icon.dart         # icon sizes
   │        ├─ state.dart        # state alpha (hover, focus, pressed)
   │        └─ schemes/
   │           ├─ light.dart      # default light scheme
   │           ├─ dark.dart       # default dark scheme
   │           ├─ theme_builder.dart     # factory for theme combinations
   │           └─ themes/
   │              ├─ indigo_light.dart  # indigo brand theme
   │              ├─ indigo_dark.dart
   │              ├─ cyan_light.dart    # alternative themes
   │              ├─ cyan_dark.dart
   │              ├─ teal_light.dart
   │              └─ teal_dark.dart
   ├─ ui/
   │  ├─ pubspec.yaml
   │  └─ lib/
   │    ├─ ui.dart                    # single public barrel export
   │    └─ src/
   │        ├─ widgets/                # atomic reusable components (flat structure)
   │        │  ├─ alert.dart
   │        │  ├─ autocomplete.dart
   │        │  ├─ avatar.dart
   │        │  ├─ badge.dart
   │        │  ├─ breadcrumbs.dart
   │        │  ├─ button.dart
   │        │  ├─ button_group.dart
   │        │  ├─ card.dart
   │        │  ├─ checkbox.dart
   │        │  ├─ chip.dart
   │        │  ├─ color_picker.dart
   │        │  ├─ date_picker.dart
   │        │  ├─ datetime_picker.dart
   │        │  ├─ dialog.dart
   │        │  ├─ divider.dart
   │        │  ├─ file_upload.dart
   │        │  ├─ icons.dart
   │        │  ├─ image.dart
   │        │  ├─ list.dart
   │        │  ├─ menu.dart
   │        │  ├─ modal.dart
   │        │  ├─ otp_input.dart
   │        │  ├─ pagination.dart
   │        │  ├─ progress.dart
   │        │  ├─ radio.dart
   │        │  ├─ rating.dart
   │        │  ├─ select.dart
   │        │  ├─ skeleton.dart
   │        │  ├─ slider.dart
   │        │  ├─ snackbar.dart
   │        │  ├─ status_label.dart
   │        │  ├─ stepper.dart
   │        │  ├─ switch.dart
   │        │  ├─ table.dart
   │        │  ├─ tabs.dart
   │        │  ├─ text_field.dart
   │        │  ├─ time_picker.dart
   │        │  ├─ timeline.dart
   │        │  ├─ tooltip.dart
   │        │  └─ tree_view.dart
   │        ├─ composites/              # multi-widget combinations (reusable)
   │        │  ├─ page_container.dart   # title + breadcrumbs + content wrapper
   │        │  ├─ app_shell.dart        # 3-column layout (sidebar + header + main)
   │        │  ├─ dashboard_template.dart # dashboard-specific layout
   │        │  ├─ list_with_search.dart # searchable data lists
   │        │  ├─ settings_section.dart # grouped settings with headers
   │        │  ├─ data_table_with_filters.dart
   │        │  └─ form_section.dart
   │        ├─ layout/                  # structural layout components
   │        │  ├─ app_bar.dart
   │        │  ├─ bottom_navigation.dart
   │        │  ├─ box.dart
   │        │  ├─ container.dart
   │        │  ├─ drawer.dart
   │        │  ├─ grid.dart
   │        │  ├─ link.dart
   │        │  ├─ masonry.dart
   │        │  ├─ paper.dart
   │        │  ├─ speed_dial.dart
   │        │  ├─ stack.dart
   │        │  └─ transition.dart
   │        ├─ feedback/                # status & loading states
   │        │  ├─ backdrop.dart
   │        │  ├─ empty_state.dart
   │        │  ├─ loading_overlay.dart
   │        │  ├─ notification_banner.dart
   │        │  └─ spinner.dart
   │        ├─ extensions/              # complex single-purpose widgets
   │        │  ├─ accordion.dart
   │        │  ├─ calendar.dart
   │        │  ├─ fab.dart
   │        │  ├─ file_manager.dart
   │        │  ├─ media_gallery.dart
   │        │  ├─ minimal_table.dart
   │        │  ├─ rich_text_editor.dart
   │        │  └─ search_bar.dart
   │        ├─ utilities/               # pure helpers (no UI)
   │        │  ├─ responsive.dart       # responsive breakpoint utilities
   │        │  ├─ overlay_host.dart     # overlay management
   │        │  └─ theme_helpers.dart    # theme access utilities
   │        └─ internal/                # helpers not exported
   │           ├─ a11y.dart
   │           ├─ gestures.dart
   │           └─ token_adapters.dart   # tiny bridges to `tokens`
   ├─ core/
   │  ├─ pubspec.yaml
   │  └─ lib/
   │     ├─ core.dart                  # barrel export
   │     ├─ auth/
   │     │  ├─ auth_provider.dart      # abstract interface
   │     │  ├─ auth_models.dart        # User, Token, Permission models
   │     │  ├─ auth_interceptor.dart   # HTTP token injection
   │     │  └─ auth_storage.dart       # secure token storage
   │     ├─ http/
   │     │  ├─ api_client.dart         # configured Dio instance
   │     │  ├─ interceptors.dart       # logging, retry, error handling
   │     │  ├─ api_response.dart       # standardized response wrapper
   │     │  └─ pagination.dart         # common pagination models
   │     ├─ navigation/
   │     │  ├─ app_router.dart         # common routing patterns
   │     │  └─ deep_linking.dart       # URL handling
   │     ├─ state/
   │     │  ├─ app_state.dart          # user session, preferences
   │     │  └─ loading_state.dart      # global loading indicators
   │     └─ utils/
   │        ├─ result.dart             # Result/Failure/Async helper
   │        ├─ validators.dart         # form validation rules
   │        ├─ formatters.dart         # date, currency, text formatters
   │        └─ constants.dart          # API endpoints, timeouts
```

### 🏗️ Layout Architecture

**Two Layout Types:**

**1. Main App Layout (Authenticated Users):**
```
┌─────────────────────────────────────────────────┐
│                 App Layout                      │
├───────────┬─────────────────────────────────────┤
│           │              Header                 │
│           ├─────────────────────────────────────┤
│  Sidebar  │                                     │
│  (Fixed)  │         Main Content                │
│   280px   │      (Feature Pages)                │
│           │                                     │
└───────────┴─────────────────────────────────────┘
```

**2. Auth Layout (Login/Register Pages):**
```
┌─────────────────────────────────────────────────┐
│                                                 │
│                                                 │
│              ┌─────────────────┐                │
│              │                 │                │
│              │   Login Form    │                │
│              │                 │                │
│              │   [Branding]    │                │
│              │                 │                │
│              └─────────────────┘                │
│                                                 │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Page Content Structure:**
```
┌─────────────────────────────────────────────────┐
│  Breadcrumbs > Fleet > Motorcycles > Stocks    │
│                                      [Actions]  │
│  📍 Motorcycle Stocks                          │
├─────────────────────────────────────────────────┤
│                                                 │
│  🖥️  Desktop: Data Table                       │
│  📱  Mobile: List Cards                         │
│                                                 │
└─────────────────────────────────────────────────┘
```

### 🔄 Data Flow Pattern

**MVVM with Riverpod:**
```
Page (UI) ← Riverpod Providers ← Services ← API
    ↓              ↓               ↓
ConsumerWidget   @riverpod      Dio Client
  ref.watch()   AsyncNotifier   HTTP calls
```

### 📦 Package Dependencies

**App Dependencies:**
- `packages/tokens` → Design tokens
- `packages/ui` → Reusable UI components
- `packages/core` → Shared business logic (if reusable)
- `riverpod` → State management
- `go_router` → Navigation

### 🗺️ Routing Strategy

**Layout-Based Routing:**
```dart
// core/routes.dart
final appRouter = GoRouter(
  redirect: (context, state) {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    final isAuthPage = state.uri.path.startsWith('/auth');

    if (!isAuthenticated && !isAuthPage) {
      return '/auth/login';
    }
    if (isAuthenticated && isAuthPage) {
      return '/dashboard';
    }
    return null;
  },
  routes: [
    // Auth Routes (No Sidebar/Header)
    GoRoute(
      path: '/auth',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => AuthLayout(
            child: LoginPage(),
          ),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => AuthLayout(
            child: ForgotPasswordPage(),
          ),
        ),
      ],
    ),

    // App Routes (With Sidebar/Header)
    ShellRoute(
      builder: (context, state, child) => AppLayout(
        currentRoute: state.uri.path,
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/',
          redirect: (_, __) => '/dashboard',
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => DashboardPage(),
        ),
        GoRoute(
          path: '/motorcycles/stocks',
          builder: (context, state) => MotorcycleStockPage(),
        ),
      ],
    ),
  ],
);
```

### 📱 Layout Components

**Auth Layout:**
```dart
// features/shared/layouts/auth_layout.dart
class AuthLayout extends StatelessWidget {
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Branding/Logo
                FleetPortalLogo(),
                SizedBox(height: 48),

                // Auth Form
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Component Usage:**
```dart
// App uses packages/ui components
import 'package:ui/ui.dart';

// Main App Pages
Container(              // From packages/ui
  title: 'Motorcycle Stocks',
  child: MotorcycleCard(      // App-specific widget
    motorcycle: motorcycle,
  ),
)

// Auth Pages
Card(                       // From packages/ui
  child: LoginForm(),         // App-specific auth form
)
```

### 🎨 Theme Usage

**Basic Theme Setup:**
```dart
// lib/core/theme.dart
import 'package:flutter/material.dart';
import 'package:tokens/tokens.dart' as tokens;

class AppTheme {
  static ThemeData light() {
    return tokens.Theme.light;
  }

  static ThemeData dark() {
    return tokens.Theme.dark;
  }
}
```

**Application Setup:**
```dart
// lib/main.dart
MaterialApp(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  // ... other config
)
```

**Custom Color Themes:**
```dart
// Use specific color themes
MaterialApp(
  theme: tokens.Theme.lightTheme(ThemeColor.indigo),
  darkTheme: tokens.Theme.darkTheme(ThemeColor.indigo),
)
```
