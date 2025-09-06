# ui_components — Minimal components library

## MinimalTextareaAutosize

Basic usage:

```dart
import 'package:ui_components/ui_components.dart';

MinimalTextareaAutosize(
  placeholder: 'Enter your message',
  maxLength: 500,
  showCharacterCount: true,
  minHeight: 48,
  maxHeight: 200,
)
```

This component is exported from `package:ui_components/ui_components.dart`.
# UI Components Package

A set of reusable UI components for the Flutter UI Kit that follow Material Design 3 principles.

## Components

### MinimalButton

A versatile button component with multiple variants and sizes.

#### Features

- Four visual variants: primary, secondary, danger, and ghost
- Three size options: small, medium, and large
- Support for loading state
- Support for leading and trailing icons
- Full width option
- Accessibility compliant with proper focus handling
- Platform-specific haptic feedback
- RTL support

#### Usage

```dart
import 'package:ui_components/ui_components.dart';

// Basic usage
MinimalButton(
  onPressed: () {
    // Handle button press
  },
  child: Text('Button Text'),
)

// With variant and size
MinimalButton(
  variant: ButtonVariant.secondary,
  size: ButtonSize.lg,
  onPressed: () {},
  child: Text('Large Secondary Button'),
)

// With icons
MinimalButton(
  variant: ButtonVariant.primary,
  onPressed: () {},
  leading: Icon(Icons.add),
  child: Text('Add Item'),
)

// Loading state
MinimalButton(
  onPressed: () {},
  isLoading: true,
  child: Text('Loading...'),
)

// Disabled state
const MinimalButton(
  onPressed: null, // null makes the button disabled
  child: Text('Disabled Button'),
)

// Full width
MinimalButton(
  onPressed: () {},
  fullWidth: true,
  child: Text('Full Width Button'),
)
```

#### Props

| Name       | Type           | Default            | Description                         |
|------------|----------------|-------------------|-------------------------------------|
| variant    | ButtonVariant  | primary           | Visual style (primary, secondary, danger, ghost) |
| size       | ButtonSize     | md                | Size variant (sm, md, lg) |
| leading    | Widget?        | null              | Optional icon before label |
| trailing   | Widget?        | null              | Optional icon after label |
| child      | Widget?        | null              | Button content (text or custom widget) |
| onPressed  | VoidCallback?  | null              | Callback when pressed (null = disabled) |
| isLoading  | bool           | false             | Shows spinner, disables interaction |
| fullWidth  | bool           | false             | Expand to container width |

#### Design Tokens Used

- **Color**: primary, onPrimary, secondary, onSecondary, error, onError, outline, surface
- **Typography**: label.sm, label.md, label.lg
- **Spacing**: sm, md, lg
- **Radius**: md

#### Accessibility

- Proper focus management and keyboard navigation
- 48dp minimum touch target maintained across sizes
- Supports RTL layouts
- Semantic role: button
- Keyboard support: Enter/Space

### MinimalText

`MinimalText` is a semantic typography widget exposing `TextVariant` aliases like `TextVariant.h1`, `TextVariant.body1`, `TextVariant.caption`, etc.

Example:

```dart
import 'package:ui_components/ui_components.dart';

MinimalText('Main Heading', variant: TextVariant.h1)
MinimalText('Body copy', variant: TextVariant.body1, color: Colors.blue)
```

It provides theming integration, accessibility semantics and common style overrides.
