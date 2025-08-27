import 'package:flutter/material.dart';

class BottomNavigationItem {
  final Widget icon;
  final String label;
  final int? badgeCount;

  const BottomNavigationItem({
    required this.icon,
    required this.label,
    this.badgeCount,
  });
}
