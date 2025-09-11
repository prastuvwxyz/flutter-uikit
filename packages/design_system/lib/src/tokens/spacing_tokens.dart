import 'dart:ui' show lerpDouble;

/// Spacing tokens for the UI Kit.
///
/// Provides standardized spacing values based on a 4px grid system to ensure
/// consistent spacing throughout the application.
class UiSpacingTokens {
  /// Extra small spacing (4px)
  final double xs;
  
  /// Small spacing (8px)
  final double sm;
  
  /// Medium spacing (12px)
  final double md;
  
  /// Large spacing (16px)
  final double lg;
  
  /// Extra large spacing (20px)
  final double xl;
  
  /// Double extra large spacing (24px)
  final double xxl;
  
  /// Triple extra large spacing (32px)
  final double xxxl;
  
  /// Quadruple extra large spacing (40px)
  final double xxxxl;
  
  /// Quintuple extra large spacing (48px)
  final double xxxxxl;
  
  /// Sextuple extra large spacing (64px)
  final double xxxxxxl;
  
  /// Creates a spacing token set with custom values
  const UiSpacingTokens({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.xxxxl,
    required this.xxxxxl,
    required this.xxxxxxl,
  });
  
  /// Creates the standard spacing token set based on a 4px grid
  const UiSpacingTokens.standard() : 
    xs = 4.0,
    sm = 8.0,
    md = 12.0,
    lg = 16.0,
    xl = 20.0,
    xxl = 24.0,
    xxxl = 32.0,
    xxxxl = 40.0,
    xxxxxl = 48.0,
    xxxxxxl = 64.0;
  
  /// Creates a compact spacing token set (25% less than standard)
  factory UiSpacingTokens.compact() {
    const standard = UiSpacingTokens.standard();
    return UiSpacingTokens(
      xs: standard.xs * 0.75,
      sm: standard.sm * 0.75,
      md: standard.md * 0.75,
      lg: standard.lg * 0.75,
      xl: standard.xl * 0.75,
      xxl: standard.xxl * 0.75,
      xxxl: standard.xxxl * 0.75,
      xxxxl: standard.xxxxl * 0.75,
      xxxxxl: standard.xxxxxl * 0.75,
      xxxxxxl: standard.xxxxxxl * 0.75,
    );
  }
  
  /// Creates a comfortable spacing token set (25% more than standard)
  factory UiSpacingTokens.comfortable() {
    const standard = UiSpacingTokens.standard();
    return UiSpacingTokens(
      xs: standard.xs * 1.25,
      sm: standard.sm * 1.25,
      md: standard.md * 1.25,
      lg: standard.lg * 1.25,
      xl: standard.xl * 1.25,
      xxl: standard.xxl * 1.25,
      xxxl: standard.xxxl * 1.25,
      xxxxl: standard.xxxxl * 1.25,
      xxxxxl: standard.xxxxxl * 1.25,
      xxxxxxl: standard.xxxxxxl * 1.25,
    );
  }
  
  /// Creates a lerped version between this and another spacing token set
  UiSpacingTokens lerp(UiSpacingTokens other, double t) {
    return UiSpacingTokens(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      xxxl: lerpDouble(xxxl, other.xxxl, t)!,
      xxxxl: lerpDouble(xxxxl, other.xxxxl, t)!,
      xxxxxl: lerpDouble(xxxxxl, other.xxxxxl, t)!,
      xxxxxxl: lerpDouble(xxxxxxl, other.xxxxxxl, t)!,
    );
  }
  
  /// Get a spacing value by semantic name
  double get(String name) {
    switch (name) {
      case 'xs': return xs;
      case 'sm': return sm;
      case 'md': return md;
      case 'lg': return lg;
      case 'xl': return xl;
      case '2xl': return xxl;
      case '3xl': return xxxl;
      case '4xl': return xxxxl;
      case '5xl': return xxxxxl;
      case '6xl': return xxxxxxl;
      default: throw ArgumentError('Unknown spacing: $name');
    }
  }
  
  /// Get a spacing value by index (where 0 is xs, 1 is sm, etc.)
  double operator [](int index) {
    switch (index) {
      case 0: return xs;
      case 1: return sm;
      case 2: return md;
      case 3: return lg;
      case 4: return xl;
      case 5: return xxl;
      case 6: return xxxl;
      case 7: return xxxxl;
      case 8: return xxxxxl;
      case 9: return xxxxxxl;
      default: throw ArgumentError('Spacing index out of range: $index');
    }
  }
}
