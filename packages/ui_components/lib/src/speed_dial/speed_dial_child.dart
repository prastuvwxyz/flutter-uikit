import 'package:flutter/material.dart';

class SpeedDialChild {
  const SpeedDialChild({
    this.icon,
    this.label,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData? icon;
  final Widget? label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
}
