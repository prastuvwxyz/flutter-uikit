# UI Tokens Package

This package provides a comprehensive design token system for Flutter applications. Design tokens are the visual design atoms of the design system — specifically, they are named entities that store visual design attributes such as colors, typography, spacing, and more.

## Features

- **Color tokens**: Primary, secondary, tertiary and semantic color palettes with light/dark/high-contrast modes
- **Typography tokens**: Consistent text styles for all typographic levels
- **Spacing tokens**: Standardized 4px-grid based spacing system
- **Border radius tokens**: Consistent corner rounding
- **Elevation tokens**: Shadow and depth system
- **Motion tokens**: Animation durations and curves

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  ui_tokens:
    path: ./packages/ui_tokens
```

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create UI tokens
    const tokens = UiTokens();
    
    return MaterialApp(
      theme: ThemeData(
        // Add tokens to your theme
        extensions: [tokens],
        // Use tokens to configure theme colors
        colorScheme: ColorScheme(
          primary: tokens.colorTokens.primary[500],
          secondary: tokens.colorTokens.secondary[500],
          // ... other color scheme properties
        ),
      ),
      home: MyHomePage(),
    );
  }
}
```

### Accessing Tokens in Widgets

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get tokens from the current theme
    final tokens = UiTokens.of(context);
    
    return Container(
      // Use spacing tokens
      padding: EdgeInsets.all(tokens.spacingTokens.md),
      // Use radius tokens
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
        // Use color tokens
        color: tokens.colorTokens.primary[100],
        // Use elevation tokens
        boxShadow: tokens.elevationTokens.getShadow(2),
      ),
      child: Text(
        'Hello World',
        // Use typography tokens
        style: tokens.typographyTokens.bodyLarge,
      ),
    );
  }
}
```

### Dark Mode & High Contrast

```dart
// For dark mode
final darkTokens = tokens.dark;

// For high contrast
final highContrastTokens = tokens.highContrast;

// For dark mode + high contrast
final darkHighContrastTokens = tokens.dark.highContrast;
```

### Custom Themes

```dart
// Create custom tokens
final customTokens = UiTokens(
  colorTokens: UiColorTokens(
    primary: ColorPalette(/* custom primary palette */),
    secondary: ColorPalette(/* custom secondary palette */),
    // ... other color properties
  ),
  spacingTokens: UiSpacingTokens.compact(), // Use the compact spacing preset
  // ... other token properties
);
```

## Examples

See the example app for full demonstrations:
- `example/lib/tokens/token_showcase.dart` - Showcase of all available tokens
- `example/lib/tokens/custom_theme.dart` - How to create and use custom themes with tokens
