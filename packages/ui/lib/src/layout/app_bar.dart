import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart' hide AppBar;
import 'package:tokens/tokens.dart' as tokens;

/// A customizable app bar component with design token integration.
class AppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
    this.titleSpacing,
    this.toolbarHeight,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final double? titleSpacing;
  final double? toolbarHeight;

  @override
  Widget build(BuildContext context) {
    final theme = flutter.Theme.of(context);
    final spacing = tokens.Spacing.of(context);

    return flutter.AppBar(
      title: title,
      actions: actions,
      leading: leading,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: titleSpacing ?? spacing.md,
      toolbarHeight: toolbarHeight,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}