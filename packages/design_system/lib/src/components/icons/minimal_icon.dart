import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

enum SemanticIconType { success, error, warning, info, primary, secondary }

enum MinimalIconSize {
  xs(12.0),
  sm(16.0),
  md(24.0),
  lg(32.0),
  xl(48.0),
  xxl(64.0);

  const MinimalIconSize(this.size);
  final double size;
}

class MinimalIcon extends StatelessWidget {
  const MinimalIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
  }) : semanticType = null;

  const MinimalIcon.semantic(
    this.icon, {
    super.key,
    required this.semanticType,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
  });

  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final SemanticIconType? semanticType;

  double _getIconSize(BuildContext context) {
    if (size != null) return size!;
    // Default to the medium token size; project token shape may vary so
    // keep this simple and predictable for now.
    return MinimalIconSize.md.size;
  }

  Color? _getIconColor(BuildContext context) {
    if (color != null) return color;
    if (semanticType != null) return _getSemanticColor(context, semanticType!);
    return Theme.of(context).colorScheme.onSurface;
  }

  Color? _getSemanticColor(BuildContext context, SemanticIconType type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (type) {
      case SemanticIconType.success:
        return colorScheme.primary;
      case SemanticIconType.error:
        return colorScheme.error;
      case SemanticIconType.warning:
        return Colors.orange;
      case SemanticIconType.info:
        return colorScheme.primary;
      case SemanticIconType.primary:
        return colorScheme.primary;
      case SemanticIconType.secondary:
        return colorScheme.secondary;
    }
  }

  bool _isDecorative() {
    return semanticLabel == null && semanticType == null;
  }

  String? _getSemanticLabel() {
    if (semanticLabel != null) return semanticLabel;
    if (semanticType != null) {
      switch (semanticType!) {
        case SemanticIconType.success:
          return 'Success';
        case SemanticIconType.error:
          return 'Error';
        case SemanticIconType.warning:
          return 'Warning';
        case SemanticIconType.info:
          return 'Information';
        case SemanticIconType.primary:
          return null;
        case SemanticIconType.secondary:
          return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _getSemanticLabel(),
      excludeSemantics: _isDecorative(),
      child: Icon(
        icon,
        size: _getIconSize(context),
        color: _getIconColor(context),
        textDirection: textDirection,
      ),
    );
  }
}
