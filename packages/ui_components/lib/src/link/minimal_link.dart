import 'package:flutter/material.dart';

/// MinimalLink: simple, accessible link widget with external handling.
class MinimalLink extends StatefulWidget {
  final Widget? child;
  final String? url;
  final VoidCallback? onTap;
  final bool isExternal;
  final bool underline;
  final bool hoverUnderline;
  final Color? color;
  final Color? hoverColor;
  final Color? visitedColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? semanticsLabel;
  // target omitted for minimal implementation

  const MinimalLink({
    super.key,
    this.child,
    this.url,
    this.onTap,
    this.isExternal = false,
    this.underline = true,
    this.hoverUnderline = true,
    this.color,
    this.hoverColor,
    this.visitedColor,
    this.fontSize,
    this.fontWeight,
    this.semanticsLabel,
    // this.target = LinkTarget.self,
  });

  @override
  State<MinimalLink> createState() => _MinimalLinkState();
}

class _MinimalLinkState extends State<MinimalLink> {
  bool _hovering = false;
  bool _visited = false;

  void _handleTap() {
    widget.onTap?.call();
    if (widget.url != null) {
      // For now, just mark visited; actual navigation is left to the app or tests.
      setState(() => _visited = true);
    }
  }

  TextStyle _effectiveStyle(ThemeData theme) {
    final baseColor = widget.color ?? theme.colorScheme.primary;
    final hoverColor = widget.hoverColor ?? baseColor;
    final visitedColor = widget.visitedColor ?? baseColor.withOpacity(0.8);

    Color color = baseColor;
    if (_visited) color = visitedColor;
    if (_hovering) color = hoverColor;

    final decoration = widget.underline
        ? TextDecoration.underline
        : TextDecoration.none;

    final hoverDecoration = (_hovering && widget.hoverUnderline)
        ? TextDecoration.underline
        : decoration;

    return TextStyle(
      color: color,
      decoration: hoverDecoration,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: _handleTap,
          child: Semantics(
            button: false,
            link: true,
            label: widget.semanticsLabel,
            child: DefaultTextStyle(
              style: _effectiveStyle(theme),
              child: widget.child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
