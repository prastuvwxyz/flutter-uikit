import 'package:flutter/material.dart';
import 'package:tokens/tokens.dart' as tokens;

/// Paper provides a simple elevated surface for grouping content.
///
/// Uses design tokens for sensible defaults and provides Material Design elevation.
class Paper extends StatelessWidget {
  const Paper({
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
    final spacing = tokens.Spacing.of(context);
    final radius = tokens.Radius.of(context);

    final effectiveColor = color ?? theme.colorScheme.surface;
    final effectivePadding = padding ?? EdgeInsets.all(spacing.md);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(radius.md);

    // Build shadow using elevation
    final boxShadow = elevation > 0
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: elevation * 4,
              spreadRadius: elevation * 0.3,
              offset: Offset(0, elevation),
            ),
          ]
        : null;

    return Semantics(
      container: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
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