import 'package:flutter/material.dart';

/// Motion tokens for the UI Kit.
///
/// Provides standardized durations and curves for animations and transitions
/// to create consistent motion throughout the application.
class UiMotionTokens {
  /// Extra short duration (50ms)
  final Duration xs;
  
  /// Short duration (100ms)
  final Duration sm;
  
  /// Medium duration (200ms)
  final Duration md;
  
  /// Long duration (300ms)
  final Duration lg;
  
  /// Extra long duration (400ms)
  final Duration xl;
  
  /// Standard easing - Recommended for most transitions
  final Curve standard;
  
  /// Accelerate easing - Motion starts slowly and accelerates
  final Curve accelerate;
  
  /// Decelerate easing - Motion starts quickly and slows down
  final Curve decelerate;
  
  /// Emphasis easing - Motion with extra emphasis at the end (like Material's standard curve)
  final Curve emphasis;
  
  /// Linear easing - Motion at constant speed (rarely used)
  final Curve linear;
  
  /// Creates a motion token set with custom values
  const UiMotionTokens({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.standard,
    required this.accelerate,
    required this.decelerate,
    required this.emphasis,
    required this.linear,
  });
  
  /// Creates the standard motion token set
  factory UiMotionTokens.standard() {
    return const UiMotionTokens(
      xs: Duration(milliseconds: 50),
      sm: Duration(milliseconds: 100),
      md: Duration(milliseconds: 200),
      lg: Duration(milliseconds: 300),
      xl: Duration(milliseconds: 400),
      standard: Curves.easeInOutCubic,
      accelerate: Curves.easeIn,
      decelerate: Curves.easeOut,
      emphasis: Curves.easeOutBack,
      linear: Curves.linear,
    );
  }
  
  /// Creates a faster motion token set (25% quicker)
  factory UiMotionTokens.fast() {
    return const UiMotionTokens(
      xs: Duration(milliseconds: 40),
      sm: Duration(milliseconds: 75),
      md: Duration(milliseconds: 150),
      lg: Duration(milliseconds: 225),
      xl: Duration(milliseconds: 300),
      standard: Curves.easeInOutCubic,
      accelerate: Curves.easeIn,
      decelerate: Curves.easeOut,
      emphasis: Curves.easeOutBack,
      linear: Curves.linear,
    );
  }
  
  /// Creates a slower motion token set (25% slower)
  factory UiMotionTokens.slow() {
    return const UiMotionTokens(
      xs: Duration(milliseconds: 65),
      sm: Duration(milliseconds: 125),
      md: Duration(milliseconds: 250),
      lg: Duration(milliseconds: 375),
      xl: Duration(milliseconds: 500),
      standard: Curves.easeInOutCubic,
      accelerate: Curves.easeIn,
      decelerate: Curves.easeOut,
      emphasis: Curves.easeOutBack,
      linear: Curves.linear,
    );
  }
  
  /// Creates a reduced-motion token set for accessibility
  factory UiMotionTokens.reducedMotion() {
    return const UiMotionTokens(
      xs: Duration(milliseconds: 0),
      sm: Duration(milliseconds: 0),
      md: Duration(milliseconds: 100),
      lg: Duration(milliseconds: 150),
      xl: Duration(milliseconds: 200),
      standard: Curves.easeOut, // Simplified curves for reduced motion
      accelerate: Curves.linear,
      decelerate: Curves.linear,
      emphasis: Curves.easeOut,
      linear: Curves.linear,
    );
  }
  
  /// Creates a lerped version between this and another motion token set
  UiMotionTokens lerp(UiMotionTokens other, double t) {
    // For durations, we can interpolate the milliseconds
    return UiMotionTokens(
      xs: Duration(milliseconds: _lerpInt(xs.inMilliseconds, other.xs.inMilliseconds, t)),
      sm: Duration(milliseconds: _lerpInt(sm.inMilliseconds, other.sm.inMilliseconds, t)),
      md: Duration(milliseconds: _lerpInt(md.inMilliseconds, other.md.inMilliseconds, t)),
      lg: Duration(milliseconds: _lerpInt(lg.inMilliseconds, other.lg.inMilliseconds, t)),
      xl: Duration(milliseconds: _lerpInt(xl.inMilliseconds, other.xl.inMilliseconds, t)),
      // Curves can't be easily interpolated, so we choose based on t
      standard: t < 0.5 ? standard : other.standard,
      accelerate: t < 0.5 ? accelerate : other.accelerate,
      decelerate: t < 0.5 ? decelerate : other.decelerate,
      emphasis: t < 0.5 ? emphasis : other.emphasis,
      linear: linear, // Linear is the same in both cases
    );
  }
  
  /// Get a duration by semantic name
  Duration getDuration(String name) {
    switch (name) {
      case 'xs': return xs;
      case 'sm': return sm;
      case 'md': return md;
      case 'lg': return lg;
      case 'xl': return xl;
      default: throw ArgumentError('Unknown duration: $name');
    }
  }
  
  /// Get a curve by semantic name
  Curve getCurve(String name) {
    switch (name) {
      case 'standard': return standard;
      case 'accelerate': return accelerate;
      case 'decelerate': return decelerate;
      case 'emphasis': return emphasis;
      case 'linear': return linear;
      default: throw ArgumentError('Unknown curve: $name');
    }
  }
  
  // Helper method to interpolate integers
  int _lerpInt(int a, int b, double t) {
    return (a + (b - a) * t).round();
  }
}
