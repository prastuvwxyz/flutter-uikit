import 'package:flutter/material.dart';

typedef ControlsWidgetBuilder = Widget Function(
  BuildContext context,
  VoidCallback? onStepContinue,
  VoidCallback? onStepCancel,
  int currentStep,
);

class StepData {
  final Widget title;
  final Widget content;
  final bool isActive;
  final bool disabled;
  final StepState state;

  const StepData({
    required this.title,
    required this.content,
    this.isActive = false,
    this.disabled = false,
    this.state = StepState.indexed,
  });
}

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final List<StepData> steps;
  final ValueChanged<int>? onStepTapped;
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;
  final Axis type;
  final ScrollPhysics? physics;
  final EdgeInsets? margin;
  final ControlsWidgetBuilder? controlsBuilder;
  final Widget Function(int, StepState)? stepIconBuilder;
  final double connectorThickness;
  final Color? connectorColor;

  const CustomStepper({
    super.key,
    this.currentStep = 0,
    this.steps = const [],
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.type = Axis.vertical,
    this.physics,
    this.margin,
    this.controlsBuilder,
    this.stepIconBuilder,
    this.connectorThickness = 1.0,
    this.connectorColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> children = [];

    for (var i = 0; i < steps.length; i++) {
      final step = steps[i];
      final isActive = i == currentStep;

      children.add(_buildStep(context, i, step, isActive, theme));

      if (i != steps.length - 1) {
        children.add(_buildConnector(context, theme));
      }
    }

    final content = type == Axis.vertical
        ? SingleChildScrollView(
            physics: physics,
            child: Padding(
              padding: margin ?? EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          )
        : SingleChildScrollView(
            physics: physics,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: margin ?? EdgeInsets.zero,
              child: Row(children: children),
            ),
          );

    return Semantics(container: true, label: 'Stepper', child: content);
  }

  Widget _buildStep(
    BuildContext context,
    int index,
    StepData step,
    bool isActive,
    ThemeData theme,
  ) {
    final state = step.state;

    final icon = stepIconBuilder != null
        ? stepIconBuilder!(index, state)
        : _defaultIcon(index, state, theme);

    final title = DefaultTextStyle(
      style: theme.textTheme.bodyLarge ?? const TextStyle(),
      child: step.title,
    );

    final content = AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: step.content,
      ),
      crossFadeState:
          isActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );

    final stepHeader = InkWell(
      onTap: step.disabled ? null : () => onStepTapped?.call(index),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 16.0),
          Expanded(child: title),
        ],
      ),
    );

    final controls = controlsBuilder != null
        ? controlsBuilder!(context, onStepContinue, onStepCancel, currentStep)
        : _defaultControls(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        stepHeader,
        if (isActive) ...[
          content,
          const SizedBox(height: 16.0),
          controls,
        ],
      ],
    );
  }

  Widget _defaultControls(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onStepContinue,
          child: const Text('Continue'),
        ),
        const SizedBox(width: 8),
        TextButton(onPressed: onStepCancel, child: const Text('Cancel')),
      ],
    );
  }

  Widget _defaultIcon(int index, StepState state, ThemeData theme) {
    switch (state) {
      case StepState.complete:
        return CircleAvatar(
          radius: 12,
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        );
      case StepState.error:
        return CircleAvatar(
          radius: 12,
          backgroundColor: theme.colorScheme.error,
          child: const Icon(Icons.close, size: 16, color: Colors.white),
        );
      case StepState.editing:
        return CircleAvatar(
          radius: 12,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.3),
          child: Text('${index + 1}'),
        );
      case StepState.indexed:
      default:
        return CircleAvatar(
          radius: 12,
          backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          child: Text('${index + 1}'),
        );
    }
  }

  Widget _buildConnector(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      child: SizedBox(
        width: type == Axis.vertical
            ? connectorThickness
            : 16.0,
        height: type == Axis.vertical
            ? 16.0
            : connectorThickness,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: connectorColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}