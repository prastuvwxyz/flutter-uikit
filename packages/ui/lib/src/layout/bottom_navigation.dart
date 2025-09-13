import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart' hide BottomNavigationBar;

/// A customizable bottom navigation bar component.
class BottomNavigationBar extends StatelessWidget {
  const BottomNavigationBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.type,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
  });

  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BottomNavigationBarType? type;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = flutter.Theme.of(context);

    return flutter.BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      type: type ?? (items.length > 3 ? BottomNavigationBarType.shifting : BottomNavigationBarType.fixed),
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      selectedItemColor: selectedItemColor ?? theme.colorScheme.primary,
      unselectedItemColor: unselectedItemColor ?? theme.colorScheme.onSurfaceVariant,
      elevation: elevation,
    );
  }
}