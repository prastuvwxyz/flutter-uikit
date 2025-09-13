import 'package:flutter/material.dart';
import '../core/color.dart';
import '../core/spacing.dart';
import '../core/radius.dart';

/// Available theme colors in the design system
enum ThemeColor {
  blue('Blue', 'Primary blue theme'),
  indigo('Indigo', 'Deep indigo theme'),
  cyan('Cyan', 'Teal cyan theme'),
  teal('Teal', 'Ocean teal theme'),
  red('Red', 'Bold red theme'),
  purple('Purple', 'Royal purple theme'),
  pink('Pink', 'Vibrant pink theme'),
  deepPurple('Deep Purple', 'Rich deep purple theme'),
  materialBlue('Material Blue', 'Material design blue theme'),
  lightBlue('Light Blue', 'Sky light blue theme'),
  green('Green', 'Natural green theme'),
  orange('Orange', 'Energetic orange theme');

  const ThemeColor(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Central registry for all available themes in the LX UIkit.
///
/// Provides easy access to all theme variants and allows for
/// dynamic theme switching at runtime.
class ThemeRegistry {
  static const ThemeRegistry _instance = ThemeRegistry._internal();
  factory ThemeRegistry() => _instance;
  const ThemeRegistry._internal();

  /// Get all available theme colors
  static List<ThemeColor> get availableColors => ThemeColor.values;

  /// Get light theme for specified color
  static ThemeData lightTheme(ThemeColor color) {
    final palette = paletteFor(color);
    return _buildLightTheme(palette);
  }

  /// Get dark theme for specified color
  static ThemeData darkTheme(ThemeColor color) {
    final palette = paletteFor(color);
    return _buildDarkTheme(palette);
  }

  /// Get theme pair (light and dark) for specified color
  static ThemePair themeFor(ThemeColor color) {
    return ThemePair(
      light: lightTheme(color),
      dark: darkTheme(color),
    );
  }

  /// Get all available themes as a map
  static Map<ThemeColor, ThemePair> get allThemes {
    return Map.fromEntries(
      ThemeColor.values.map(
        (color) => MapEntry(color, themeFor(color)),
      ),
    );
  }

  /// Get material palette for theme color
  static MaterialPalette paletteFor(ThemeColor color) {
    switch (color) {
      case ThemeColor.blue:
        return ColorPalettes.primary;
      case ThemeColor.indigo:
        return ColorPalettes.indigo;
      case ThemeColor.cyan:
        return ColorPalettes.cyan;
      case ThemeColor.teal:
        return ColorPalettes.teal;
      case ThemeColor.red:
        return ColorPalettes.red;
      case ThemeColor.purple:
        return ColorPalettes.purple;
      case ThemeColor.pink:
        return ColorPalettes.pink;
      case ThemeColor.deepPurple:
        return ColorPalettes.deepPurple;
      case ThemeColor.materialBlue:
        return ColorPalettes.blue;
      case ThemeColor.lightBlue:
        return ColorPalettes.lightBlue;
      case ThemeColor.green:
        return ColorPalettes.green;
      case ThemeColor.orange:
        return ColorPalettes.orange;
    }
  }

  /// Build light theme with specified primary palette
  static ThemeData _buildLightTheme(MaterialPalette primaryPalette) {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: primaryPalette.shade500,
        onPrimary: Colors.white,
        primaryContainer: primaryPalette.shade100,
        onPrimaryContainer: primaryPalette.shade900,

        secondary: ColorPalettes.secondary.shade500,
        onSecondary: Colors.white,
        secondaryContainer: ColorPalettes.secondary.shade100,
        onSecondaryContainer: ColorPalettes.secondary.shade900,

        tertiary: ColorPalettes.tertiary.shade500,
        onTertiary: Colors.white,
        tertiaryContainer: ColorPalettes.tertiary.shade100,
        onTertiaryContainer: ColorPalettes.tertiary.shade900,

        error: ColorPalettes.error.main,
        onError: Colors.white,
        errorContainer: ColorPalettes.error.light,
        onErrorContainer: ColorPalettes.error.dark,

        surface: ColorPalettes.neutral.shade50,
        onSurface: ColorPalettes.neutral.shade900,
        surfaceContainerHighest: ColorPalettes.neutral.shade200,
        onSurfaceVariant: ColorPalettes.neutral.shade700,

        outline: ColorPalettes.neutral.shade300,
        outlineVariant: ColorPalettes.neutral.shade200,

        inverseSurface: ColorPalettes.neutral.shade800,
        onInverseSurface: ColorPalettes.neutral.shade50,
        inversePrimary: primaryPalette.shade200,

        surfaceTint: primaryPalette.shade500,
        scrim: Colors.black,
        shadow: Colors.black,
      ),
      useMaterial3: true,
      extensions: [
        Spacing.standard(),
        Radius.standard(),
      ],
    );
  }

  /// Build dark theme with specified primary palette
  static ThemeData _buildDarkTheme(MaterialPalette primaryPalette) {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: primaryPalette.shade200,
        onPrimary: primaryPalette.shade900,
        primaryContainer: primaryPalette.shade700,
        onPrimaryContainer: primaryPalette.shade100,

        secondary: ColorPalettes.secondary.shade200,
        onSecondary: ColorPalettes.secondary.shade900,
        secondaryContainer: ColorPalettes.secondary.shade700,
        onSecondaryContainer: ColorPalettes.secondary.shade100,

        tertiary: ColorPalettes.tertiary.shade200,
        onTertiary: ColorPalettes.tertiary.shade900,
        tertiaryContainer: ColorPalettes.tertiary.shade700,
        onTertiaryContainer: ColorPalettes.tertiary.shade100,

        error: ColorPalettes.error.light,
        onError: ColorPalettes.error.dark,
        errorContainer: ColorPalettes.error.main,
        onErrorContainer: ColorPalettes.error.light,

        surface: ColorPalettes.neutral.shade900,
        onSurface: ColorPalettes.neutral.shade50,
        surfaceContainerHighest: ColorPalettes.neutral.shade800,
        onSurfaceVariant: ColorPalettes.neutral.shade400,

        outline: ColorPalettes.neutral.shade700,
        outlineVariant: ColorPalettes.neutral.shade800,

        inverseSurface: ColorPalettes.neutral.shade50,
        onInverseSurface: ColorPalettes.neutral.shade900,
        inversePrimary: primaryPalette.shade500,

        surfaceTint: primaryPalette.shade200,
        scrim: Colors.black,
        shadow: Colors.black,
      ),
      useMaterial3: true,
      extensions: [
        Spacing.standard(),
        Radius.standard(),
      ],
    );
  }
}

/// A pair of light and dark themes
class ThemePair {
  final ThemeData light;
  final ThemeData dark;

  const ThemePair({
    required this.light,
    required this.dark,
  });

  /// Get theme based on brightness
  ThemeData forBrightness(Brightness brightness) {
    return brightness == Brightness.light ? light : dark;
  }
}