import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../internal/token_adapters.dart';
import '../internal/a11y.dart';

/// Modal size variants
enum ModalSize {
  /// Small modal
  sm,
  /// Medium modal (default)
  md,
  /// Large modal
  lg,
  /// Extra large modal
  xl,
  /// Full screen modal
  fullscreen,
}

/// Modal animation types
enum ModalAnimationType {
  /// Fade and scale animation (default)
  fadeScale,
  /// Slide from bottom
  slideUp,
  /// Slide from top
  slideDown,
  /// Slide from left
  slideLeft,
  /// Slide from right
  slideRight,
  /// No animation
  none,
}

/// Extension for modal size dimensions
extension ModalSizeExtension on ModalSize {
  /// Get the maximum width for this modal size
  double get maxWidth {
    switch (this) {
      case ModalSize.sm:
        return 400;
      case ModalSize.md:
        return 600;
      case ModalSize.lg:
        return 800;
      case ModalSize.xl:
        return 1200;
      case ModalSize.fullscreen:
        return double.infinity;
    }
  }

  /// Whether this modal should be fullscreen
  bool get isFullscreen => this == ModalSize.fullscreen;
}

/// A flexible modal overlay component with customizable animations and behavior
class Modal extends StatefulWidget {
  /// Whether the modal is currently visible
  final bool isVisible;

  /// The content to display in the modal
  final Widget? child;

  /// Callback when the modal should be dismissed
  final VoidCallback? onDismiss;

  /// Whether the modal can be dismissed by tapping outside
  final bool barrierDismissible;

  /// Custom barrier color (defaults to semi-transparent black)
  final Color? barrierColor;

  /// Accessibility label for the barrier
  final String? barrierLabel;

  /// Alignment of the modal on screen
  final Alignment alignment;

  /// Size of the modal
  final ModalSize size;

  /// Animation type for showing/hiding
  final ModalAnimationType animationType;

  /// Duration of the animation
  final Duration animationDuration;

  /// Custom background color for the modal
  final Color? backgroundColor;

  /// Custom shape for the modal
  final ShapeBorder? shape;

  /// Elevation of the modal
  final double elevation;

  /// Padding inside the modal
  final EdgeInsetsGeometry? padding;

  /// Margin around the modal
  final EdgeInsetsGeometry? margin;

  /// Additional constraints for the modal
  final BoxConstraints? constraints;

  /// Whether to use safe area padding
  final bool useSafeArea;

  /// Custom transition builder for animations
  final Widget Function(BuildContext, Animation<double>, Widget)? transitionBuilder;

  const Modal({
    super.key,
    required this.isVisible,
    this.child,
    this.onDismiss,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.alignment = Alignment.center,
    this.size = ModalSize.md,
    this.animationType = ModalAnimationType.fadeScale,
    this.animationDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.shape,
    this.elevation = 24.0,
    this.padding,
    this.margin,
    this.constraints,
    this.useSafeArea = true,
    this.transitionBuilder,
  });

  /// Factory for bottom sheet style modal
  factory Modal.bottomSheet({
    Key? key,
    required bool isVisible,
    Widget? child,
    VoidCallback? onDismiss,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    ModalSize size = ModalSize.md,
    Duration animationDuration = const Duration(milliseconds: 300),
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool useSafeArea = true,
  }) {
    return Modal(
      key: key,
      isVisible: isVisible,
      child: child,
      onDismiss: onDismiss,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      alignment: Alignment.bottomCenter,
      size: size,
      animationType: ModalAnimationType.slideUp,
      animationDuration: animationDuration,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: padding,
      margin: margin,
      useSafeArea: useSafeArea,
    );
  }

  /// Factory for fullscreen modal
  factory Modal.fullscreen({
    Key? key,
    required bool isVisible,
    Widget? child,
    VoidCallback? onDismiss,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    ModalAnimationType animationType = ModalAnimationType.slideUp,
    Duration animationDuration = const Duration(milliseconds: 400),
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    bool useSafeArea = true,
  }) {
    return Modal(
      key: key,
      isVisible: isVisible,
      child: child,
      onDismiss: onDismiss,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      alignment: Alignment.center,
      size: ModalSize.fullscreen,
      animationType: animationType,
      animationDuration: animationDuration,
      backgroundColor: backgroundColor,
      shape: null,
      elevation: 0,
      padding: padding,
      margin: EdgeInsets.zero,
      useSafeArea: useSafeArea,
    );
  }

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final FocusScopeNode _modalFocusScope = FocusScopeNode();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
      reverseCurve: TokenAdapters.curveFromTokens(TokenCurve.easeIn),
    );

    if (widget.isVisible) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant Modal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }

    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _modalFocusScope.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    if (widget.onDismiss != null) {
      widget.onDismiss!();
    }
  }

  /// Build the modal transition based on animation type
  Widget _buildTransition(Widget child) {
    if (widget.transitionBuilder != null) {
      return widget.transitionBuilder!(context, _animation, child);
    }

    switch (widget.animationType) {
      case ModalAnimationType.fadeScale:
        return FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(_animation),
            child: child,
          ),
        );

      case ModalAnimationType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(_animation),
          child: child,
        );

      case ModalAnimationType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(_animation),
          child: child,
        );

      case ModalAnimationType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(_animation),
          child: child,
        );

      case ModalAnimationType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(_animation),
          child: child,
        );

      case ModalAnimationType.none:
        return child;
    }
  }

  /// Build the modal container
  Widget _buildModalContent() {
    final effectiveMargin = widget.margin ??
        (widget.size.isFullscreen
            ? EdgeInsets.zero
            : context.padding(all: TokenSize.lg));

    final effectivePadding = widget.padding ??
        (widget.size.isFullscreen
            ? EdgeInsets.zero
            : context.padding(all: TokenSize.lg));

    final effectiveConstraints = widget.constraints ??
        BoxConstraints(
          maxWidth: widget.size.maxWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        );

    Widget modalContent = Container(
      margin: effectiveMargin,
      padding: effectivePadding,
      constraints: widget.size.isFullscreen ? null : effectiveConstraints,
      decoration: ShapeDecoration(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
        shape: widget.shape ??
            RoundedRectangleBorder(
              borderRadius: context.borderRadius(all: TokenRadiusSize.lg),
            ),
        shadows: widget.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: widget.elevation,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: widget.child ?? const SizedBox.shrink(),
    );

    if (widget.useSafeArea && !widget.size.isFullscreen) {
      modalContent = SafeArea(child: modalContent);
    }

    return Align(
      alignment: widget.alignment,
      child: modalContent,
    );
  }

  /// Handle keyboard events
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.escape:
        if (widget.barrierDismissible) {
          _handleDismiss();
          return KeyEventResult.handled;
        }
        break;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    // If not visible and animation is dismissed, render nothing
    if (!widget.isVisible && _controller.status == AnimationStatus.dismissed) {
      return const SizedBox.shrink();
    }

    final effectiveBarrierColor = widget.barrierColor ??
        Colors.black.withValues(alpha: 0.54);

    return A11yFocusableWidget(
      focusNode: _modalFocusScope,
      autofocus: widget.isVisible,
      semanticLabel: widget.barrierLabel ?? 'Modal dialog',
      isContainer: true,
      onKey: (node, event) => _handleKeyEvent(event),
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        namesRoute: true,
        label: widget.barrierLabel ?? 'Modal dialog',
        child: Stack(
          children: [
            // Barrier
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.barrierDismissible ? _handleDismiss : null,
                behavior: HitTestBehavior.opaque,
                child: FadeTransition(
                  opacity: _animation,
                  child: Container(
                    color: effectiveBarrierColor,
                  ),
                ),
              ),
            ),
            // Modal content
            Positioned.fill(
              child: GestureDetector(
                onTap: () {}, // Prevent barrier tap when touching modal
                behavior: HitTestBehavior.deferToChild,
                child: _buildTransition(_buildModalContent()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Utility class for common modal operations
class ModalUtils {
  /// Show a modal using an overlay
  static OverlayEntry? showModal({
    required BuildContext context,
    required Widget child,
    VoidCallback? onDismiss,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    Alignment alignment = Alignment.center,
    ModalSize size = ModalSize.md,
    ModalAnimationType animationType = ModalAnimationType.fadeScale,
    Duration animationDuration = const Duration(milliseconds: 300),
    Color? backgroundColor,
    ShapeBorder? shape,
    double elevation = 24.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    bool useSafeArea = true,
  }) {
    late OverlayEntry overlayEntry;
    bool isVisible = true;

    void dismissModal() {
      if (isVisible) {
        isVisible = false;
        overlayEntry.markNeedsBuild();

        Future.delayed(animationDuration, () {
          overlayEntry.remove();
          if (onDismiss != null) {
            onDismiss();
          }
        });
      }
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Modal(
        isVisible: isVisible,
        child: child,
        onDismiss: dismissModal,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        alignment: alignment,
        size: size,
        animationType: animationType,
        animationDuration: animationDuration,
        backgroundColor: backgroundColor,
        shape: shape,
        elevation: elevation,
        padding: padding,
        margin: margin,
        constraints: constraints,
        useSafeArea: useSafeArea,
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    return overlayEntry;
  }

  /// Show a bottom sheet modal
  static OverlayEntry? showBottomSheet({
    required BuildContext context,
    required Widget child,
    VoidCallback? onDismiss,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    ModalSize size = ModalSize.md,
    Duration animationDuration = const Duration(milliseconds: 300),
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool useSafeArea = true,
  }) {
    return showModal(
      context: context,
      child: child,
      onDismiss: onDismiss,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      alignment: Alignment.bottomCenter,
      size: size,
      animationType: ModalAnimationType.slideUp,
      animationDuration: animationDuration,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: padding,
      margin: margin,
      useSafeArea: useSafeArea,
    );
  }
}