import 'package:flutter/material.dart';

/// Visual variants for Spinner
enum SpinnerVariant {
  /// Circular progress indicator (default)
  circular,

  /// Linear progress indicator
  linear,

  /// Animated dots
  dots,

  /// Pulsing circle
  pulse,
}

/// A versatile spinner component with multiple visual variants and loading states.
///
/// The Spinner component provides different visual styles for indicating loading
/// states, including circular, linear, dots, and pulse variants. It supports
/// both determinate and indeterminate progress modes, as well as custom colors
/// and sizing.
///
/// Example:
/// ```dart
/// Spinner(
///   variant: SpinnerVariant.circular,
///   size: 32.0,
///   color: Colors.blue,
/// )
/// ```
class Spinner extends StatelessWidget {
  /// The visual variant of the spinner
  final SpinnerVariant variant;

  /// The size of the spinner (width/height for circular, height for linear, diameter for others)
  final double size;

  /// The primary color of the spinner
  final Color? color;

  /// The background color of the spinner
  final Color? backgroundColor;

  /// The stroke width for circular spinners
  final double strokeWidth;

  /// Whether the spinner should animate
  final bool isAnimating;

  /// Duration for one full animation cycle
  final Duration animationDuration;

  /// Progress value (0.0 to 1.0) for determinate mode. Null for indeterminate.
  final double? value;

  /// Semantic label for accessibility
  final String? semanticsLabel;

  /// Semantic value for accessibility (typically used with determinate progress)
  final String? semanticsValue;

  /// Creates a Spinner with customizable appearance and behavior.
  ///
  /// [variant] controls the visual style of the spinner (defaults to circular).
  /// [size] controls the overall size of the spinner.
  /// [color] sets the primary color. If null, uses theme primary color.
  /// [backgroundColor] sets the background color for progress indicators.
  /// [strokeWidth] controls the thickness of circular spinners.
  /// [isAnimating] controls whether the spinner should animate.
  /// [value] sets progress for determinate mode (null = indeterminate).
  const Spinner({
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

  /// Creates a small circular spinner
  factory Spinner.small({
    Color? color,
    bool isAnimating = true,
    double? value,
    String? semanticsLabel,
  }) =>
      Spinner(
        variant: SpinnerVariant.circular,
        size: 16.0,
        strokeWidth: 1.5,
        color: color,
        isAnimating: isAnimating,
        value: value,
        semanticsLabel: semanticsLabel,
      );

  /// Creates a medium circular spinner (default)
  factory Spinner.medium({
    Color? color,
    bool isAnimating = true,
    double? value,
    String? semanticsLabel,
  }) =>
      Spinner(
        variant: SpinnerVariant.circular,
        size: 24.0,
        color: color,
        isAnimating: isAnimating,
        value: value,
        semanticsLabel: semanticsLabel,
      );

  /// Creates a large circular spinner
  factory Spinner.large({
    Color? color,
    bool isAnimating = true,
    double? value,
    String? semanticsLabel,
  }) =>
      Spinner(
        variant: SpinnerVariant.circular,
        size: 32.0,
        strokeWidth: 3.0,
        color: color,
        isAnimating: isAnimating,
        value: value,
        semanticsLabel: semanticsLabel,
      );

  /// Creates a linear progress spinner
  factory Spinner.linear({
    double width = 200.0,
    double height = 4.0,
    Color? color,
    Color? backgroundColor,
    double? value,
    String? semanticsLabel,
    String? semanticsValue,
  }) =>
      Spinner(
        variant: SpinnerVariant.linear,
        size: width,
        strokeWidth: height,
        color: color,
        backgroundColor: backgroundColor,
        value: value,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      );

  /// Creates an animated dots spinner
  factory Spinner.dots({
    double size = 24.0,
    Color? color,
    bool isAnimating = true,
  }) =>
      Spinner(
        variant: SpinnerVariant.dots,
        size: size,
        color: color,
        isAnimating: isAnimating,
      );

  /// Creates a pulsing circle spinner
  factory Spinner.pulse({
    double size = 24.0,
    Color? color,
    bool isAnimating = true,
  }) =>
      Spinner(
        variant: SpinnerVariant.pulse,
        size: size,
        color: color,
        isAnimating: isAnimating,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveColor = color ?? theme.colorScheme.primary;
    final effectiveBg = backgroundColor ?? Colors.transparent;

    Widget child;
    switch (variant) {
      case SpinnerVariant.linear:
        child = SizedBox(
          height: strokeWidth,
          width: size,
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: effectiveBg,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            minHeight: strokeWidth,
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
      label: semanticsLabel ?? 'Loading',
      value: semanticsValue,
      child: ExcludeSemantics(child: child),
    );
  }
}

/// Animated dots spinner implementation
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
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _DotsSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size / 4;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final t = (_controller.value + i * 0.2) % 1.0;
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

/// Pulsing circle spinner implementation
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
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _PulseSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final scale = 0.6 + 0.4 * (0.5 + 0.5 * (1 - (_controller.value - 0.5).abs() * 2));
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