import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ShimmerDirection { ltr, rtl, ttb, btt }

class MinimalSkeleton extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final Widget? child;
  final bool animationEnabled;
  final Duration animationDuration;
  final Color? baseColor;
  final Color? highlightColor;
  final ShimmerDirection direction;

  const MinimalSkeleton({
    Key? key,
    this.width,
    this.height = 16.0,
    this.borderRadius,
    this.isLoading = true,
    this.child,
    this.animationEnabled = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
    this.direction = ShimmerDirection.ltr,
  }) : super(key: key);

  @override
  State<MinimalSkeleton> createState() => _MinimalSkeletonState();
}

class _MinimalSkeletonState extends State<MinimalSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    if (widget.animationEnabled && widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant MinimalSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationEnabled && widget.isLoading) {
      if (!_controller.isAnimating) _controller.repeat();
      _controller.duration = widget.animationDuration;
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _beginAlignmentForDirection() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return Alignment(-1.0, 0.0);
      case ShimmerDirection.rtl:
        return Alignment(1.0, 0.0);
      case ShimmerDirection.ttb:
        return Alignment(0.0, -1.0);
      case ShimmerDirection.btt:
        return Alignment(0.0, 1.0);
    }
  }

  Alignment _endAlignmentForDirection() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return Alignment(1.0, 0.0);
      case ShimmerDirection.rtl:
        return Alignment(-1.0, 0.0);
      case ShimmerDirection.ttb:
        return Alignment(0.0, 1.0);
      case ShimmerDirection.btt:
        return Alignment(0.0, -1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base =
        widget.baseColor ?? theme.colorScheme.surfaceVariant.withOpacity(0.6);
    final highlight =
        widget.highlightColor ?? theme.colorScheme.surface.withOpacity(0.9);

    if (!widget.isLoading) {
      return widget.child ?? const SizedBox.shrink();
    }

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(4);

    Widget skeleton = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(color: base, borderRadius: borderRadius),
    );

    if (widget.animationEnabled) {
      skeleton = AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          // position gradient from -1..1
          final begin = _beginAlignmentForDirection();
          final end = _endAlignmentForDirection();
          return ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: begin,
                end: end,
                colors: [base, highlight, base],
                stops: [
                  (t - 0.3).clamp(0.0, 1.0),
                  t.clamp(0.0, 1.0),
                  (t + 0.3).clamp(0.0, 1.0),
                ],
              ).createShader(rect);
            },
            blendMode: BlendMode.srcATop,
            child: child,
          );
        },
        child: skeleton,
      );
    }

    return Semantics(
      container: true,
      liveRegion: widget.isLoading,
      label: 'Loading',
      explicitChildNodes: true,
      child: ExcludeSemantics(excluding: false, child: skeleton),
    );
  }
}
