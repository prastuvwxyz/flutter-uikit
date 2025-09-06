import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// MinimalModal: simple, token-friendly modal dialog widget.
class MinimalModal extends StatefulWidget {
  final Widget? child;
  final bool isVisible;
  final VoidCallback? onDismiss;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final Alignment alignment;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxConstraints? constraints;
  final ShapeBorder? shape;
  final double elevation;
  final Color? backgroundColor;
  final Duration animationDuration;
  final Widget Function(BuildContext, Animation<double>, Widget)?
  transitionBuilder;

  const MinimalModal({
    super.key,
    this.child,
    this.isVisible = false,
    this.onDismiss,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(24.0),
    this.constraints,
    this.shape,
    this.elevation = 8.0,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 300),
    this.transitionBuilder,
  });

  @override
  State<MinimalModal> createState() => _MinimalModalState();
}

class _MinimalModalState extends State<MinimalModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    if (widget.isVisible) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant MinimalModal oldWidget) {
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
    super.dispose();
  }

  void _handleDismiss() {
    if (widget.onDismiss != null) widget.onDismiss!();
  }

  @override
  Widget build(BuildContext context) {
    // If not visible and animation is dismissed, render nothing to avoid blocking taps
    if (!widget.isVisible && _controller.status == AnimationStatus.dismissed) {
      return const SizedBox.shrink();
    }

    final Color barrier = widget.barrierColor ?? Colors.black54;

    Widget modal = Align(
      alignment: widget.alignment,
      child: Container(
        margin: widget.margin,
        constraints: widget.constraints,
        padding: widget.padding,
        decoration: ShapeDecoration(
          color:
              widget.backgroundColor ?? Theme.of(context).dialogBackgroundColor,
          shape:
              widget.shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          shadows: [
            BoxShadow(color: Colors.black26, blurRadius: widget.elevation),
          ],
        ),
        child: widget.child ?? const SizedBox.shrink(),
      ),
    );

    if (widget.transitionBuilder != null) {
      modal = widget.transitionBuilder!(context, _animation, modal);
    } else {
      modal = FadeTransition(
        opacity: _animation,
        child: ScaleTransition(scale: _animation, child: modal),
      );
    }

    // Focus scope to trap focus inside modal when visible
    return Semantics(
      container: true,
      explicitChildNodes: true,
      namesRoute: true,
      label: 'Dialog',
      child: Stack(
        children: [
          // barrier
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.barrierDismissible ? _handleDismiss : null,
              behavior: HitTestBehavior.opaque,
              child: FadeTransition(
                opacity: _animation,
                child: Container(color: barrier),
              ),
            ),
          ),
          // modal content
          Positioned.fill(
            child: FocusScope(
              canRequestFocus: widget.isVisible,
              child: Focus(
                autofocus: widget.isVisible,
                onKey: (node, event) {
                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.escape) {
                      if (widget.barrierDismissible) {
                        _handleDismiss();
                        return KeyEventResult.handled;
                      }
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: modal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
