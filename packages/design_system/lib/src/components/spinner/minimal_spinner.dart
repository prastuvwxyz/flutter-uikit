import 'package:flutter/material.dart';
import '../../tokens/color_tokens.dart';

/// Visual variants for MinimalSpinner
enum SpinnerVariant { circular, linear, dots, pulse }

/// A minimal spinner that supports multiple variants and determinate mode.
class MinimalSpinner extends StatelessWidget {
  final SpinnerVariant variant;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;
  final bool isAnimating;
  final Duration animationDuration;
  final double? value;
  final String? semanticsLabel;
  final String? semanticsValue;

  const MinimalSpinner({
    super.key,
    this.variant = SpinnerVariant.circular,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 2.0,
    this.isAnimating = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.value,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? ColorTokens.primary;
    final effectiveBg = backgroundColor ?? Colors.transparent;

    Widget child;
    switch (variant) {
      case SpinnerVariant.linear:
        child = SizedBox(
          height: strokeWidth * 4,
          width: size * 2,
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: effectiveBg,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            minHeight: strokeWidth * 2,
          ),
        );
        break;
      case SpinnerVariant.dots:
        child = _DotsSpinner(
          color: effectiveColor,
          size: size,
          isAnimating: isAnimating,
          duration: animationDuration,
        );
        break;
      case SpinnerVariant.pulse:
        child = _PulseSpinner(
          color: effectiveColor,
          size: size,
          isAnimating: isAnimating,
          duration: animationDuration,
        );
        break;
      case SpinnerVariant.circular:
        child = SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            color: effectiveColor,
            backgroundColor: effectiveBg,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue,
          ),
        );
    }

    return Semantics(
      container: true,
      label: semanticsLabel ?? 'progress',
      value: semanticsValue,
      child: ExcludeSemantics(child: child),
    );
  }
}

class _DotsSpinner extends StatefulWidget {
  final Color color;
  final double size;
  final bool isAnimating;
  final Duration duration;

  const _DotsSpinner({
    required this.color,
    required this.size,
    required this.isAnimating,
    required this.duration,
  });

  @override
  State<_DotsSpinner> createState() => _DotsSpinnerState();
}

class _DotsSpinnerState extends State<_DotsSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void didUpdateWidget(covariant _DotsSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating) {
      _ctrl.repeat();
    } else {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size / 4;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final t = (_ctrl.value + i * 0.2) % 1.0;
              final scale = 0.3 + (0.7 * (1 - (t - 0.5).abs() * 2));
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  margin: EdgeInsets.symmetric(horizontal: dotSize / 3),
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _PulseSpinner extends StatefulWidget {
  final Color color;
  final double size;
  final bool isAnimating;
  final Duration duration;

  const _PulseSpinner({
    required this.color,
    required this.size,
    required this.isAnimating,
    required this.duration,
  });

  @override
  State<_PulseSpinner> createState() => _PulseSpinnerState();
}

class _PulseSpinnerState extends State<_PulseSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void didUpdateWidget(covariant _PulseSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating) {
      _ctrl.repeat();
    } else {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) {
            final scale =
                0.6 + 0.4 * (0.5 + 0.5 * (1 - (_ctrl.value - 0.5).abs() * 2));
            return Transform.scale(
              scale: scale,
              child: Container(
                width: widget.size * 0.6,
                height: widget.size * 0.6,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
