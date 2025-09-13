import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart' hide Drawer;

/// A customizable navigation drawer component.
class Drawer extends StatelessWidget {
  const Drawer({
    super.key,
    this.child,
    this.backgroundColor,
    this.width,
    this.elevation = 16.0,
  });

  final Widget? child;
  final Color? backgroundColor;
  final double? width;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = flutter.Theme.of(context);

    return flutter.Drawer(
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      width: width,
      elevation: elevation,
      child: child,
    );
  }
}