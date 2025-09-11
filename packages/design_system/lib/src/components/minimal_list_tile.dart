import 'package:flutter/material.dart';

/// A minimal ListTile alternative that follows the design spec in docs.
class MinimalListTile extends StatelessWidget {
  const MinimalListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enabled = true,
    this.dense = false,
    this.contentPadding,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback = true,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final bool selected;
  final bool enabled;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? tileColor;
  final Color? selectedTileColor;
  final bool enableFeedback;

  static const _defaultHorizontalPadding = 20.0; // tokens.spacing.lg
  static const _defaultVerticalPadding = 16.0; // tokens.spacing.md
  static const _denseVerticalPadding = 12.0; // tokens.spacing.sm

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveDensity = visualDensity ?? theme.visualDensity;

    final resolvedTileColor = selected
        ? (selectedTileColor ?? theme.colorScheme.primaryContainer)
        : (tileColor ?? Colors.transparent);

    final resolvedPadding =
        contentPadding ??
        EdgeInsets.symmetric(
          horizontal: _defaultHorizontalPadding,
          vertical: dense ? _denseVerticalPadding : _defaultVerticalPadding,
        );

    final textColumn = <Widget>[];
    if (title != null) {
      textColumn.add(
        DefaultTextStyle(
          style: theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 16),
          child: title!,
        ),
      );
    }
    if (subtitle != null) {
      textColumn.add(
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: DefaultTextStyle(
            style: theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14),
            child: subtitle!,
          ),
        ),
      );
    }

    Widget content = Row(
      crossAxisAlignment: subtitle != null
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              child: leading,
            ),
          ),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: textColumn,
          ),
        ),
        if (trailing != null) ...[
          Padding(padding: const EdgeInsets.only(left: 16.0), child: trailing),
        ],
      ],
    );

    final semanticsLabel = _buildSemanticsLabel();

    return Semantics(
      selected: selected,
      button: onTap != null,
      enabled: enabled,
      label: semanticsLabel,
      child: Focus(
        focusNode: focusNode,
        autofocus: autofocus,
        child: Material(
          color: resolvedTileColor,
          child: InkWell(
            onTap: enabled ? onTap : null,
            onLongPress: enabled ? onLongPress : null,
            enableFeedback: enableFeedback,
            canRequestFocus: enabled,
            focusColor: theme.focusColor,
            hoverColor: theme.hoverColor,
            child: Padding(
              padding: resolvedPadding.add(
                EdgeInsets.all(effectiveDensity.vertical * 2),
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  String? _buildSemanticsLabel() {
    // A minimal concatenation of title and subtitle for screen readers when they are Text widgets.
    String? titleText;
    String? subtitleText;

    if (title is Text) titleText = (title as Text).data;
    if (subtitle is Text) subtitleText = (subtitle as Text).data;

    if (titleText == null && subtitleText == null) return null;
    if (titleText != null && subtitleText != null)
      return '$titleText, $subtitleText';
    return titleText ?? subtitleText;
  }
}
