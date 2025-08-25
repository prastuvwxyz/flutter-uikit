import 'package:flutter/material.dart';
import '../../tokens/color_tokens.dart';
import '../../tokens/spacing_tokens.dart';

enum ProgressType { linear, circular }

enum ProgressSize { sm, md, lg }

class MinimalProgress extends StatelessWidget {
  final double? value;
  final ProgressType type;
  final ProgressSize size;
  final Color? color;
  final Color? backgroundColor;
  final double? strokeWidth;
  final String? label;
  final bool showPercentage;

  const MinimalProgress({
    Key? key,
    this.value,
    this.type = ProgressType.linear,
    this.size = ProgressSize.md,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.label,
    this.showPercentage = false,
  }) : super(key: key);

  double get _height {
    switch (size) {
      case ProgressSize.sm:
        return 4.0;
      case ProgressSize.md:
        return 6.0;
      case ProgressSize.lg:
        return 8.0;
    }
  }

  double get _circularSize {
    switch (size) {
      case ProgressSize.sm:
        return 24.0;
      case ProgressSize.md:
        return 36.0;
      case ProgressSize.lg:
        return 48.0;
    }
  }

  double get _strokeWidth => strokeWidth ?? (_height);

  Color get _progressColor => color ?? ColorTokens.primary;
  Color get _trackColor => backgroundColor ?? ColorTokens.outline;

  @override
  Widget build(BuildContext context) {
    Widget progress;
    if (type == ProgressType.linear) {
      progress = LinearProgressIndicator(
        value: value,
        minHeight: _height,
        color: _progressColor,
        backgroundColor: _trackColor,
        semanticsLabel: label,
      );
    } else {
      progress = SizedBox(
        width: _circularSize,
        height: _circularSize,
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: _strokeWidth,
          color: _progressColor,
          backgroundColor: _trackColor,
          semanticsLabel: label,
        ),
      );
    }

    Widget? percentageText;
    if (showPercentage && value != null) {
      percentageText = Text(
        '${(value! * 100).toStringAsFixed(0)}%',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    Widget? labelText = label != null ? Text(label!) : null;

    return Semantics(
      label: label ?? 'Progress',
      value: value != null ? '${(value! * 100).toStringAsFixed(0)}%' : null,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            progress,
            if (labelText != null || percentageText != null)
              Padding(
                padding: const EdgeInsets.only(top: SpacingTokens.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (labelText != null) labelText,
                    if (labelText != null && percentageText != null)
                      const SizedBox(width: 8),
                    if (percentageText != null) percentageText,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Accessibility role for progress bar
class Role {
  static const progressBar = 'progressbar';
}
