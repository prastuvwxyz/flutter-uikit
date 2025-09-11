import 'package:flutter/material.dart';

/// Minimal styling options for the menu used by [MinimalMenu].
class MenuStyle {
  final Color? backgroundColor;
  final Color? outlineColor;
  final double? elevation;
  final double? radius;

  const MenuStyle({
    this.backgroundColor,
    this.outlineColor,
    this.elevation,
    this.radius,
  });
}
