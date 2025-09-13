import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

/// Position where the tooltip should appear relative to its target
enum TooltipPosition {
  /// Automatically determine the best position
  auto,

  /// Show tooltip above the target
  top,

  /// Show tooltip below the target
  bottom,

  /// Show tooltip to the left of the target
  left,

  /// Show tooltip to the right of the target
  right,
}

/// Visual variant of the tooltip
enum TooltipVariant {
  /// Dark background with light text (default)
  dark,

  /// Light background with dark text
  light,

  /// Inverse colors for special contexts
  inverse,
}

/// A customizable tooltip widget that follows the design system tokens.
///
/// Provides hover and keyboard interactions with configurable positioning,
/// styling, and content. Supports both simple text and rich content.
///
/// Example usage:
/// ```dart
/// CustomTooltip(
///   message: 'This is a helpful tooltip',
///   child: IconButton(
///     onPressed: () {},
///     icon: Icon(Icons.help_outline),
///   ),
/// )
/// ```
class CustomTooltip extends StatefulWidget {
  /// The message to display in the tooltip. Required if [content] is not provided.
  final String? message;

  /// The child widget that will trigger the tooltip when hovered or focused.
  final Widget? child;

  /// The position where the tooltip should appear relative to the child.
  final TooltipPosition position;

  /// The visual variant of the tooltip.
  final TooltipVariant variant;

  /// The delay before showing the tooltip on hover/focus.
  final Duration showDelay;

  /// The delay before hiding the tooltip when hover/focus is lost.
  final Duration hideDelay;

  /// Maximum width of the tooltip content.
  final double? maxWidth;

  /// Custom padding for the tooltip content.
  final EdgeInsets? padding;

  /// Whether to use rich content instead of simple text.
  final bool rich;

  /// Custom content widget. Takes precedence over [message].
  final Widget? content;

  /// Whether the tooltip is disabled.
  final bool disabled;

  /// Custom margin from the target widget.
  final double margin;

  /// Whether to show an arrow pointing to the target.
  final bool showArrow;

  /// Custom text style for the tooltip message.
  final TextStyle? textStyle;

  /// Custom decoration for the tooltip container.
  final Decoration? decoration;

  /// Callback when the tooltip is shown.
  final VoidCallback? onShow;

  /// Callback when the tooltip is hidden.
  final VoidCallback? onHide;

  const CustomTooltip({
    super.key,
    this.message,
    this.child,
    this.position = TooltipPosition.auto,
    this.variant = TooltipVariant.dark,
    this.showDelay = const Duration(milliseconds: 500),
    this.hideDelay = const Duration(milliseconds: 100),
    this.maxWidth = 200.0,
    this.padding,
    this.rich = false,
    this.content,
    this.disabled = false,
    this.margin = 8.0,
    this.showArrow = true,
    this.textStyle,
    this.decoration,
    this.onShow,
    this.onHide,
  }) : assert(
         message != null || content != null,
         'Either message or content must be provided',
       );

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  OverlayEntry? _overlayEntry;
  Timer? _showTimer;
  Timer? _hideTimer;
  bool _isVisible = false;

  @override
  void dispose() {
    _clearTimers();
    _removeOverlay();
    super.dispose();
  }

  void _clearTimers() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _showTimer = null;
    _hideTimer = null;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }

  void _show() {
    if (widget.disabled || _isVisible) return;

    _clearTimers();
    _showTimer = Timer(widget.showDelay, () {
      if (!mounted) return;

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final overlay = Overlay.of(context);
      final targetPosition = renderBox.localToGlobal(Offset.zero);
      final targetSize = renderBox.size;

      _overlayEntry = OverlayEntry(
        builder: (context) => _TooltipOverlay(
          targetPosition: targetPosition,
          targetSize: targetSize,
          tooltip: widget,
        ),
      );

      overlay.insert(_overlayEntry!);
      _isVisible = true;
      widget.onShow?.call();
    });
  }

  void _hide() {
    if (widget.disabled) return;

    _clearTimers();
    _hideTimer = Timer(widget.hideDelay, () {
      if (!mounted) return;

      _removeOverlay();
      widget.onHide?.call();
    });
  }

  void _onTap() {
    if (_isVisible) {
      _hide();
    } else {
      _show();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      return widget.child ?? const SizedBox.shrink();
    }

    return FocusableActionDetector(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<Intent>(
          onInvoke: (_) {
            _hide();
            return null;
          },
        ),
      },
      onShowHoverHighlight: (showing) {
        if (showing) {
          _show();
        } else {
          _hide();
        }
      },
      onShowFocusHighlight: (showing) {
        if (showing) {
          _show();
        } else {
          _hide();
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onTap,
        child: widget.child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  final Offset targetPosition;
  final Size targetSize;
  final CustomTooltip tooltip;

  const _TooltipOverlay({
    required this.targetPosition,
    required this.targetSize,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    // Calculate the best position for the tooltip
    final position = _calculatePosition(screenSize);
    final tooltipPosition = _calculateTooltipPosition(position, screenSize);

    return Positioned(
      left: tooltipPosition.dx,
      top: tooltipPosition.dy,
      child: Material(
        color: Colors.transparent,
        child: _TooltipContent(
          tooltip: tooltip,
          position: position,
        ),
      ),
    );
  }

  TooltipPosition _calculatePosition(Size screenSize) {
    if (tooltip.position != TooltipPosition.auto) {
      return tooltip.position;
    }

    // Auto-determine the best position based on available space
    final spaceTop = targetPosition.dy;
    final spaceBottom =
        screenSize.height - (targetPosition.dy + targetSize.height);
    final spaceLeft = targetPosition.dx;
    final spaceRight =
        screenSize.width - (targetPosition.dx + targetSize.width);

    // Prefer bottom, then top, then right, then left
    if (spaceBottom >= 60) return TooltipPosition.bottom;
    if (spaceTop >= 60) return TooltipPosition.top;
    if (spaceRight >= 100) return TooltipPosition.right;
    if (spaceLeft >= 100) return TooltipPosition.left;

    // Fallback to bottom if no good position is found
    return TooltipPosition.bottom;
  }

  Offset _calculateTooltipPosition(TooltipPosition position, Size screenSize) {
    const tooltipEstimatedHeight = 40.0; // Rough estimate for positioning
    final tooltipEstimatedWidth = tooltip.maxWidth ?? 200.0;

    switch (position) {
      case TooltipPosition.top:
        return Offset(
          (targetPosition.dx + targetSize.width / 2 - tooltipEstimatedWidth / 2)
              .clamp(8.0, screenSize.width - tooltipEstimatedWidth - 8.0),
          targetPosition.dy - tooltipEstimatedHeight - tooltip.margin,
        );

      case TooltipPosition.bottom:
        return Offset(
          (targetPosition.dx + targetSize.width / 2 - tooltipEstimatedWidth / 2)
              .clamp(8.0, screenSize.width - tooltipEstimatedWidth - 8.0),
          targetPosition.dy + targetSize.height + tooltip.margin,
        );

      case TooltipPosition.left:
        return Offset(
          targetPosition.dx - tooltipEstimatedWidth - tooltip.margin,
          (targetPosition.dy +
                  targetSize.height / 2 -
                  tooltipEstimatedHeight / 2)
              .clamp(8.0, screenSize.height - tooltipEstimatedHeight - 8.0),
        );

      case TooltipPosition.right:
        return Offset(
          targetPosition.dx + targetSize.width + tooltip.margin,
          (targetPosition.dy +
                  targetSize.height / 2 -
                  tooltipEstimatedHeight / 2)
              .clamp(8.0, screenSize.height - tooltipEstimatedHeight - 8.0),
        );

      case TooltipPosition.auto:
        // This should not happen as auto is resolved earlier
        return _calculateTooltipPosition(TooltipPosition.bottom, screenSize);
    }
  }
}

class _TooltipContent extends StatelessWidget {
  final CustomTooltip tooltip;
  final TooltipPosition position;

  const _TooltipContent({
    required this.tooltip,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine colors based on variant
    Color backgroundColor;
    Color textColor;
    Color shadowColor;

    switch (tooltip.variant) {
      case TooltipVariant.dark:
        backgroundColor = Colors.grey.shade800;
        textColor = Colors.grey.shade50;
        shadowColor = Colors.black;
        break;

      case TooltipVariant.light:
        backgroundColor = Colors.grey.shade50;
        textColor = Colors.grey.shade800;
        shadowColor = Colors.grey.shade400;
        break;

      case TooltipVariant.inverse:
        backgroundColor = theme.colorScheme.primary;
        textColor = theme.colorScheme.onPrimary;
        shadowColor = theme.colorScheme.primary.withValues(alpha: 0.3);
        break;
    }

    // Default padding
    final effectivePadding = tooltip.padding ??
        const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        );

    // Default text style
    final effectiveTextStyle = tooltip.textStyle ??
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
          height: 1.3,
        );

    // Default decoration
    final effectiveDecoration = tooltip.decoration ??
        BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.2),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        );

    Widget content = tooltip.content ??
        Text(
          tooltip.message!,
          style: effectiveTextStyle,
          textAlign: TextAlign.center,
        );

    Widget tooltipWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      constraints: BoxConstraints(maxWidth: tooltip.maxWidth ?? 200.0),
      padding: effectivePadding,
      decoration: effectiveDecoration,
      child: DefaultTextStyle(style: effectiveTextStyle, child: content),
    );

    // Add arrow if requested
    if (tooltip.showArrow) {
      tooltipWidget = _TooltipWithArrow(
        position: position,
        backgroundColor: backgroundColor,
        child: tooltipWidget,
      );
    }

    return tooltipWidget;
  }
}

class _TooltipWithArrow extends StatelessWidget {
  final TooltipPosition position;
  final Color backgroundColor;
  final Widget child;

  const _TooltipWithArrow({
    required this.position,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const arrowSize = 6.0;

    Widget arrow = CustomPaint(
      size: const Size(arrowSize * 2, arrowSize * 2),
      painter: _ArrowPainter(color: backgroundColor, position: position),
    );

    switch (position) {
      case TooltipPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            Transform.translate(offset: const Offset(0, -1), child: arrow),
          ],
        );

      case TooltipPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(offset: const Offset(0, 1), child: arrow),
            child,
          ],
        );

      case TooltipPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            Transform.translate(offset: const Offset(-1, 0), child: arrow),
          ],
        );

      case TooltipPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(offset: const Offset(1, 0), child: arrow),
            child,
          ],
        );

      case TooltipPosition.auto:
        return child; // Fallback without arrow
    }
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final TooltipPosition position;

  const _ArrowPainter({required this.color, required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    const arrowSize = 6.0;

    switch (position) {
      case TooltipPosition.top:
        // Arrow pointing down
        path.moveTo(center.dx, center.dy + arrowSize);
        path.lineTo(center.dx - arrowSize, center.dy - arrowSize);
        path.lineTo(center.dx + arrowSize, center.dy - arrowSize);
        break;

      case TooltipPosition.bottom:
        // Arrow pointing up
        path.moveTo(center.dx, center.dy - arrowSize);
        path.lineTo(center.dx - arrowSize, center.dy + arrowSize);
        path.lineTo(center.dx + arrowSize, center.dy + arrowSize);
        break;

      case TooltipPosition.left:
        // Arrow pointing right
        path.moveTo(center.dx + arrowSize, center.dy);
        path.lineTo(center.dx - arrowSize, center.dy - arrowSize);
        path.lineTo(center.dx - arrowSize, center.dy + arrowSize);
        break;

      case TooltipPosition.right:
        // Arrow pointing left
        path.moveTo(center.dx - arrowSize, center.dy);
        path.lineTo(center.dx + arrowSize, center.dy - arrowSize);
        path.lineTo(center.dx + arrowSize, center.dy + arrowSize);
        break;

      case TooltipPosition.auto:
        return; // No arrow for auto
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.position != position;
  }
}

/// Extension to add tooltip functionality to any widget
extension TooltipExtension on Widget {
  /// Wrap this widget with a tooltip
  Widget tooltip(
    String message, {
    TooltipPosition position = TooltipPosition.auto,
    TooltipVariant variant = TooltipVariant.dark,
    Duration showDelay = const Duration(milliseconds: 500),
    Duration hideDelay = const Duration(milliseconds: 100),
    double? maxWidth = 200.0,
    EdgeInsets? padding,
    bool disabled = false,
    double margin = 8.0,
    bool showArrow = true,
    TextStyle? textStyle,
    Decoration? decoration,
    VoidCallback? onShow,
    VoidCallback? onHide,
  }) {
    return CustomTooltip(
      message: message,
      position: position,
      variant: variant,
      showDelay: showDelay,
      hideDelay: hideDelay,
      maxWidth: maxWidth,
      padding: padding,
      disabled: disabled,
      margin: margin,
      showArrow: showArrow,
      textStyle: textStyle,
      decoration: decoration,
      onShow: onShow,
      onHide: onHide,
      child: this,
    );
  }

  /// Wrap this widget with a rich content tooltip
  Widget tooltipRich(
    Widget content, {
    TooltipPosition position = TooltipPosition.auto,
    TooltipVariant variant = TooltipVariant.dark,
    Duration showDelay = const Duration(milliseconds: 500),
    Duration hideDelay = const Duration(milliseconds: 100),
    double? maxWidth = 200.0,
    EdgeInsets? padding,
    bool disabled = false,
    double margin = 8.0,
    bool showArrow = true,
    Decoration? decoration,
    VoidCallback? onShow,
    VoidCallback? onHide,
  }) {
    return CustomTooltip(
      content: content,
      rich: true,
      position: position,
      variant: variant,
      showDelay: showDelay,
      hideDelay: hideDelay,
      maxWidth: maxWidth,
      padding: padding,
      disabled: disabled,
      margin: margin,
      showArrow: showArrow,
      decoration: decoration,
      onShow: onShow,
      onHide: onHide,
      child: this,
    );
  }
}
