# LX UIkit

TODO: description

## ✨ Project Structure
```
root/
├─ melos.yaml
├─ pubspec.yaml               # root (dev deps untuk tooling)
├─ README.md
├─ apps/
│  ├─ rental-fleet-portal/
│  │  ├─ pubspec.yaml
│  │  ├─ web/                 # untuk Flutter Web
│  │  │  └─ config.json       # runtime config (no secret, no-cache)
│  │  └─ lib/
│  │     ├─ main.dart
│  │     ├─ core/
│  │     │  ├─ app.dart             # MaterialApp
│  │     │  ├─ routes.dart          # Router
│  │     │  ├─ theme.dart           # ThemeSetting get from packages/tokens
│  │     │  ├─ di.dart              # provider singletons (Dio, repos)
│  │     │  ├─ http.dart            # Dio + interceptors
│  │     │  └─ app_config.dart      # loader config.json
│  │     └─ features/
│  │        ├─ dashboard/
│  │        │  ├─ dashboard_page.dart
│  │        │  └─ dashboard_vm.dart
│  │        └─ motorcycle-management/
│  │           ├─ motorcycle_stock_page.dart
│  │           ├─ motorcycle_stock_vm.dart
│  │           ├─ motorcycle_maintenance_page.dart
│  │           └─ motorcycle_maintenance_vm.dart
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
   │        ├─ composites/              # multi-widget combinations for internal tools
   │        │  ├─ header.dart           # logo + navigation + user menu
   │        │  ├─ sidebar.dart          # navigation + user profile
   │        │  ├─ main_content.dart     # content wrapper with proper spacing
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
   │        │  ├─ responsive.dart
   │        │  └─ overlay_host.dart
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
