import 'package:flutter/material.dart';

/// Color tokens for the UI Kit, following Material 3 color system
/// with semantic variants for different states and themes.
class UiColorTokens {
  /// Primary color palette (50-900)
  final ColorPalette primary;
  
  /// Secondary color palette (50-900)
  final ColorPalette secondary;
  
  /// Tertiary color palette (50-900)
  final ColorPalette tertiary;
  
  /// Neutral color palette (50-900)
  final ColorPalette neutral;
  
  /// Success color and variants
  final ColorSwatch success;
  
  /// Warning color and variants
  final ColorSwatch warning;
  
  /// Error color and variants
  final ColorSwatch error;
  
  /// Info color and variants
  final ColorSwatch info;
  
  /// Whether this token set represents dark mode
  final bool isDark;
  
  /// Whether this token set represents high contrast mode
  final bool isHighContrast;

  /// Creates a custom color token set
  const UiColorTokens({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.neutral,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    this.isDark = false,
    this.isHighContrast = false,
  });

  /// Creates the default Material 3 color token set
  const UiColorTokens.material3({
    bool isDark = false,
    bool isHighContrast = false,
  }) : primary = const ColorPalette(
          shade50: Color(0xFFE6F4FF),
          shade100: Color(0xFFCCE9FF),
          shade200: Color(0xFF99D3FF),
          shade300: Color(0xFF66BDFF),
          shade400: Color(0xFF33A7FF),
          shade500: Color(0xFF0091FF),
          shade600: Color(0xFF0074CC),
          shade700: Color(0xFF005799),
          shade800: Color(0xFF003A66),
          shade900: Color(0xFF001D33),
        ),
        secondary = const ColorPalette(
          shade50: Color(0xFFF3F0FF),
          shade100: Color(0xFFE6E0FF),
          shade200: Color(0xFFCDC1FF),
          shade300: Color(0xFFB4A3FF),
          shade400: Color(0xFF9B84FF),
          shade500: Color(0xFF8265FF),
          shade600: Color(0xFF6851CC),
          shade700: Color(0xFF4E3D99),
          shade800: Color(0xFF342866),
          shade900: Color(0xFF1A1433),
        ),
        tertiary = const ColorPalette(
          shade50: Color(0xFFFFECF3),
          shade100: Color(0xFFFFDAE6),
          shade200: Color(0xFFFFB5CD),
          shade300: Color(0xFFFF8FB4),
          shade400: Color(0xFFFF6A9B),
          shade500: Color(0xFFFF4582),
          shade600: Color(0xFFCC3768),
          shade700: Color(0xFF99294E),
          shade800: Color(0xFF661C34),
          shade900: Color(0xFF330E1A),
        ),
        neutral = const ColorPalette(
          shade50: Color(0xFFF8F9FA),
          shade100: Color(0xFFF1F3F5),
          shade200: Color(0xFFE9ECEF),
          shade300: Color(0xFFDEE2E6),
          shade400: Color(0xFFCED4DA),
          shade500: Color(0xFFADB5BD),
          shade600: Color(0xFF868E96),
          shade700: Color(0xFF495057),
          shade800: Color(0xFF343A40),
          shade900: Color(0xFF212529),
        ),
        success = const ColorSwatch(0xFF28A745, {
          50: Color(0xFFE9F7EF),
          100: Color(0xFFD4EFE0),
          500: Color(0xFF28A745),
          600: Color(0xFF208537),
        }),
        warning = const ColorSwatch(0xFFFFC107, {
          50: Color(0xFFFFF8E6),
          100: Color(0xFFFFEFCC),
          500: Color(0xFFFFC107),
          600: Color(0xFFCC9A06),
        }),
        error = const ColorSwatch(0xFFDC3545, {
          50: Color(0xFFFBEAEC),
          100: Color(0xFFF7D5D9),
          500: Color(0xFFDC3545),
          600: Color(0xFFB02A37),
        }),
        info = const ColorSwatch(0xFF17A2B8, {
          50: Color(0xFFE8F6F8),
          100: Color(0xFFD1EEF1),
          500: Color(0xFF17A2B8),
          600: Color(0xFF128293),
        }),
        isDark = isDark,
        isHighContrast = isHighContrast;
  
  /// Creates a lerped version between this and another color token set
  UiColorTokens lerp(UiColorTokens other, double t) {
    return UiColorTokens(
      primary: primary.lerp(other.primary, t),
      secondary: secondary.lerp(other.secondary, t),
      tertiary: tertiary.lerp(other.tertiary, t),
      neutral: neutral.lerp(other.neutral, t),
      success: _lerpSwatch(success, other.success, t),
      warning: _lerpSwatch(warning, other.warning, t),
      error: _lerpSwatch(error, other.error, t),
      info: _lerpSwatch(info, other.info, t),
      isDark: t < 0.5 ? isDark : other.isDark,
      isHighContrast: t < 0.5 ? isHighContrast : other.isHighContrast,
    );
  }
  
  /// Helper method to lerp ColorSwatch objects
  ColorSwatch _lerpSwatch(ColorSwatch a, ColorSwatch b, double t) {
    return ColorSwatch(Color.lerp(Color(a.value), Color(b.value), t)!.value, {
      50: Color.lerp(a[50], b[50], t)!,
      100: Color.lerp(a[100], b[100], t)!,
      500: Color.lerp(a[500], b[500], t)!,
      600: Color.lerp(a[600], b[600], t)!,
    });
  }
  
  /// Dark mode version of these color tokens
  UiColorTokens get dark {
    if (isDark) return this;
    
    return UiColorTokens(
      primary: primary.dark,
      secondary: secondary.dark,
      tertiary: tertiary.dark,
      neutral: neutral.dark,
      success: success,
      warning: warning,
      error: error,
      info: info,
      isDark: true,
      isHighContrast: isHighContrast,
    );
  }
  
  /// High contrast version of these color tokens
  UiColorTokens get highContrast {
    if (isHighContrast) return this;
    
    // Increase contrast by making lights lighter and darks darker
    return UiColorTokens(
      primary: primary.highContrast,
      secondary: secondary.highContrast,
      tertiary: tertiary.highContrast,
      neutral: neutral.highContrast,
      success: _increaseSwatchContrast(success),
      warning: _increaseSwatchContrast(warning),
      error: _increaseSwatchContrast(error),
      info: _increaseSwatchContrast(info),
      isDark: isDark,
      isHighContrast: true,
    );
  }
  
  /// Helper to increase contrast of a swatch
  ColorSwatch _increaseSwatchContrast(ColorSwatch swatch) {
    return ColorSwatch(swatch.value, {
      50: _lightenColor(swatch[50]!, 0.1),
      100: _lightenColor(swatch[100]!, 0.05),
      500: swatch[500]!,
      600: _darkenColor(swatch[600]!, 0.05),
    });
  }
  
  /// Helper to lighten a color
  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
  
  /// Helper to darken a color
  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

/// Extension of the standard color palette with additional features
class ColorPalette {
  final Color shade50;
  final Color shade100;
  final Color shade200;
  final Color shade300;
  final Color shade400;
  final Color shade500;
  final Color shade600;
  final Color shade700;
  final Color shade800;
  final Color shade900;
  
  const ColorPalette({
    required this.shade50,
    required this.shade100,
    required this.shade200,
    required this.shade300,
    required this.shade400,
    required this.shade500,
    required this.shade600,
    required this.shade700,
    required this.shade800,
    required this.shade900,
  });
       
  /// Get a specific shade
  Color operator [](int shade) {
    switch (shade) {
      case 50: return shade50;
      case 100: return shade100;
      case 200: return shade200;
      case 300: return shade300;
      case 400: return shade400;
      case 500: return shade500;
      case 600: return shade600;
      case 700: return shade700;
      case 800: return shade800;
      case 900: return shade900;
      default: throw ArgumentError('Invalid shade: $shade');
    }
  }
  
  /// Lerp between this and another color palette
  ColorPalette lerp(ColorPalette other, double t) {
    return ColorPalette(
      shade50: Color.lerp(shade50, other.shade50, t)!,
      shade100: Color.lerp(shade100, other.shade100, t)!,
      shade200: Color.lerp(shade200, other.shade200, t)!,
      shade300: Color.lerp(shade300, other.shade300, t)!,
      shade400: Color.lerp(shade400, other.shade400, t)!,
      shade500: Color.lerp(shade500, other.shade500, t)!,
      shade600: Color.lerp(shade600, other.shade600, t)!,
      shade700: Color.lerp(shade700, other.shade700, t)!,
      shade800: Color.lerp(shade800, other.shade800, t)!,
      shade900: Color.lerp(shade900, other.shade900, t)!,
    );
  }
  
  /// Dark mode version (inverts the color scheme)
  ColorPalette get dark {
    return ColorPalette(
      shade50: shade900,
      shade100: shade800,
      shade200: shade700,
      shade300: shade600,
      shade400: shade500,
      shade500: shade400,
      shade600: shade300,
      shade700: shade200,
      shade800: shade100,
      shade900: shade50,
    );
  }
  
  /// High contrast version (increases contrast)
  ColorPalette get highContrast {
    return ColorPalette(
      shade50: _lightenColor(shade50, 0.1),
      shade100: _lightenColor(shade100, 0.05),
      shade200: shade200,
      shade300: shade300,
      shade400: shade400,
      shade500: shade500,
      shade600: shade600,
      shade700: shade700,
      shade800: _darkenColor(shade800, 0.05),
      shade900: _darkenColor(shade900, 0.1),
    );
  }
  
  /// Helper to lighten a color
  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
  
  /// Helper to darken a color
  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}
