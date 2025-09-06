import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

/// MinimalPaper provides a simple elevated surface for grouping content.
///
/// Matches the API described in the task story and uses design tokens
/// from `UiTokens` for sensible defaults.
class MinimalPaper extends StatelessWidget {
  const MinimalPaper({
    super.key,
    required this.child,
    this.elevation = 1.0,
    this.color,
    this.borderRadius,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.clipBehavior = Clip.none,
  });

  final Widget child;
  final double elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<UiTokens>() ?? UiTokens.standard();

    final effectiveColor = color ?? theme.cardColor;
    final effectivePadding = padding ?? EdgeInsets.all(tokens.spacingTokens.md);
    final effectiveBorderRadius =
        borderRadius ??
        BorderRadius.all(Radius.circular(tokens.radiusTokens.md));

    // Build shadow using elevation tokens and token's shadow color
    final boxShadow = elevation > 0
        ? [
            BoxShadow(
              color: tokens.elevationTokens.lightShadowColor.withOpacity(0.12),
              blurRadius: elevation * 4,
              spreadRadius: elevation * 0.3,
              offset: Offset(0, elevation),
            ),
          ]
        : null;

    return Semantics(
      container: true,
      child: AnimatedContainer(
        duration: tokens.motionTokens.md,
        curve: tokens.motionTokens.standard,
        margin: margin,
        width: width,
        height: height,
        clipBehavior: clipBehavior,
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: effectiveBorderRadius,
          boxShadow: boxShadow,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(padding: effectivePadding, child: child),
        ),
      ),
    );
  }
}
