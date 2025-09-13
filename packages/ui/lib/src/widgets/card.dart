import 'package:flutter/material.dart' hide Card;
import 'package:tokens/tokens.dart' as tokens;

/// A flexible card component with header, body, and footer sections
///
/// The [Card] follows Material Design patterns and provides a clean structure
/// for displaying content with optional header, body, and footer sections.
///
/// Example:
/// ```dart
/// Card(
///   header: CardHeader(title: 'Card Title'),
///   body: Text('Card content goes here'),
///   footer: CardFooter(actions: [Button.primary(child: Text('Action'))]),
/// )
/// ```
class Card extends StatelessWidget {
  /// Optional header widget (typically contains title and actions)
  final Widget? header;

  /// Main body content of the card
  final Widget? body;

  /// Optional footer widget (typically contains actions or additional info)
  final Widget? footer;

  /// The content to display within the card (alternative to header/body/footer)
  final Widget? child;

  /// Card background color
  final Color? backgroundColor;

  /// Whether to show dividers between sections
  final bool showDividers;

  /// Card elevation/shadow
  final double elevation;

  /// The corner radius of the card
  final BorderRadius? borderRadius;

  /// The internal padding of the card content
  final EdgeInsetsGeometry? padding;

  /// The external margin around the card
  final EdgeInsetsGeometry? margin;

  /// Callback function when the card is tapped
  final VoidCallback? onTap;

  /// Callback function when the card is long-pressed
  final VoidCallback? onLongPress;

  /// Whether the card is in a selected state
  final bool selected;

  /// Whether to use an outlined style instead of elevation
  final bool outlined;

  /// Creates a [Card]
  const Card({
    super.key,
    this.header,
    this.body,
    this.footer,
    this.child,
    this.backgroundColor,
    this.showDividers = true,
    this.elevation = 0,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.outlined = false,
  });

  /// Creates a simple card with just child content
  factory Card.simple({
    Key? key,
    required Widget child,
    Color? backgroundColor,
    double elevation = 0,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool selected = false,
  }) =>
      Card(
        key: key,
        child: child,
        backgroundColor: backgroundColor,
        elevation: elevation,
        borderRadius: borderRadius,
        padding: padding,
        margin: margin,
        onTap: onTap,
        onLongPress: onLongPress,
        selected: selected,
      );

  /// Creates an elevated card with shadow
  factory Card.elevated({
    Key? key,
    Widget? header,
    Widget? body,
    Widget? footer,
    Widget? child,
    Color? backgroundColor,
    bool showDividers = true,
    double elevation = 4.0,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool selected = false,
  }) =>
      Card(
        key: key,
        header: header,
        body: body,
        footer: footer,
        child: child,
        backgroundColor: backgroundColor,
        showDividers: showDividers,
        elevation: elevation,
        borderRadius: borderRadius,
        padding: padding,
        margin: margin,
        onTap: onTap,
        onLongPress: onLongPress,
        selected: selected,
        outlined: false,
      );

  /// Creates an outlined card with border
  factory Card.outlined({
    Key? key,
    Widget? header,
    Widget? body,
    Widget? footer,
    Widget? child,
    Color? backgroundColor,
    bool showDividers = true,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool selected = false,
  }) =>
      Card(
        key: key,
        header: header,
        body: body,
        footer: footer,
        child: child,
        backgroundColor: backgroundColor,
        showDividers: showDividers,
        elevation: 0,
        borderRadius: borderRadius,
        padding: padding,
        margin: margin,
        onTap: onTap,
        onLongPress: onLongPress,
        selected: selected,
        outlined: true,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = tokens.Spacing.of(context);
    final radius = tokens.Radius.of(context);

    // Determine effective border radius
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(radius.lg);

    // Determine background color
    final effectiveBackgroundColor = backgroundColor ??
        (selected ? colorScheme.primaryContainer : colorScheme.surface);

    // Determine border for outlined cards
    final borderSide = outlined
        ? BorderSide(
            color: selected ? colorScheme.primary : colorScheme.outline,
            width: 1.0,
          )
        : BorderSide.none;

    // Build card content
    Widget cardContent;

    if (child != null) {
      // Simple card with just child content
      cardContent = Padding(
        padding: padding ?? EdgeInsets.all(spacing.lg),
        child: child!,
      );
    } else {
      // Structured card with header/body/footer
      cardContent = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header section
          if (header != null) ...[
            Padding(
              padding: padding ?? EdgeInsets.fromLTRB(spacing.lg, spacing.lg, spacing.lg, spacing.md),
              child: header!,
            ),
            if (showDividers && body != null)
              Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outline.withValues(alpha: 0.12),
                indent: spacing.lg,
                endIndent: spacing.lg,
              ),
          ],

          // Body section
          if (body != null) ...[
            Padding(
              padding: padding ?? EdgeInsets.fromLTRB(
                spacing.lg,
                header != null ? spacing.md : spacing.lg,
                spacing.lg,
                footer != null ? spacing.md : spacing.lg,
              ),
              child: body!,
            ),
            if (showDividers && footer != null)
              Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outline.withValues(alpha: 0.12),
                indent: spacing.lg,
                endIndent: spacing.lg,
              ),
          ],

          // Footer section
          if (footer != null)
            Padding(
              padding: padding ?? EdgeInsets.fromLTRB(spacing.lg, spacing.md, spacing.lg, spacing.lg),
              child: footer!,
            ),
        ],
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: outlined ? Border.fromBorderSide(borderSide) : null,
        boxShadow: !outlined && elevation > 0
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: elevation * 4,
                  spreadRadius: elevation * 0.3,
                  offset: Offset(0, elevation),
                ),
              ]
            : elevation == 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: effectiveBorderRadius,
          splashColor: onTap != null || onLongPress != null
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          highlightColor: onTap != null || onLongPress != null
              ? colorScheme.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          child: cardContent,
        ),
      ),
    );
  }
}

/// Pre-built header component for Card
class CardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = tokens.Spacing.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: spacing.sm),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: spacing.xs / 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (trailing != null) ...[
            SizedBox(width: spacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Pre-built footer component for Card
class CardFooter extends StatelessWidget {
  final List<Widget> actions;
  final MainAxisAlignment alignment;

  const CardFooter({
    super.key,
    required this.actions,
    this.alignment = MainAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = tokens.Spacing.of(context);

    return Row(
      mainAxisAlignment: alignment,
      children: actions
          .expand((action) => [action, SizedBox(width: spacing.xs)])
          .take(actions.length * 2 - 1)
          .toList(),
    );
  }
}