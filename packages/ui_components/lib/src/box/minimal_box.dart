import 'package:flutter/material.dart';
import 'package:ui_components/tokens/spacing_tokens.dart';
import 'package:ui_components/tokens/radius_tokens.dart';
import 'package:ui_components/tokens/elevation_tokens.dart';
import 'package:ui_components/tokens/color_tokens.dart';

/// MinimalBox - a lightweight, flexible container with styling shortcuts.
///
/// Provides padding, margin, border, background, radius and shadow support.
class MinimalBox extends StatelessWidget {
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

  const MinimalBox({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result = _buildContainer(context);

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    return result;
  }

  Widget _buildContainer(BuildContext context) {
    final effectiveDecoration =
        decoration ??
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

    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: effectiveDecoration,
      child: child,
    );
  }

  /// Predefined card style
  factory MinimalBox.card({
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
    final radius = borderRadius ?? BorderRadius.circular(RadiusTokens.md);
    final boxShadow =
        shadow ??
        [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ElevationTokens.md,
            offset: const Offset(0, 2),
          ),
        ];

    return MinimalBox(
      key: key,
      child: child,
      padding: padding ?? EdgeInsets.all(SpacingTokens.md),
      margin: margin,
      width: width,
      height: height,
      color: color ?? ColorTokens.surface,
      borderRadius: radius,
      shadow: boxShadow,
      alignment: alignment,
    );
  }

  /// Predefined bordered style
  factory MinimalBox.bordered({
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
    final radius = borderRadius ?? BorderRadius.circular(RadiusTokens.md);
    final borderValue = Border.all(
      color: borderColor ?? ColorTokens.outline,
      width: borderWidth ?? 1.0,
    );

    return MinimalBox(
      key: key,
      child: child,
      padding: padding ?? EdgeInsets.all(SpacingTokens.md),
      margin: margin,
      width: width,
      height: height,
      color: color,
      border: borderValue,
      borderRadius: radius,
      alignment: alignment,
    );
  }
}
