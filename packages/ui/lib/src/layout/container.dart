import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart' hide Container;
import 'package:tokens/tokens.dart' as tokens;

/// Responsive container max width breakpoints
enum ContainerMaxWidth {
  xs, // 444px
  sm, // 600px
  md, // 900px
  lg, // 1200px
  xl, // 1536px
}

/// Extension to get pixel values for breakpoints
extension ContainerMaxWidthExtension on ContainerMaxWidth {
  double get pixelValue {
    switch (this) {
      case ContainerMaxWidth.xs:
        return 444.0;
      case ContainerMaxWidth.sm:
        return 600.0;
      case ContainerMaxWidth.md:
        return 900.0;
      case ContainerMaxWidth.lg:
        return 1200.0;
      case ContainerMaxWidth.xl:
        return 1536.0;
    }
  }
}

/// A flexible container component with customizable styling options.
///
/// Container provides padding, margin, borders, background and shadow styling.
/// It uses design tokens for consistent theming and supports RTL layouts.
class Container extends StatelessWidget {
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

  /// Responsive max width breakpoint
  /// When set, container will have max width based on breakpoint values
  final ContainerMaxWidth? maxWidth;

  /// Whether to use fixed breakpoint behavior
  /// When true, container width matches breakpoint min-width exactly
  final bool fixed;

  /// Whether to center the container horizontally when maxWidth is used
  final bool centerWhenConstrained;

  /// Creates a Container.
  ///
  /// All parameters are optional to allow for flexible usage.
  /// Use [maxWidth] for responsive container sizing.
  const Container({
    super.key,
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
    this.maxWidth,
    this.fixed = false,
    this.centerWhenConstrained = true,
  });

  @override
  Widget build(BuildContext context) {
    // Apply responsive maxWidth if specified
    Widget result = maxWidth != null
        ? _buildResponsiveContainer(context)
        : _buildContainer(context);

    // Apply margin if specified
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

  /// Builds a responsive container with maxWidth constraints
  Widget _buildResponsiveContainer(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidthValue = maxWidth!.pixelValue;
        final availableWidth = constraints.maxWidth;

        // Determine effective width
        double effectiveWidth;
        if (fixed) {
          // Fixed mode: use exact breakpoint width
          effectiveWidth = maxWidthValue;
        } else {
          // Fluid mode: use min of available width and max width
          effectiveWidth = availableWidth > maxWidthValue
              ? maxWidthValue
              : availableWidth;
        }

        // Build the container with effective width
        final container = _buildContainer(
          context,
          overrideWidth: effectiveWidth,
        );

        // Center the container if constrained and centering is enabled
        if (centerWhenConstrained && availableWidth > maxWidthValue) {
          return Center(child: container);
        }

        return container;
      },
    );
  }

  Widget _buildContainer(BuildContext context, {double? overrideWidth}) {
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

    return flutter.Container(
      width: overrideWidth ?? width,
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
  factory Container.card({
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
    return Container(
      key: key,
      child: child,
      padding: padding ?? const EdgeInsets.all(16.0),
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      boxShadow:
          boxShadow ??
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

  /// Creates a bordered container with predefined styling
  factory Container.bordered({
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
    final borderValue = Border.all(
      color: borderColor ?? Colors.grey.shade300,
      width: borderWidth ?? 1.0,
    );

    return Container(
      key: key,
      child: child,
      padding: padding ?? const EdgeInsets.all(16.0),
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      backgroundColor: backgroundColor,
      border: borderValue,
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      alignment: alignment,
    );
  }
}

/// A page container component that provides title, actions, and content layout.
///
/// PageContainer is designed for full-page layouts with a header section
/// containing a title and optional action buttons, followed by the main content.
class PageContainer extends StatelessWidget {
  /// The main content to display in the page
  final Widget child;

  /// The page title displayed in the header
  final String? title;

  /// Optional action buttons displayed in the header
  final List<Widget>? actions;

  /// Internal padding applied around the content
  final EdgeInsetsGeometry? padding;

  /// External margin applied around the page container
  final EdgeInsetsGeometry? margin;

  /// Background color for the page container
  final Color? backgroundColor;

  /// Creates a PageContainer.
  ///
  /// The [child] parameter is required and represents the main page content.
  const PageContainer({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.padding,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = tokens.Spacing.of(context);

    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(spacing.lg),
      backgroundColor:
          backgroundColor ?? theme.colorScheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and actions
          if (title != null || actions != null)
            flutter.Container(
              padding: EdgeInsets.only(bottom: spacing.lg),
              child: Row(
                children: [
                  // Title
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),

                  // Actions
                  if (actions != null && actions!.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!
                          .expand(
                            (action) => [action, SizedBox(width: spacing.sm)],
                          )
                          .take(actions!.length * 2 - 1)
                          .toList(),
                    ),
                ],
              ),
            ),

          // Main content
          Expanded(child: child),
        ],
      ),
    );
  }
}
