import 'package:flutter/material.dart';
import '../core/color.dart';
import '../core/spacing.dart';
import '../core/radius.dart';

/// Default theme for LX UIkit applications.
///
/// Provides sensible defaults that work well for most applications.
/// Uses the primary blue color scheme as the default.
class DefaultTheme {
  /// Default light theme with standard spacing and radius
  static ThemeData get light => ThemeData(
    colorScheme: _lightColorScheme,
    useMaterial3: true,
    extensions: [
      Spacing.standard(),
      Radius.standard(),
    ],
  );

  /// Default dark theme with standard spacing and radius
  static ThemeData get dark => ThemeData(
    colorScheme: _darkColorScheme,
    useMaterial3: true,
    extensions: [
      Spacing.standard(),
      Radius.standard(),
    ],
  );

  /// Default light color scheme using primary blue
  static ColorScheme get _lightColorScheme => ColorScheme.light(
    primary: ColorPalettes.primary.shade500,
    onPrimary: Colors.white,
    primaryContainer: ColorPalettes.primary.shade100,
    onPrimaryContainer: ColorPalettes.primary.shade900,

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
    inversePrimary: ColorPalettes.primary.shade200,

    surfaceTint: ColorPalettes.primary.shade500,
    scrim: Colors.black,
    shadow: Colors.black,
  );

  /// Default dark color scheme using primary blue with better contrast levels
  static ColorScheme get _darkColorScheme => ColorScheme.dark(
    primary: ColorPalettes.primary.shade300,
    onPrimary: ColorPalettes.primary.shade800,
    primaryContainer: ColorPalettes.primary.shade800,
    onPrimaryContainer: ColorPalettes.primary.shade200,

    secondary: ColorPalettes.secondary.shade300,
    onSecondary: ColorPalettes.secondary.shade800,
    secondaryContainer: ColorPalettes.secondary.shade800,
    onSecondaryContainer: ColorPalettes.secondary.shade200,

    tertiary: ColorPalettes.tertiary.shade300,
    onTertiary: ColorPalettes.tertiary.shade800,
    tertiaryContainer: ColorPalettes.tertiary.shade800,
    onTertiaryContainer: ColorPalettes.tertiary.shade200,

    error: ColorPalettes.error.light,
    onError: ColorPalettes.error.dark,
    errorContainer: ColorPalettes.error.main,
    onErrorContainer: ColorPalettes.error.light,

    surface: const Color(0xFF121212),
    onSurface: ColorPalettes.neutral.shade100,
    surfaceContainerHighest: const Color(0xFF1E1E1E),
    onSurfaceVariant: ColorPalettes.neutral.shade300,

    outline: ColorPalettes.neutral.shade600,
    outlineVariant: ColorPalettes.neutral.shade700,

    inverseSurface: ColorPalettes.neutral.shade100,
    onInverseSurface: ColorPalettes.neutral.shade800,
    inversePrimary: ColorPalettes.primary.shade500,

    surfaceTint: ColorPalettes.primary.shade300,
    scrim: Colors.black,
    shadow: Colors.black,
  );

  /// Get light color scheme using specified color
  static ColorScheme lightWith({required MaterialPalette primaryColor}) {
    return _lightColorScheme.copyWith(
      primary: primaryColor.shade500,
      primaryContainer: primaryColor.shade100,
      onPrimaryContainer: primaryColor.shade900,
      inversePrimary: primaryColor.shade200,
      surfaceTint: primaryColor.shade500,
    );
  }

  /// Get dark color scheme using specified color
  static ColorScheme darkWith({required MaterialPalette primaryColor}) {
    return _darkColorScheme.copyWith(
      primary: primaryColor.shade200,
      onPrimary: primaryColor.shade900,
      primaryContainer: primaryColor.shade700,
      onPrimaryContainer: primaryColor.shade100,
      inversePrimary: primaryColor.shade500,
      surfaceTint: primaryColor.shade200,
    );
  }
}