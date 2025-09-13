import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';

/// A backdrop overlay component that creates a modal overlay with optional blur effect.
///
/// The Backdrop component creates a full-screen overlay that can be used to display
/// modal content, dialogs, or other overlays. It supports custom positioning,
/// blur effects, and proper accessibility handling.
///
/// Example:
/// ```dart
/// Backdrop(
///   isVisible: true,
///   onDismiss: () => setState(() => showModal = false),
///   child: AlertDialog(
///     title: Text('Modal Dialog'),
///     content: Text('This is a modal dialog.'),
///   ),
/// )
/// ```
class Backdrop extends StatefulWidget {
  /// Whether the backdrop should be visible
  final bool isVisible;

  /// The content to display on top of the backdrop
  final Widget? child;

  /// Callback when the backdrop should be dismissed
  final VoidCallback? onDismiss;

  /// Whether tapping the backdrop should dismiss it
  final bool barrierDismissible;

  /// The color of the backdrop barrier
  final Color? barrierColor;

  /// Semantic label for the backdrop barrier
  final String? barrierLabel;

  /// Duration for show/hide animations
  final Duration animationDuration;

  /// Animation curve for show/hide transitions
  final Curve animationCurve;

  /// Alignment of the child content
  final Alignment alignment;

  /// Whether to apply a blur effect to the backdrop
  final bool blurEffect;

  /// Sigma value for the blur effect (higher = more blur)
  final double blurSigma;

  /// Creates a Backdrop component.
  ///
  /// The [isVisible] parameter controls whether the backdrop is shown.
  /// The [onDismiss] callback is triggered when the backdrop should be dismissed.
  /// The [barrierDismissible] parameter controls whether tapping outside dismisses the backdrop.
  const Backdrop({
    super.key,
    this.isVisible = false,
    this.child,
    this.onDismiss,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.alignment = Alignment.center,
    this.blurEffect = false,
    this.blurSigma = 5.0,
  });

  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    if (widget.isVisible) {
      _controller.value = 1.0;
      WidgetsBinding.instance.addPostFrameCallback((_) => _announceShow());
    }
  }

  @override
  void didUpdateWidget(covariant Backdrop oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }

    if (widget.isVisible && !_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
      _announceShow();
    } else if (!widget.isVisible && !_controller.isAnimating && _controller.value == 1) {
      _controller.reverse();
      _announceHide();
    }
  }

  void _announceShow() {
    try {
      if (context.mounted) {
        SemanticsService.announce('Backdrop shown', Directionality.of(context));
      }
    } catch (_) {
      // Ignore if not available on platform
    }
  }

  void _announceHide() {
    try {
      if (context.mounted) {
        SemanticsService.announce('Backdrop hidden', Directionality.of(context));
      }
    } catch (_) {
      // Ignore if not available on platform
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapBarrier() {
    if (widget.barrierDismissible) {
      widget.onDismiss?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBarrierColor = widget.barrierColor ??
      colorScheme.scrim.withValues(alpha: 0.54);

    // Keep widget mounted even when hidden to preserve state, but make it invisible
    return IgnorePointer(
      ignoring: !_controller.isAnimating && _controller.value == 0,
      child: AnimatedBuilder(
        animation: _opacity,
        builder: (context, child) {
          return Opacity(
            opacity: _opacity.value,
            child: child,
          );
        },
        child: Stack(
          children: [
            // Backdrop barrier
            Semantics(
              container: true,
              label: widget.barrierLabel ?? 'Modal backdrop',
              explicitChildNodes: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleTapBarrier,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: effectiveBarrierColor,
                ),
              ),
            ),

            // Content with optional blur effect
            Align(
              alignment: widget.alignment,
              child: widget.blurEffect
                  ? BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: widget.blurSigma,
                        sigmaY: widget.blurSigma,
                      ),
                      child: _buildContent(),
                    )
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FocusScope(
      canRequestFocus: widget.isVisible,
      child: Focus(
        autofocus: widget.isVisible,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape &&
                widget.barrierDismissible) {
              widget.onDismiss?.call();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: widget.child ?? const SizedBox.shrink(),
      ),
    );
  }
}