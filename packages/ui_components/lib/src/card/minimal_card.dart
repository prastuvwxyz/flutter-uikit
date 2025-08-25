import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

/// A flexible container with elevation and interaction support for grouping related content.
///
/// The [MinimalCard] can be used to group related content with optional
/// interaction support. It supports both elevated and outlined variants,
/// selection state, and customizable appearance.
///
/// Example:
/// ```dart
/// MinimalCard(
///   onTap: () => print('Card tapped'),
///   child: Text('Card Content'),
/// )
/// ```
class MinimalCard extends StatefulWidget {
  /// The content to display within the card.
  final Widget child;

  /// The depth of the card's shadow.
  final double elevation;

  /// The internal padding of the card content.
  final EdgeInsets? padding;

  /// The external margin around the card.
  final EdgeInsets? margin;

  /// The corner radius of the card.
  final BorderRadius? borderRadius;

  /// The background color of the card.
  /// If null, it will default to the theme's surface color.
  final Color? backgroundColor;

  /// Callback function when the card is tapped.
  /// If provided, makes the card interactive.
  final VoidCallback? onTap;

  /// Callback function when the card is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether the card is in a selected state.
  /// When true, adds a visual indication using the primary color.
  final bool selected;

  /// Whether to use an outlined style instead of elevation.
  /// When true, shows a border instead of a shadow.
  final bool outlined;

  /// Creates a [MinimalCard].
  ///
  /// The [child] parameter is required and represents the content of the card.
  const MinimalCard({
    Key? key,
    required this.child,
    this.elevation = 1.0,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.outlined = false,
  }) : super(key: key);

  @override
  State<MinimalCard> createState() => _MinimalCardState();
}

class _MinimalCardState extends State<MinimalCard> {
  bool _isHovering = false;
  bool _isPressed = false;

  // Calculate effective elevation based on state and props
  double get _effectiveElevation {
    if (widget.outlined) return 0;

    double baseElevation = widget.elevation;

    if (_isPressed) {
      return 2.0; // Medium elevation
    } else if (_isHovering &&
        (widget.onTap != null || widget.onLongPress != null)) {
      return baseElevation * 1.5;
    }

    return baseElevation;
  }

  // Determine whether the card is interactive
  bool get _isInteractive => widget.onTap != null || widget.onLongPress != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tokens = theme.extension<UiTokens>() ?? UiTokens.standard();

    // Determine card colors based on state
    final backgroundColor =
        widget.backgroundColor ??
        (widget.selected ? colorScheme.primaryContainer : theme.cardColor);

    final borderSide = widget.outlined
        ? BorderSide(
            color: widget.selected ? colorScheme.primary : colorScheme.outline,
            width: 1.0,
          )
        : BorderSide.none;

    // Determine cursor type for interactive cards on web/desktop
    final mouseCursor = _isInteractive
        ? SystemMouseCursors.click
        : MouseCursor.defer;

    // Get padding and border radius from tokens if not provided
    final effectivePadding =
        widget.padding ?? EdgeInsets.all(tokens.spacingTokens.lg);
    final effectiveBorderRadius =
        widget.borderRadius ??
        BorderRadius.all(Radius.circular(tokens.radiusTokens.lg));

    return Semantics(
      container: true,
      button: _isInteractive,
      enabled: _isInteractive,
      selected: widget.selected,
      child: MouseRegion(
        cursor: mouseCursor,
        onEnter: (_) =>
            _isInteractive ? setState(() => _isHovering = true) : null,
        onExit: (_) =>
            _isInteractive ? setState(() => _isHovering = false) : null,
        child: GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onTapDown: (_) =>
              _isInteractive ? setState(() => _isPressed = true) : null,
          onTapUp: (_) =>
              _isInteractive ? setState(() => _isPressed = false) : null,
          onTapCancel: () =>
              _isInteractive ? setState(() => _isPressed = false) : null,
          child: AnimatedContainer(
            duration: tokens.motionTokens.md,
            curve: tokens.motionTokens.standard,
            margin: widget.margin,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: effectiveBorderRadius,
              border: widget.outlined
                  ? Border.fromBorderSide(borderSide)
                  : null,
              boxShadow: !widget.outlined
                  ? [
                      BoxShadow(
                        color: tokens.elevationTokens.lightShadowColor
                            .withOpacity(0.1),
                        blurRadius: _effectiveElevation * 4,
                        spreadRadius: _effectiveElevation * 0.3,
                        offset: Offset(0, _effectiveElevation),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                splashColor: _isInteractive
                    ? tokens.colorTokens.primary.shade500.withOpacity(0.1)
                    : Colors.transparent,
                highlightColor: _isInteractive
                    ? tokens.colorTokens.primary.shade500.withOpacity(0.05)
                    : Colors.transparent,
                borderRadius: effectiveBorderRadius,
                onTap: widget.onTap,
                onLongPress: widget.onLongPress,
                child: Padding(padding: effectivePadding, child: widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
