import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// Border radius tokens for the UI Kit.
///
/// Provides standardized border radius values for consistent rounding
/// of UI elements throughout the application.
class UiRadiusTokens {
  /// No rounding (0px)
  final double none;
  
  /// Small radius (4px)
  final double sm;
  
  /// Medium radius (8px)
  final double md;
  
  /// Large radius (12px)
  final double lg;
  
  /// Extra large radius (16px)
  final double xl;
  
  /// Double extra large radius (20px)
  final double xxl;
  
  /// Triple extra large radius (24px)
  final double xxxl;
  
  /// Full/circular radius (9999px)
  final double full;
  
  /// Creates a radius token set with custom values
  const UiRadiusTokens({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.full,
  });
  
  /// Creates the standard radius token set
  const UiRadiusTokens.standard() : 
    none = 0.0,
    sm = 4.0,
    md = 8.0,
    lg = 12.0,
    xl = 16.0,
    xxl = 20.0,
    xxxl = 24.0,
    full = 9999.0;
  
  /// Creates a more rounded radius token set
  factory UiRadiusTokens.rounded() {
    return const UiRadiusTokens(
      none: 0.0,
      sm: 8.0,    // Increased
      md: 12.0,   // Increased
      lg: 16.0,   // Increased
      xl: 24.0,   // Increased
      xxl: 32.0,  // Increased
      xxxl: 40.0, // Increased
      full: 9999.0,
    );
  }
  
  /// Creates a subtle radius token set
  factory UiRadiusTokens.subtle() {
    return const UiRadiusTokens(
      none: 0.0,
      sm: 2.0,    // Decreased
      md: 4.0,    // Decreased
      lg: 8.0,    // Decreased
      xl: 12.0,   // Decreased
      xxl: 16.0,  // Decreased
      xxxl: 20.0, // Decreased
      full: 9999.0,
    );
  }
  
  /// Creates a lerped version between this and another radius token set
  UiRadiusTokens lerp(UiRadiusTokens other, double t) {
    return UiRadiusTokens(
      none: lerpDouble(none, other.none, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      xxxl: lerpDouble(xxxl, other.xxxl, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }
  
  /// Get BorderRadius for all corners with specified size
  BorderRadius all(String size) {
    return BorderRadius.all(Radius.circular(get(size)));
  }
  
  /// Get a radius value by semantic name
  double get(String name) {
    switch (name) {
      case 'none': return none;
      case 'sm': return sm;
      case 'md': return md;
      case 'lg': return lg;
      case 'xl': return xl;
      case '2xl': return xxl;
      case '3xl': return xxxl;
      case 'full': return full;
      default: throw ArgumentError('Unknown radius: $name');
    }
  }
  
  /// Get a radius value by index (where 0 is none, 1 is sm, etc.)
  double operator [](int index) {
    switch (index) {
      case 0: return none;
      case 1: return sm;
      case 2: return md;
      case 3: return lg;
      case 4: return xl;
      case 5: return xxl;
      case 6: return xxxl;
      case 7: return full;
      default: throw ArgumentError('Radius index out of range: $index');
    }
  }
}
