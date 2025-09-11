import 'package:flutter/material.dart';
import 'bottom_navigation_item.dart';

// ...existing code...

/// Navigation type for MinimalBottomNavigation
enum BottomNavigationType { fixed, shifting }

/// Minimal bottom navigation bar component
class MinimalBottomNavigation extends StatelessWidget {
  final List<BottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BottomNavigationType type;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final double elevation;

  const MinimalBottomNavigation({
    Key? key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.type = BottomNavigationType.fixed,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.elevation = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFixed = type == BottomNavigationType.fixed;
    final theme = Theme.of(context);
    final Color bgColor = backgroundColor ?? theme.colorScheme.surface;
    final Color selectedColor = selectedItemColor ?? theme.colorScheme.primary;
    final Color unselectedColor =
        unselectedItemColor ?? theme.colorScheme.onSurface.withOpacity(0.6);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Material(
        color: bgColor,
        elevation: elevation,
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (index) {
              final selected = index == currentIndex;
              final item = items[index];
              return _BottomNavItem(
                icon: item.icon,
                label: item.label,
                badgeCount: item.badgeCount,
                selected: selected,
                showLabel: selected ? showSelectedLabels : showUnselectedLabels,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                onTap: () => onTap?.call(index),
                semanticsLabel: item.label,
                isFixed: isFixed,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final int? badgeCount;
  final bool selected;
  final bool showLabel;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback? onTap;
  final String semanticsLabel;
  final bool isFixed;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.badgeCount,
    required this.selected,
    required this.showLabel,
    required this.selectedColor,
    required this.unselectedColor,
    this.onTap,
    required this.semanticsLabel,
    required this.isFixed,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : unselectedColor;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Semantics(
          selected: selected,
          label: semanticsLabel,
          button: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconTheme(
                    data: IconThemeData(color: color),
                    child: icon,
                  ),
                  if (badgeCount != null && badgeCount! > 0)
                    _Badge(count: badgeCount!, color: selectedColor),
                ],
              ),
              if (showLabel)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final Color color;

  const _Badge({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 0, top: 0),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
