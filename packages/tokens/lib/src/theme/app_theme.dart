import 'package:flutter/material.dart';
import '../core/color.dart';
import 'default_theme.dart';
import 'theme_registry.dart';

/// Main theme class for LX UIkit applications.
///
/// Provides a simple, consistent API for theme management with
/// sensible defaults and easy customization options.
///
/// ## Quick Start
///
/// ```dart
/// // Use default theme
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// )
///
/// // Use specific color theme
/// MaterialApp(
///   theme: AppTheme.lightTheme(ThemeColor.indigo),
///   darkTheme: AppTheme.darkTheme(ThemeColor.indigo),
/// )
/// ```
class AppTheme {
  /// Default light theme using primary blue color
  static ThemeData get light => DefaultTheme.light;

  /// Default dark theme using primary blue color
  static ThemeData get dark => DefaultTheme.dark;

  /// Get light theme with specified color
  ///
  /// ```dart
  /// theme: AppTheme.lightTheme(ThemeColor.red)
  /// ```
  static ThemeData lightTheme(ThemeColor color) => ThemeRegistry.lightTheme(color);

  /// Get dark theme with specified color
  ///
  /// ```dart
  /// darkTheme: AppTheme.darkTheme(ThemeColor.red)
  /// ```
  static ThemeData darkTheme(ThemeColor color) => ThemeRegistry.darkTheme(color);

  /// Get theme pair (light and dark) for specified color
  ///
  /// ```dart
  /// final themes = AppTheme.themeFor(ThemeColor.green);
  /// theme: themes.light,
  /// darkTheme: themes.dark,
  /// ```
  static ThemePair themeFor(ThemeColor color) => ThemeRegistry.themeFor(color);

  /// Get all available theme colors
  static List<ThemeColor> get availableColors => ThemeRegistry.availableColors;

  /// Create custom theme with specified primary color palette
  ///
  /// ```dart
  /// theme: AppTheme.custom(
  ///   primaryPalette: ColorPalettes.indigo,
  ///   brightness: Brightness.light,
  /// )
  /// ```
  static ThemeData custom({
    required MaterialPalette primaryPalette,
    required Brightness brightness,
  }) {
    return brightness == Brightness.light
        ? DefaultTheme.light.copyWith(
            colorScheme: DefaultTheme.lightWith(primaryColor: primaryPalette),
          )
        : DefaultTheme.dark.copyWith(
            colorScheme: DefaultTheme.darkWith(primaryColor: primaryPalette),
          );
  }
}

/// Extension on [ThemePair] for convenience methods
extension ThemePairExtension on ThemePair {
  /// Get theme based on system brightness
  ThemeData forSystem(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return forBrightness(brightness);
  }
}