import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'transition_type.dart';

typedef CustomTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Widget child,
    );

class MinimalTransition extends StatefulWidget {
  final Widget child;
  final TransitionType type;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final bool isVisible;
  final VoidCallback? onComplete;
  final Duration? reverseDuration;
  final Curve? reverseCurve;
  final bool maintainSize;
  final bool maintainState;
  final bool maintainAnimation;
  final CustomTransitionBuilder? customTransition;

  const MinimalTransition({
    Key? key,
    required this.child,
    this.type = TransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
    this.isVisible = true,
    this.onComplete,
    this.reverseDuration,
    this.reverseCurve,
    this.maintainSize = false,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.customTransition,
  }) : super(key: key);

  @override
  _MinimalTransitionState createState() => _MinimalTransitionState();
}

class _MinimalTransitionState extends State<MinimalTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    final effectiveDuration = widget.duration;
    _controller = AnimationController(
      vsync: this,
      duration: effectiveDuration,
      reverseDuration: widget.reverseDuration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    // Respect reduced motion preference
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      // jump to end state without animation
      if (widget.isVisible) {
        _controller.value = 1;
      } else {
        _controller.value = 0;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onComplete?.call();
      });
    } else {
      if (widget.isVisible) {
        _startForwardWithDelay();
      } else {
        _controller.value = 0;
      }
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.isVisible) {
        widget.onComplete?.call();
      }
      if (status == AnimationStatus.dismissed && !widget.isVisible) {
        widget.onComplete?.call();
      }
    });
  }

  void _startForwardWithDelay() {
    if (widget.delay > Duration.zero) {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MinimalTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible) {
      if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
        // jump
        _controller.value = widget.isVisible ? 1 : 0;
        widget.onComplete?.call();
      } else {
        if (widget.isVisible) {
          _startForwardWithDelay();
        } else {
          final reverseCurve = widget.reverseCurve ?? widget.curve;
          // update animation with reverse curve if provided
          _animation = CurvedAnimation(
            parent: _controller,
            curve: reverseCurve,
          );
          _controller.reverse();
        }
      }
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTransition(BuildContext context, Widget child) {
    if (widget.customTransition != null) {
      return widget.customTransition!(context, _animation, child);
    }

    switch (widget.type) {
      case TransitionType.fade:
        return FadeTransition(opacity: _animation, child: child);
      case TransitionType.slideUp:
        return SlideTransition(
          position: _animation.drive(
            Tween(begin: const Offset(0, 0.2), end: Offset.zero),
          ),
          child: child,
        );
      case TransitionType.slideDown:
        return SlideTransition(
          position: _animation.drive(
            Tween(begin: const Offset(0, -0.2), end: Offset.zero),
          ),
          child: child,
        );
      case TransitionType.slideLeft:
        return SlideTransition(
          position: _animation.drive(
            Tween(begin: const Offset(0.2, 0), end: Offset.zero),
          ),
          child: child,
        );
      case TransitionType.slideRight:
        return SlideTransition(
          position: _animation.drive(
            Tween(begin: const Offset(-0.2, 0), end: Offset.zero),
          ),
          child: child,
        );
      case TransitionType.scale:
        return ScaleTransition(scale: _animation, child: child);
      case TransitionType.rotate:
        return RotationTransition(turns: _animation, child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget result = AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) => _buildTransition(context, child!),
    );

    if (widget.maintainSize ||
        widget.maintainState ||
        widget.maintainAnimation) {
      result = Visibility(
        visible: widget.isVisible,
        maintainSize: widget.maintainSize,
        maintainState: widget.maintainState,
        maintainAnimation: widget.maintainAnimation,
        child: result,
      );
    }

    return result;
  }
}
