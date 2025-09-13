import 'package:flutter/material.dart';
import '../internal/token_adapters.dart';

/// Types of progress indicators
enum ProgressType {
  /// Linear horizontal progress bar
  linear,
  /// Circular progress indicator
  circular,
}

/// Size variants for progress indicators
enum ProgressSize {
  /// Small progress indicator
  sm,
  /// Medium progress indicator (default)
  md,
  /// Large progress indicator
  lg,
}

/// A flexible progress indicator component with linear and circular variants
class Progress extends StatefulWidget {
  /// Progress value between 0.0 and 1.0 (null for indeterminate)
  final double? value;

  /// Type of progress indicator
  final ProgressType type;

  /// Size of the progress indicator
  final ProgressSize size;

  /// Color of the progress bar/indicator
  final Color? color;

  /// Background color of the progress track
  final Color? backgroundColor;

  /// Custom stroke width (for circular) or height (for linear)
  final double? strokeWidth;

  /// Label text to display
  final String? label;

  /// Whether to show percentage text
  final bool showPercentage;

  /// Whether to animate progress changes
  final bool animate;

  /// Duration of progress animations
  final Duration animationDuration;

  /// Position of the label relative to the progress indicator
  final ProgressLabelPosition labelPosition;

  /// Custom text style for labels
  final TextStyle? labelStyle;

  /// Custom text style for percentage
  final TextStyle? percentageStyle;

  /// Whether the progress is in an error state
  final bool isError;

  /// Whether the progress is in a warning state
  final bool isWarning;

  /// Whether the progress is in a success state
  final bool isSuccess;

  const Progress({
    super.key,
    this.value,
    this.type = ProgressType.linear,
    this.size = ProgressSize.md,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.label,
    this.showPercentage = false,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.labelPosition = ProgressLabelPosition.bottom,
    this.labelStyle,
    this.percentageStyle,
    this.isError = false,
    this.isWarning = false,
    this.isSuccess = false,
  });

  /// Factory for linear progress bar
  factory Progress.linear({
    Key? key,
    double? value,
    ProgressSize size = ProgressSize.md,
    Color? color,
    Color? backgroundColor,
    double? height,
    String? label,
    bool showPercentage = false,
    bool animate = true,
    Duration animationDuration = const Duration(milliseconds: 300),
    ProgressLabelPosition labelPosition = ProgressLabelPosition.bottom,
    TextStyle? labelStyle,
    TextStyle? percentageStyle,
    bool isError = false,
    bool isWarning = false,
    bool isSuccess = false,
  }) {
    return Progress(
      key: key,
      value: value,
      type: ProgressType.linear,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
      strokeWidth: height,
      label: label,
      showPercentage: showPercentage,
      animate: animate,
      animationDuration: animationDuration,
      labelPosition: labelPosition,
      labelStyle: labelStyle,
      percentageStyle: percentageStyle,
      isError: isError,
      isWarning: isWarning,
      isSuccess: isSuccess,
    );
  }

  /// Factory for circular progress indicator
  factory Progress.circular({
    Key? key,
    double? value,
    ProgressSize size = ProgressSize.md,
    Color? color,
    Color? backgroundColor,
    double? strokeWidth,
    String? label,
    bool showPercentage = false,
    bool animate = true,
    Duration animationDuration = const Duration(milliseconds: 300),
    ProgressLabelPosition labelPosition = ProgressLabelPosition.bottom,
    TextStyle? labelStyle,
    TextStyle? percentageStyle,
    bool isError = false,
    bool isWarning = false,
    bool isSuccess = false,
  }) {
    return Progress(
      key: key,
      value: value,
      type: ProgressType.circular,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
      strokeWidth: strokeWidth,
      label: label,
      showPercentage: showPercentage,
      animate: animate,
      animationDuration: animationDuration,
      labelPosition: labelPosition,
      labelStyle: labelStyle,
      percentageStyle: percentageStyle,
      isError: isError,
      isWarning: isWarning,
      isSuccess: isSuccess,
    );
  }

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double? _currentValue;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value ?? 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
    ));

    _currentValue = widget.value;

    if (widget.animate && widget.value != null) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant Progress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      if (widget.animate && widget.value != null) {
        _animation = Tween<double>(
          begin: _currentValue ?? 0.0,
          end: widget.value!,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
        ));

        _animationController.reset();
        _animationController.forward();
      }
      _currentValue = widget.value;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Get the height for linear progress or stroke width for circular
  double get _strokeWidth {
    if (widget.strokeWidth != null) return widget.strokeWidth!;

    switch (widget.size) {
      case ProgressSize.sm:
        return widget.type == ProgressType.linear ? 4.0 : 2.0;
      case ProgressSize.md:
        return widget.type == ProgressType.linear ? 6.0 : 3.0;
      case ProgressSize.lg:
        return widget.type == ProgressType.linear ? 8.0 : 4.0;
    }
  }

  /// Get the size for circular progress indicator
  double get _circularSize {
    switch (widget.size) {
      case ProgressSize.sm:
        return 24.0;
      case ProgressSize.md:
        return 40.0;
      case ProgressSize.lg:
        return 56.0;
    }
  }

  /// Get effective progress color based on state
  Color _getProgressColor(BuildContext context) {
    if (widget.color != null) return widget.color!;

    final colorScheme = Theme.of(context).colorScheme;

    if (widget.isError) return colorScheme.error;
    if (widget.isWarning) return Colors.orange.shade600;
    if (widget.isSuccess) return Colors.green.shade600;

    return colorScheme.primary;
  }

  /// Get effective background color
  Color _getBackgroundColor(BuildContext context) {
    if (widget.backgroundColor != null) return widget.backgroundColor!;

    return Theme.of(context).colorScheme.outline.withValues(alpha: 0.2);
  }

  /// Get the current animated value
  double? get _displayValue {
    if (widget.value == null) return null;
    if (!widget.animate) return widget.value;

    return _animation.value;
  }

  /// Build the progress indicator
  Widget _buildProgressIndicator(BuildContext context) {
    final progressColor = _getProgressColor(context);
    final backgroundColor = _getBackgroundColor(context);

    if (widget.type == ProgressType.linear) {
      return LinearProgressIndicator(
        value: _displayValue,
        minHeight: _strokeWidth,
        color: progressColor,
        backgroundColor: backgroundColor,
        semanticsLabel: widget.label,
      );
    } else {
      return SizedBox(
        width: _circularSize,
        height: _circularSize,
        child: CircularProgressIndicator(
          value: _displayValue,
          strokeWidth: _strokeWidth,
          color: progressColor,
          backgroundColor: backgroundColor,
          semanticsLabel: widget.label,
        ),
      );
    }
  }

  /// Build label text widget
  Widget? _buildLabel(BuildContext context) {
    if (widget.label == null) return null;

    return Text(
      widget.label!,
      style: widget.labelStyle ??
          TokenAdapters.textStyleFromTokens(
            tokenStyle: TokenTextStyle.labelMedium,
          ),
      textAlign: TextAlign.center,
    );
  }

  /// Build percentage text widget
  Widget? _buildPercentage(BuildContext context) {
    if (!widget.showPercentage || widget.value == null) return null;

    final percentage = ((_displayValue ?? widget.value!) * 100).round();

    return Text(
      '$percentage%',
      style: widget.percentageStyle ??
          TokenAdapters.textStyleFromTokens(
            tokenStyle: TokenTextStyle.labelSmall,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      textAlign: TextAlign.center,
    );
  }

  /// Build progress content with labels
  Widget _buildProgressWithLabels(BuildContext context) {
    final progressIndicator = _buildProgressIndicator(context);
    final label = _buildLabel(context);
    final percentage = _buildPercentage(context);

    // For circular progress with center content
    if (widget.type == ProgressType.circular &&
        widget.labelPosition == ProgressLabelPosition.center) {
      return Stack(
        alignment: Alignment.center,
        children: [
          progressIndicator,
          if (percentage != null || label != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (percentage != null) percentage,
                if (label != null && percentage != null)
                  SizedBox(height: context.spacing.xs),
                if (label != null) label,
              ],
            ),
        ],
      );
    }

    // For other label positions
    final hasLabels = label != null || percentage != null;
    if (!hasLabels) return progressIndicator;

    Widget labelRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (label != null) Expanded(child: label),
        if (percentage != null) percentage,
      ],
    );

    switch (widget.labelPosition) {
      case ProgressLabelPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            labelRow,
            SizedBox(height: context.spacing.sm),
            progressIndicator,
          ],
        );
      case ProgressLabelPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            progressIndicator,
            SizedBox(height: context.spacing.sm),
            labelRow,
          ],
        );
      case ProgressLabelPosition.center:
        return progressIndicator; // Handled above for circular
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressValue = widget.value != null ? (_displayValue ?? widget.value!) : null;
    final percentage = progressValue != null ? (progressValue * 100).round() : null;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Semantics(
          label: widget.label ?? 'Progress indicator',
          value: percentage != null ? '$percentage percent' : 'Loading',
          child: _buildProgressWithLabels(context),
        );
      },
    );
  }
}

/// Position of labels relative to progress indicator
enum ProgressLabelPosition {
  /// Above the progress indicator
  top,
  /// Below the progress indicator
  bottom,
  /// In the center (only for circular progress)
  center,
}

/// Multi-step progress indicator for wizards and forms
class StepProgress extends StatelessWidget {
  /// Current active step (0-based index)
  final int currentStep;

  /// Total number of steps
  final int totalSteps;

  /// Labels for each step
  final List<String>? stepLabels;

  /// Size of the step indicators
  final ProgressSize size;

  /// Color for completed steps
  final Color? completedColor;

  /// Color for the current step
  final Color? currentColor;

  /// Color for upcoming steps
  final Color? upcomingColor;

  /// Whether to show step numbers
  final bool showStepNumbers;

  /// Whether to animate step changes
  final bool animate;

  const StepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.size = ProgressSize.md,
    this.completedColor,
    this.currentColor,
    this.upcomingColor,
    this.showStepNumbers = true,
    this.animate = true,
  });

  /// Get step indicator size based on size
  double get _stepSize {
    switch (size) {
      case ProgressSize.sm:
        return 24.0;
      case ProgressSize.md:
        return 32.0;
      case ProgressSize.lg:
        return 40.0;
    }
  }

  /// Get connector line height
  double get _lineHeight {
    switch (size) {
      case ProgressSize.sm:
        return 2.0;
      case ProgressSize.md:
        return 3.0;
      case ProgressSize.lg:
        return 4.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveCompletedColor = completedColor ?? colorScheme.primary;
    final effectiveCurrentColor = currentColor ?? colorScheme.primary;
    final effectiveUpcomingColor = upcomingColor ?? colorScheme.outline;

    return Column(
      children: [
        // Step indicators with connector lines
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isEven) {
              // Step indicator
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;
              final isCurrent = stepIndex == currentStep;

              Color stepColor;
              if (isCompleted) {
                stepColor = effectiveCompletedColor;
              } else if (isCurrent) {
                stepColor = effectiveCurrentColor;
              } else {
                stepColor = effectiveUpcomingColor;
              }

              return Container(
                width: _stepSize,
                height: _stepSize,
                decoration: BoxDecoration(
                  color: stepColor,
                  shape: BoxShape.circle,
                ),
                child: showStepNumbers
                    ? Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                size: _stepSize * 0.6,
                                color: Colors.white,
                              )
                            : Text(
                                '${stepIndex + 1}',
                                style: TokenAdapters.textStyleFromTokens(
                                  tokenStyle: TokenTextStyle.labelSmall,
                                  color: isCurrent ? Colors.white :
                                         (stepIndex > currentStep ? colorScheme.onSurfaceVariant : Colors.white),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      )
                    : null,
              );
            } else {
              // Connector line
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;

              return Expanded(
                child: Container(
                  height: _lineHeight,
                  color: isCompleted ? effectiveCompletedColor : effectiveUpcomingColor,
                ),
              );
            }
          }),
        ),

        // Step labels
        if (stepLabels != null) ...[
          SizedBox(height: context.spacing.sm),
          Row(
            children: stepLabels!.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value;
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;

              return Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TokenAdapters.textStyleFromTokens(
                    tokenStyle: TokenTextStyle.labelSmall,
                    color: isCompleted || isCurrent
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}