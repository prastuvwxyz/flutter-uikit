import 'package:flutter/material.dart';

/// A customizable link component with hover and focus states.
class Link extends StatelessWidget {
  const Link({
    super.key,
    required this.text,
    this.onTap,
    this.url,
    this.style,
    this.hoverColor,
    this.underline = true,
  });

  final String text;
  final VoidCallback? onTap;
  final String? url;
  final TextStyle? style;
  final Color? hoverColor;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.primary,
      decoration: underline ? TextDecoration.underline : null,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: style ?? defaultStyle,
        ),
      ),
    );
  }
}