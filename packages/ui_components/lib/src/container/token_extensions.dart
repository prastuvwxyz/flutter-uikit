import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'minimal_container.dart';

/// Extension for creating MinimalContainers with design tokens
extension MinimalContainerTokenExtension on BuildContext {
  /// Create a MinimalContainer with design tokens
  MinimalContainer container({
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Color? backgroundColor,
    Border? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    AlignmentGeometry? alignment,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) {
    // We're not using tokens here since this is the base container,
    // but including this method for API consistency
    return MinimalContainer(
      child: child,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      backgroundColor: backgroundColor,
      border: border,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      alignment: alignment,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
    );
  }

  /// Create a card-styled container with design tokens
  MinimalContainer cardContainer({
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
    final tokens = Theme.of(this).extension<UiTokens>() ?? UiTokens.standard();
    final radiusTokens = tokens.radiusTokens;
    final elevationTokens = tokens.elevationTokens;

    // Use token values with fallbacks
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(radiusTokens.md);
    final shadowColor = elevationTokens.isDark
        ? elevationTokens.darkShadowColor
        : elevationTokens.lightShadowColor;
    final effectiveBoxShadow =
        boxShadow ??
        [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: elevationTokens.level2,
            offset: const Offset(0, 2),
          ),
        ];

    return MinimalContainer(
      child: child,
      padding: padding ?? EdgeInsets.all(tokens.spacingTokens.md),
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      backgroundColor: backgroundColor ?? Colors.white,
      borderRadius: effectiveBorderRadius,
      boxShadow: effectiveBoxShadow,
      alignment: alignment,
    );
  }

  /// Create a bordered container with design tokens
  MinimalContainer borderedContainer({
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
    final tokens = Theme.of(this).extension<UiTokens>() ?? UiTokens.standard();
    final radiusTokens = tokens.radiusTokens;

    // Use token values with fallbacks
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(radiusTokens.md);
    final effectiveBorderColor = borderColor ?? Colors.grey.shade300;
    final effectiveBorderWidth = borderWidth ?? 1.0;

    return MinimalContainer(
      child: child,
      padding: padding ?? EdgeInsets.all(tokens.spacingTokens.md),
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      backgroundColor: backgroundColor,
      border: Border.all(
        color: effectiveBorderColor,
        width: effectiveBorderWidth,
      ),
      borderRadius: effectiveBorderRadius,
      alignment: alignment,
    );
  }
}
