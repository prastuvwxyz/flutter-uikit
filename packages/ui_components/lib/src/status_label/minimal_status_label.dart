import 'package:flutter/material.dart';

enum StatusType { success, warning, error, info, neutral }

enum StatusSize { small, medium, large }

enum StatusVariant { filled, outlined, ghost, soft }

class MinimalStatusLabel extends StatelessWidget {
  final String text;
  final StatusType status;
  final IconData? icon;
  final bool showIcon;
  final StatusSize size;
  final StatusVariant variant;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const MinimalStatusLabel({
    super.key,
    this.text = '',
    this.status = StatusType.neutral,
    this.icon,
    this.showIcon = true,
    this.size = StatusSize.medium,
    this.variant = StatusVariant.filled,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  Color _resolveColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (status) {
      case StatusType.success:
        return color ?? Colors.green;
      case StatusType.warning:
        return color ?? Colors.orange;
      case StatusType.error:
        return color ?? Colors.red;
      case StatusType.info:
        return color ?? Colors.blue;
      case StatusType.neutral:
        return color ?? theme.colorScheme.onSurface.withOpacity(0.87);
    }
  }

  Color _resolveBackground(BuildContext context) {
    final theme = Theme.of(context);
    if (backgroundColor != null) return backgroundColor!;
    final c = _resolveColor(context);
    switch (variant) {
      case StatusVariant.filled:
        return c.withOpacity(1.0);
      case StatusVariant.soft:
        return c.withOpacity(0.12);
      case StatusVariant.ghost:
      case StatusVariant.outlined:
        return theme.colorScheme.surface;
    }
  }

  Border? _resolveBorder(BuildContext context) {
    final c = borderColor ?? _resolveColor(context);
    switch (variant) {
      case StatusVariant.outlined:
        return Border.all(color: c, width: 1.0);
      case StatusVariant.ghost:
        return Border.all(color: c.withOpacity(0.12), width: 1.0);
      case StatusVariant.filled:
      case StatusVariant.soft:
        return null;
    }
  }

  double _fontSize() {
    switch (size) {
      case StatusSize.small:
        return 12.0;
      case StatusSize.large:
        return 16.0;
      case StatusSize.medium:
        return 14.0;
    }
  }

  EdgeInsets _padding() {
    if (padding != null) return padding!;
    switch (size) {
      case StatusSize.small:
        return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
      case StatusSize.large:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case StatusSize.medium:
        return const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0);
    }
  }

  BorderRadius _radius() {
    return borderRadius ?? BorderRadius.circular(12.0);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedColor = _resolveColor(context);
    final bg = _resolveBackground(context);
    final border = _resolveBorder(context);

    final effectiveTextStyle =
        textStyle ??
        TextStyle(
          color: variant == StatusVariant.filled ? Colors.white : resolvedColor,
          fontSize: _fontSize(),
        );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon && icon != null) ...[
          Icon(icon, size: _fontSize() + 4, color: effectiveTextStyle.color),
          const SizedBox(width: 8.0),
        ],
        Text(text, style: effectiveTextStyle),
      ],
    );

    final decorated = Container(
      padding: _padding(),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: _radius(),
        border: border,
      ),
      child: content,
    );

    if (onTap != null) {
      return Semantics(
        container: true,
        button: true,
        label: text,
        child: InkWell(onTap: onTap, borderRadius: _radius(), child: decorated),
      );
    }

    return Semantics(container: true, label: text, child: decorated);
  }
}
