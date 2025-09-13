import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

class Spacing extends ThemeExtension<Spacing> {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
  final double xxxxl;
  final double xxxxxl;
  final double xxxxxxl;

  const Spacing({
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

  const Spacing.standard()
      : xs = 4.0,
        sm = 8.0,
        md = 12.0,
        lg = 16.0,
        xl = 20.0,
        xxl = 24.0,
        xxxl = 32.0,
        xxxxl = 40.0,
        xxxxxl = 48.0,
        xxxxxxl = 64.0;

  factory Spacing.compact() {
    const standard = Spacing.standard();
    return Spacing(
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

  factory Spacing.comfortable() {
    const standard = Spacing.standard();
    return Spacing(
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

  @override
  Spacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? xxxxl,
    double? xxxxxl,
    double? xxxxxxl,
  }) {
    return Spacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      xxxxl: xxxxl ?? this.xxxxl,
      xxxxxl: xxxxxl ?? this.xxxxxl,
      xxxxxxl: xxxxxxl ?? this.xxxxxxl,
    );
  }

  @override
  Spacing lerp(Spacing? other, double t) {
    if (other == null) return this;
    
    return Spacing(
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

  static Spacing of(BuildContext context) {
    return Theme.of(context).extension<Spacing>() ?? const Spacing.standard();
  }
}