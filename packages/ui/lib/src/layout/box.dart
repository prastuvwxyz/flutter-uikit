import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart' hide Container;

/// Box - a lightweight, flexible container with styling shortcuts.
///
/// Provides padding, margin, border, background, radius and shadow support.
class Box extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final Border? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadow;
  final AlignmentGeometry? alignment;

  const Box({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.border,
    this.borderRadius,
    this.shadow,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = _buildContainer(context);

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    return result;
  }

  Widget _buildContainer(BuildContext context) {
    final effectiveDecoration = decoration ??
        (color != null ||
                border != null ||
                borderRadius != null ||
                shadow != null
            ? BoxDecoration(
                color: color,
                border: border,
                borderRadius: borderRadius,
                boxShadow: shadow,
              )
            : null);

    return flutter.Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: effectiveDecoration,
      child: child,
    );
  }

  /// Predefined card style
  factory Box.card({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    Color? color,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadow,
    AlignmentGeometry? alignment,
  }) {
    return Box(
      key: key,
      child: child,
      padding: padding ?? const EdgeInsets.all(16.0),
      margin: margin,
      width: width,
      height: height,
      color: color ?? Colors.white,
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      shadow: shadow ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
      alignment: alignment,
    );
  }

  /// Predefined bordered style
  factory Box.bordered({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    Color? color,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    AlignmentGeometry? alignment,
  }) {
    final borderValue = Border.all(
      color: borderColor ?? Colors.grey.shade300,
      width: borderWidth ?? 1.0,
    );

    return Box(
      key: key,
      child: child,
      padding: padding ?? const EdgeInsets.all(16.0),
      margin: margin,
      width: width,
      height: height,
      color: color,
      border: borderValue,
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      alignment: alignment,
    );
  }
}