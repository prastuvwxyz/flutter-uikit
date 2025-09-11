import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';

/// MinimalBackdrop
///
/// A lightweight backdrop overlay that follows the UIK-153 spec.
class MinimalBackdrop extends StatefulWidget {
  final bool isVisible;
  final Widget? child;
  final VoidCallback? onDismiss;
  final bool barrierDismissible;
  final Color barrierColor;
  final String? barrierLabel;
  final Duration animationDuration;
  final Curve animationCurve;
  final Alignment alignment;
  final bool blurEffect;
  final double blurSigma;

  const MinimalBackdrop({
    Key? key,
    this.isVisible = false,
    this.child,
    this.onDismiss,
    this.barrierDismissible = true,
    this.barrierColor = const Color(0x80000000), // Colors.black54
    this.barrierLabel,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.alignment = Alignment.center,
    this.blurEffect = false,
    this.blurSigma = 5.0,
  }) : super(key: key);

  @override
  State<MinimalBackdrop> createState() => _MinimalBackdropState();
}

class _MinimalBackdropState extends State<MinimalBackdrop>
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
  void didUpdateWidget(covariant MinimalBackdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    if (widget.isVisible &&
        !_controller.isAnimating &&
        _controller.value == 0) {
      _controller.forward();
      _announceShow();
    } else if (!widget.isVisible &&
        !_controller.isAnimating &&
        _controller.value == 1) {
      _controller.reverse();
      _announceHide();
    }
  }

  void _announceShow() {
    // Optional accessibility announcement; use SemanticsService on supported platforms.
    try {
      SemanticsService.announce('Backdrop shown', Directionality.of(context));
    } catch (_) {
      // ignore if not available on platform
    }
  }

  void _announceHide() {
    try {
      SemanticsService.announce('Backdrop hidden', Directionality.of(context));
    } catch (_) {
      // ignore
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
    // Keep widget mounted even when hidden to preserve state, but make it invisible
    return IgnorePointer(
      ignoring: !_controller.isAnimating && _controller.value == 0,
      child: AnimatedBuilder(
        animation: _opacity,
        builder: (context, child) {
          return Opacity(opacity: _opacity.value, child: child);
        },
        child: Stack(
          children: [
            // Barrier
            Semantics(
              container: true,
              label: widget.barrierLabel,
              explicitChildNodes: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleTapBarrier,
                child: Container(
                  color: widget.barrierColor.withOpacity(
                    widget.barrierColor.opacity,
                  ),
                ),
              ),
            ),

            // Optional blur + content
            Align(
              alignment: widget.alignment,
              child: widget.blurEffect
                  ? BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: widget.blurSigma,
                        sigmaY: widget.blurSigma,
                      ),
                      child: _contentWrapper(),
                    )
                  : _contentWrapper(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentWrapper() {
    return FocusScope(
      canRequestFocus: widget.isVisible,
      child: Focus(
        autofocus: widget.isVisible,
        onKey: (node, event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape) {
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
