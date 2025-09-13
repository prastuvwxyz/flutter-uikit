import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

class Radius extends ThemeExtension<Radius> {
  final double none;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double full;

  const Radius({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.full,
  });

  const Radius.standard()
      : none = 0.0,
        sm = 4.0,
        md = 8.0,
        lg = 12.0,
        xl = 16.0,
        xxl = 24.0,
        full = 9999.0;

  @override
  Radius copyWith({
    double? none,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? full,
  }) {
    return Radius(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      full: full ?? this.full,
    );
  }

  @override
  Radius lerp(Radius? other, double t) {
    if (other == null) return this;
    
    return Radius(
      none: lerpDouble(none, other.none, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }

  static Radius of(BuildContext context) {
    return Theme.of(context).extension<Radius>() ?? const Radius.standard();
  }
}