import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

/// A flexible container component with customizable styling options.
///
/// MinimalContainer provides padding, margin, borders, background and shadow styling.
/// It uses design tokens for consistent theming and supports RTL layouts.
class MinimalContainer extends StatelessWidget {
  /// The child widget to display inside the container
  final Widget? child;

  /// Internal padding applied around the child
  final EdgeInsetsGeometry? padding;

  /// External margin applied around the container
  final EdgeInsetsGeometry? margin;

  /// Container width (null for automatic sizing)
  final double? width;

  /// Container height (null for automatic sizing)
  final double? height;

  /// Size constraints for the container
  final BoxConstraints? constraints;

  /// Background decoration (takes precedence over backgroundColor)
  final Decoration? decoration;

  /// Background color (ignored if decoration is provided)
  final Color? backgroundColor;

  /// Border styling
  final Border? border;

  /// Border radius for rounded corners
  final BorderRadiusGeometry? borderRadius;

  /// Shadow effects
  final List<BoxShadow>? boxShadow;

  /// Child alignment within container
  final AlignmentGeometry? alignment;

  /// Transformation matrix for the container
  final Matrix4? transform;

  /// Transform origin alignment
  final AlignmentGeometry? transformAlignment;

  /// Clipping behavior for the container
  final Clip clipBehavior;

  /// Creates a MinimalContainer.
  ///
  /// All parameters are optional to allow for flexible usage.
  const MinimalContainer({
    Key? key,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.decoration,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.alignment,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Apply margin first (if specified)
    Widget result = _buildContainer(context);
    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    // Apply transform if specified
    if (transform != null) {
      result = Transform(
        transform: transform!,
        alignment: transformAlignment,
        child: result,
      );
    }

    return result;
  }

  Widget _buildContainer(BuildContext context) {
    // Build decoration from individual properties if a full decoration wasn't provided
    final effectiveDecoration =
        decoration ??
        (backgroundColor != null ||
                border != null ||
                borderRadius != null ||
                boxShadow != null
            ? BoxDecoration(
                color: backgroundColor,
                border: border,
                borderRadius: borderRadius,
                boxShadow: boxShadow,
              )
            : null);

    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      constraints: constraints,
      decoration: effectiveDecoration,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// Creates a card-styled container with predefined styling
  factory MinimalContainer.card({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    AlignmentGeometry? alignment,
  }) {
    // Get token values (fallback to defaults if not available)
    final borderRadiusValue =
        borderRadius ?? BorderRadius.circular(8.0); // md radius
    final shadowValue =
        boxShadow ??
        [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ];

    return MinimalContainer(
      key: key,
      child: child,
      padding: padding ?? const EdgeInsets.all(16.0), // md spacing
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      backgroundColor: backgroundColor ?? Colors.white,
      borderRadius: borderRadiusValue,
      boxShadow: shadowValue,
      alignment: alignment,
    );
  }

  /// Creates a bordered container with predefined styling
  factory MinimalContainer.bordered({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
    AlignmentGeometry? alignment,
  }) {
    // Get token values (fallback to defaults if not available)
    final borderRadiusValue =
        borderRadius ?? BorderRadius.circular(8.0); // md radius
    final borderValue = Border.all(
      color: borderColor ?? Colors.grey.shade300,
      width: borderWidth ?? 1.0,
    );

    return MinimalContainer(
      key: key,
      child: child,
      padding: padding ?? const EdgeInsets.all(16.0), // md spacing
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      backgroundColor: backgroundColor,
      border: borderValue,
      borderRadius: borderRadiusValue,
      alignment: alignment,
    );
  }
}
