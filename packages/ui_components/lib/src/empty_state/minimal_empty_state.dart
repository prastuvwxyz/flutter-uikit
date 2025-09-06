import 'package:flutter/material.dart';

/// MinimalEmptyState
class MinimalEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Widget? image;
  final Widget? action;
  final Widget? secondaryAction;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final double iconSize;
  final double spacing;
  final EdgeInsets padding;
  final Alignment alignment;
  final double? maxWidth;

  const MinimalEmptyState({
    Key? key,
    this.title = '',
    this.description,
    this.icon,
    this.image,
    this.action,
    this.secondaryAction,
    this.titleStyle,
    this.descriptionStyle,
    this.iconSize = 64.0,
    this.spacing = 16.0,
    this.padding = const EdgeInsets.all(24.0),
    this.alignment = Alignment.center,
    this.maxWidth = 400.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveTitleStyle =
        titleStyle ??
        theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600) ??
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

    final effectiveDescriptionStyle =
        descriptionStyle ??
        theme.textTheme.bodyMedium ??
        const TextStyle(fontSize: 14);

    final List<Widget> columnChildren = [];

    if (image != null) {
      columnChildren.add(Center(child: image));
    } else if (icon != null) {
      columnChildren.add(
        Icon(icon, size: iconSize, semanticLabel: 'Empty state icon'),
      );
    }

    if (title.isNotEmpty) {
      if (columnChildren.isNotEmpty)
        columnChildren.add(SizedBox(height: spacing));
      columnChildren.add(
        Text(title, style: effectiveTitleStyle, textAlign: TextAlign.center),
      );
    }

    if (description != null && description!.isNotEmpty) {
      columnChildren.add(SizedBox(height: spacing / 2));
      columnChildren.add(
        Text(
          description!,
          style: effectiveDescriptionStyle,
          textAlign: TextAlign.center,
        ),
      );
    }

    final actions = <Widget>[];
    if (action != null) actions.add(action!);
    if (secondaryAction != null) {
      if (actions.isNotEmpty) actions.add(SizedBox(width: spacing));
      actions.add(secondaryAction!);
    }

    if (actions.isNotEmpty) {
      columnChildren.add(SizedBox(height: spacing));
      columnChildren.add(
        Row(mainAxisSize: MainAxisSize.min, children: actions),
      );
    }

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: columnChildren,
      ),
    );

    content = Semantics(
      container: true,
      liveRegion: true,
      label: title.isNotEmpty ? title : 'Empty',
      child: content,
    );

    return Align(
      alignment: alignment,
      child: Padding(padding: padding, child: content),
    );
  }
}
