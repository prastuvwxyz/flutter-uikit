import 'package:flutter/material.dart';
// Avoid network font fetching in tests by using the fontFamily name directly.
// This prevents google_fonts from attempting to download fonts during widget tests.

/// Typography tokens for the UI Kit.
///
/// Provides standardized text styles for different levels of the type scale
/// including display, headline, title, body, and label variants.
class UiTypographyTokens {
  /// Display typography (large)
  final TextStyle displayLarge;

  /// Display typography (medium)
  final TextStyle displayMedium;

  /// Display typography (small)
  final TextStyle displaySmall;

  /// Headline typography (large)
  final TextStyle headlineLarge;

  /// Headline typography (medium)
  final TextStyle headlineMedium;

  /// Headline typography (small)
  final TextStyle headlineSmall;

  /// Title typography (large)
  final TextStyle titleLarge;

  /// Title typography (medium)
  final TextStyle titleMedium;

  /// Title typography (small)
  final TextStyle titleSmall;

  /// Body typography (large)
  final TextStyle bodyLarge;

  /// Body typography (medium)
  final TextStyle bodyMedium;

  /// Body typography (small)
  final TextStyle bodySmall;

  /// Label typography (large)
  final TextStyle labelLarge;

  /// Label typography (medium)
  final TextStyle labelMedium;

  /// Label typography (small)
  final TextStyle labelSmall;

  /// Creates a typography token set with custom text styles
  const UiTypographyTokens({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// Creates the standard typography token set using Inter font family
  factory UiTypographyTokens.standard() {
    // Use a local TextStyle factory referencing the Inter font family name.
    // If Inter isn't bundled on the platform, Flutter will fall back to a default.
    TextStyle interFont({
      double? fontSize,
      FontWeight? fontWeight,
      double? letterSpacing,
      double? height,
    }) {
      return TextStyle(
        fontFamily: 'Inter',
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
      );
    }

    return UiTypographyTokens(
      // Display styles
      displayLarge: interFont(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: interFont(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.15,
      ),
      displaySmall: interFont(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles
      headlineLarge: interFont(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: interFont(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.28,
      ),
      headlineSmall: interFont(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles
      titleLarge: interFont(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: interFont(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: interFont(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.42,
      ),

      // Body styles
      bodyLarge: interFont(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: interFont(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.42,
      ),
      bodySmall: interFont(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles
      labelLarge: interFont(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.42,
      ),
      labelMedium: interFont(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: interFont(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Creates a lerped version between this and another typography token set
  UiTypographyTokens lerp(UiTypographyTokens other, double t) {
    return UiTypographyTokens(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
    );
  }

  /// Get a text style by semantic name
  TextStyle get(String name) {
    switch (name) {
      case 'display.lg':
        return displayLarge;
      case 'display.md':
        return displayMedium;
      case 'display.sm':
        return displaySmall;
      case 'headline.lg':
        return headlineLarge;
      case 'headline.md':
        return headlineMedium;
      case 'headline.sm':
        return headlineSmall;
      case 'title.lg':
        return titleLarge;
      case 'title.md':
        return titleMedium;
      case 'title.sm':
        return titleSmall;
      case 'body.lg':
        return bodyLarge;
      case 'body.md':
        return bodyMedium;
      case 'body.sm':
        return bodySmall;
      case 'label.lg':
        return labelLarge;
      case 'label.md':
        return labelMedium;
      case 'label.sm':
        return labelSmall;
      default:
        throw ArgumentError('Unknown text style: $name');
    }
  }
}
