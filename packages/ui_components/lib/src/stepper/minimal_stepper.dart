import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

typedef ControlsWidgetBuilder =
    Widget Function(
      BuildContext context,
      VoidCallback? onStepContinue,
      VoidCallback? onStepCancel,
      int currentStep,
    );

/// Minimal Step representation compatible with Flutter's Step widget API.
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

class MinimalStepper extends StatelessWidget {
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

  const MinimalStepper({
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
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final List<Widget> children = [];

    for (var i = 0; i < steps.length; i++) {
      final step = steps[i];
      final isActive = i == currentStep;

      children.add(_buildStep(context, i, step, isActive, tokens));

      if (i != steps.length - 1) {
        children.add(_buildConnector(context, tokens));
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
    UiTokens tokens,
  ) {
    final state = step.state;

    final icon = stepIconBuilder != null
        ? stepIconBuilder!(index, state)
        : _defaultIcon(index, state, tokens);

    final title = DefaultTextStyle(
      style: tokens.typographyTokens.bodyLarge,
      child: step.title,
    );

    final content = AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Padding(
        padding: EdgeInsets.only(top: tokens.spacingTokens.md),
        child: step.content,
      ),
      crossFadeState: isActive
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );

    final stepHeader = InkWell(
      onTap: step.disabled ? null : () => onStepTapped?.call(index),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(width: tokens.spacingTokens.md),
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
          SizedBox(height: tokens.spacingTokens.md),
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

  Widget _defaultIcon(int index, StepState state, UiTokens tokens) {
    switch (state) {
      case StepState.complete:
        return CircleAvatar(
          radius: 12,
          backgroundColor: tokens.colorTokens.primary.shade500,
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        );
      case StepState.error:
        return CircleAvatar(
          radius: 12,
          backgroundColor: tokens.colorTokens.error,
          child: const Icon(Icons.close, size: 16, color: Colors.white),
        );
      case StepState.editing:
        return CircleAvatar(
          radius: 12,
          backgroundColor: tokens.colorTokens.primary.shade200,
          child: Text('${index + 1}'),
        );
      case StepState.indexed:
      default:
        return CircleAvatar(
          radius: 12,
          backgroundColor: tokens.colorTokens.neutral.shade200,
          child: Text('${index + 1}'),
        );
    }
  }

  Widget _buildConnector(BuildContext context, UiTokens tokens) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: tokens.spacingTokens.sm,
        horizontal: tokens.spacingTokens.md / 2,
      ),
      child: SizedBox(
        width: type == Axis.vertical
            ? connectorThickness
            : tokens.spacingTokens.md,
        height: type == Axis.vertical
            ? tokens.spacingTokens.md
            : connectorThickness,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: connectorColor ?? tokens.colorTokens.neutral.shade300,
          ),
        ),
      ),
    );
  }
}
