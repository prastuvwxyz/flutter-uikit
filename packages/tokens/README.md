# LX UIkit Tokens

Core design tokens package providing colors, spacing, typography, themes, and other design primitives for consistent UI development across the LX UIkit ecosystem.

## 🚀 Quick Start

### Default Theme (Recommended)

```dart
import 'package:tokens/tokens.dart';

MaterialApp(
  title: 'My App',
  theme: AppTheme.light,           // Default light theme
  darkTheme: AppTheme.dark,        // Default dark theme
  home: MyHomePage(),
)
```

### Custom Color Theme

```dart
MaterialApp(
  title: 'My App',
  theme: AppTheme.lightTheme(ThemeColor.indigo),
  darkTheme: AppTheme.darkTheme(ThemeColor.indigo),
  home: MyHomePage(),
)
```

### Using Individual Tokens

```dart
// Typography
Text('Hello World', style: Typography.bodyLarge);

// Colors
Container(color: ColorPalettes.primary[500]);

// Spacing (requires theme setup)
Padding(padding: EdgeInsets.all(Spacing.of(context).md));

// Elevation shadows
Container(decoration: BoxDecoration(boxShadow: Elevation.md));
```

## 🎨 Theme System

### Available Theme Colors

The design system includes **12 beautiful color themes**:

- **Blue** - Primary blue (default)
- **Indigo** - Deep indigo
- **Cyan** - Teal cyan
- **Teal** - Ocean teal
- **Red** - Bold red
- **Purple** - Royal purple
- **Pink** - Vibrant pink
- **Deep Purple** - Rich deep purple
- **Material Blue** - Material design blue
- **Light Blue** - Sky light blue
- **Green** - Natural green
- **Orange** - Energetic orange

### Theme Usage Patterns

```dart
// 1. Default theme (easiest)
theme: AppTheme.light,
darkTheme: AppTheme.dark,

// 2. Specific color theme
theme: AppTheme.lightTheme(ThemeColor.red),
darkTheme: AppTheme.darkTheme(ThemeColor.red),

// 3. Theme pair approach
final themes = AppTheme.themeFor(ThemeColor.green);
theme: themes.light,
darkTheme: themes.dark,

// 4. Dynamic theme based on system
final themes = AppTheme.themeFor(ThemeColor.indigo);
theme: themes.forSystem(context),

// 5. All available themes (for theme switcher)
final allThemes = AppTheme.availableColors;
```

### Runtime Theme Switching

```dart
class ThemeSwitcher extends StatefulWidget {
  @override
  _ThemeSwitcherState createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  ThemeColor selectedColor = ThemeColor.blue;

  @override
  Widget build(BuildContext context) {
    final themes = AppTheme.themeFor(selectedColor);

    return MaterialApp(
      theme: themes.light,
      darkTheme: themes.dark,
      home: Scaffold(
        body: DropdownButton<ThemeColor>(
          value: selectedColor,
          items: AppTheme.availableColors.map((color) {
            return DropdownMenuItem(
              value: color,
              child: Text(color.displayName),
            );
          }).toList(),
          onChanged: (color) => setState(() => selectedColor = color!),
        ),
      ),
    );
  }
}
```

## 📋 Token Categories

### Colors (`ColorPalettes`)
- **Material palettes**: Complete 50-900 shade ranges for all theme colors
- **Semantic colors**: `success`, `warning`, `error`, `info` (light/main/dark)
- **Usage**: `ColorPalettes.primary[500]` or `ColorPalettes.success.main`

### Typography (`Typography`)
- **Styles**: `displayLarge`, `headlineMedium`, `bodyLarge`, `labelSmall`, etc.
- **Font**: Inter family with proper weights and spacing
- **Usage**: `Typography.bodyLarge`

### Spacing (`Spacing`)
- **Scale**: `xs`(4px) to `xxxxxxl`(64px) based on 4px grid
- **Theme extension**: Use `Spacing.of(context).md`
- **Variants**: `standard()`, `compact()`, `comfortable()`

### Radius (`Radius`)
- **Scale**: `none`(0) to `full`(9999px)
- **Theme extension**: Use `Radius.of(context).lg`

### Other Tokens
- **Elevation**: Box shadow presets (`xs` to `xxl`)
- **Motion**: Duration and curve constants
- **Breakpoint**: Responsive breakpoints (`xs` to `xxl`)
- **Opacity**: Standard opacity values (hover, focus, disabled, etc.)
- **ZIndex**: Layering constants (modal, dropdown, toast)
- **Border**: Width and style constants
- **Icon**: Size constants (`xs` to `xxxl`)
- **State**: State overlay alpha values

## 🏗️ Architecture

### New Theme System (Recommended)
- **`AppTheme`** - Main theme API, easy to use
- **`ThemeRegistry`** - Central registry of all themes
- **`DefaultTheme`** - Sensible defaults for quick setup
- **`ThemeColor`** - Enum of available colors

### Legacy Theme System (Backwards Compatible)
- Individual theme classes (`IndigoLightTheme`, etc.)
- `ThemeBuilder` for custom combinations
- `LightScheme` and `DarkScheme` base schemes

## 🔄 Migration Guide

### From Legacy to New System

**Before:**
```dart
import 'package:tokens/tokens.dart';

MaterialApp(
  theme: ThemeData(
    colorScheme: LightScheme.colorScheme,
    extensions: [Spacing.standard(), Radius.standard()],
  ),
)
```

**After:**
```dart
import 'package:tokens/tokens.dart';

MaterialApp(
  theme: AppTheme.light,  // Much simpler!
)
```

## 💡 Key Principles

- **No prefixes**: Use `LXTheme` not `UiTheme`, `Spacing` not `UiSpacing`
- **Default first**: Works great out of the box with sensible defaults
- **Easy customization**: Simple API for color themes and custom palettes
- **Material 3 ready**: All themes follow Material 3 guidelines
- **Runtime switching**: Easy theme switching for user preferences
- **Consistent naming**: Follow established naming conventions

## 📦 Import Strategy

**Single import for everything:**
```dart
import 'package:tokens/tokens.dart';
```

This gives you access to:
- `AppTheme` - Main theme system
- `ColorPalettes` - All color palettes
- `Typography` - Text styles
- `Spacing` - Spacing scale (needs context)
- `Radius` - Border radius scale (needs context)
- All other design tokens

## 🎯 Best Practices

1. **Start with defaults**: Use `AppTheme.light` and `AppTheme.dark`
2. **Choose theme color**: Pick one of the 12 available colors for your brand
3. **Use theme extensions**: Access spacing and radius via `Spacing.of(context)`
4. **Follow Material 3**: All themes are Material 3 compliant
5. **Test dark mode**: Always test both light and dark variants
6. **Consider runtime switching**: Allow users to change themes

## 🤖 AI Context

This is a comprehensive design tokens package that:
- Provides 12 beautiful, ready-to-use color themes
- Follows Material 3 design guidelines
- Offers both simple defaults and advanced customization
- Supports runtime theme switching
- Maintains backwards compatibility
- Optimized for developer experience and AI understanding