import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../internal/token_adapters.dart';
import '../internal/a11y.dart';

/// Size variants for switch components
enum SwitchSize {
  /// Small switch
  sm,
  /// Medium switch (default)
  md,
  /// Large switch
  lg,
}

/// Position of labels relative to switch
enum SwitchLabelPosition {
  /// Label on the left side
  left,
  /// Label on the right side (default)
  right,
  /// Label above the switch
  top,
  /// Label below the switch
  bottom,
}

/// A customizable switch component with label support and animations
class CustomSwitch extends StatefulWidget {
  /// Current switch value
  final bool value;

  /// Callback when the switch value changes
  final ValueChanged<bool>? onChanged;

  /// Label text to display
  final String? label;

  /// Optional description text
  final String? description;

  /// Size variant of the switch
  final SwitchSize size;

  /// Position of the label relative to the switch
  final SwitchLabelPosition labelPosition;

  /// Custom active color
  final Color? activeColor;

  /// Custom inactive color
  final Color? inactiveColor;

  /// Custom thumb color
  final Color? thumbColor;

  /// Whether the switch is disabled
  final bool disabled;

  /// Whether to auto-focus this switch
  final bool autofocus;

  /// Tooltip text for the switch
  final String? tooltip;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Duration of the switch animation
  final Duration animationDuration;

  const CustomSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.description,
    this.size = SwitchSize.md,
    this.labelPosition = SwitchLabelPosition.right,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.disabled = false,
    this.autofocus = false,
    this.tooltip,
    this.semanticLabel,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  /// Factory for a switch with label on the left
  factory CustomSwitch.withLeftLabel({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    required String label,
    String? description,
    SwitchSize size = SwitchSize.md,
    Color? activeColor,
    Color? inactiveColor,
    Color? thumbColor,
    bool disabled = false,
    bool autofocus = false,
    String? tooltip,
    String? semanticLabel,
    Duration animationDuration = const Duration(milliseconds: 200),
  }) {
    return CustomSwitch(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      description: description,
      size: size,
      labelPosition: SwitchLabelPosition.left,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      thumbColor: thumbColor,
      disabled: disabled,
      autofocus: autofocus,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
      animationDuration: animationDuration,
    );
  }

  /// Factory for a switch with label on top
  factory CustomSwitch.withTopLabel({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    required String label,
    String? description,
    SwitchSize size = SwitchSize.md,
    Color? activeColor,
    Color? inactiveColor,
    Color? thumbColor,
    bool disabled = false,
    bool autofocus = false,
    String? tooltip,
    String? semanticLabel,
    Duration animationDuration = const Duration(milliseconds: 200),
  }) {
    return CustomSwitch(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      description: description,
      size: size,
      labelPosition: SwitchLabelPosition.top,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      thumbColor: thumbColor,
      disabled: disabled,
      autofocus: autofocus,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
      animationDuration: animationDuration,
    );
  }

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _thumbAnimation;
  late FocusNode _focusNode;
  late bool _value;

  @override
  void initState() {
    super.initState();

    _value = widget.value;
    _focusNode = FocusNode();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
      value: _value ? 1.0 : 0.0,
    );

    _thumbAnimation = CurvedAnimation(
      parent: _animationController,
      curve: TokenAdapters.curveFromTokens(TokenCurve.easeInOut),
    );

  }

  @override
  void didUpdateWidget(covariant CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
      if (_value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }


    if (oldWidget.animationDuration != widget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }


  /// Get track width based on size
  double get _trackWidth {
    switch (widget.size) {
      case SwitchSize.sm:
        return 36.0;
      case SwitchSize.md:
        return 44.0;
      case SwitchSize.lg:
        return 56.0;
    }
  }

  /// Get track height based on size
  double get _trackHeight {
    switch (widget.size) {
      case SwitchSize.sm:
        return 20.0;
      case SwitchSize.md:
        return 28.0;
      case SwitchSize.lg:
        return 32.0;
    }
  }

  /// Get thumb size based on size
  double get _thumbSize {
    switch (widget.size) {
      case SwitchSize.sm:
        return 14.0;
      case SwitchSize.md:
        return 20.0;
      case SwitchSize.lg:
        return 24.0;
    }
  }

  /// Toggle switch value
  void _toggle() {
    if (widget.disabled || widget.onChanged == null) return;

    final newValue = !_value;
    widget.onChanged!(newValue);

    setState(() {
      _value = newValue;
    });

    if (_value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    HapticFeedback.selectionClick();
  }

  /// Handle keyboard events
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (widget.disabled || widget.onChanged == null) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        _toggle();
        return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Build the switch track and thumb
  Widget _buildSwitch(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = widget.disabled || widget.onChanged == null;

    return AnimatedBuilder(
      animation: _thumbAnimation,
      builder: (context, child) {
        final progress = _thumbAnimation.value;
        final thumbPosition = ((_trackWidth - _thumbSize - 4.0) * progress) + 2.0;

        // Calculate colors
        Color trackColor;
        Color thumbColor;

        if (isDisabled) {
          trackColor = colorScheme.onSurface.withValues(alpha: 0.12);
          thumbColor = colorScheme.onSurface.withValues(alpha: 0.38);
        } else {
          final activeColor = widget.activeColor ?? colorScheme.primary;
          final inactiveColor = widget.inactiveColor ?? colorScheme.surfaceContainerHighest;
          trackColor = Color.lerp(inactiveColor, activeColor, progress)!;
          thumbColor = widget.thumbColor ?? colorScheme.onPrimary;
        }

        return Container(
          width: _trackWidth,
          height: _trackHeight,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(_trackHeight / 2),
            border: Border.all(
              color: isDisabled
                  ? colorScheme.onSurface.withValues(alpha: 0.12)
                  : colorScheme.outline.withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedPositioned(
                duration: widget.animationDuration,
                curve: TokenAdapters.curveFromTokens(TokenCurve.easeInOut),
                left: thumbPosition,
                child: Container(
                  width: _thumbSize,
                  height: _thumbSize,
                  decoration: BoxDecoration(
                    color: thumbColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 2.0,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build label content
  Widget? _buildLabel(BuildContext context) {
    if (widget.label == null && widget.description == null) return null;

    final textColor = widget.disabled
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)
        : Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: TokenAdapters.textStyleFromTokens(
              tokenStyle: TokenTextStyle.bodyMedium,
              color: textColor,
            ),
          ),
        if (widget.description != null && widget.label != null)
          SizedBox(height: context.spacing.xs),
        if (widget.description != null)
          Text(
            widget.description!,
            style: TokenAdapters.textStyleFromTokens(
              tokenStyle: TokenTextStyle.bodySmall,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }

  /// Build the complete switch widget with label
  Widget _buildSwitchWithLabel(BuildContext context) {
    final switchWidget = _buildSwitch(context);
    final labelWidget = _buildLabel(context);

    if (labelWidget == null) return switchWidget;

    switch (widget.labelPosition) {
      case SwitchLabelPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: labelWidget),
            SizedBox(width: context.spacing.sm),
            switchWidget,
          ],
        );
      case SwitchLabelPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            switchWidget,
            SizedBox(width: context.spacing.sm),
            Flexible(child: labelWidget),
          ],
        );
      case SwitchLabelPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelWidget,
            SizedBox(height: context.spacing.sm),
            switchWidget,
          ],
        );
      case SwitchLabelPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            switchWidget,
            SizedBox(height: context.spacing.sm),
            labelWidget,
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.disabled || widget.onChanged == null;

    Widget switchWidget = _buildSwitchWithLabel(context);

    // Add mouse region for cursor
    switchWidget = MouseRegion(
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: switchWidget,
    );

    // Add focusable behavior and gesture detection
    switchWidget = A11yFocusableWidget(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      semanticLabel: widget.semanticLabel ?? widget.label,
      onKey: (node, event) => _handleKeyEvent(event),
      child: GestureDetector(
        onTap: isDisabled ? null : _toggle,
        child: switchWidget,
      ),
    );

    // Add semantics
    switchWidget = Semantics(
      toggled: _value,
      enabled: !isDisabled,
      onTap: isDisabled ? null : _toggle,
      label: widget.semanticLabel ?? widget.label,
      child: switchWidget,
    );

    // Add tooltip if provided
    if (widget.tooltip != null) {
      switchWidget = Tooltip(
        message: widget.tooltip!,
        child: switchWidget,
      );
    }

    return MergeSemantics(child: switchWidget);
  }
}

/// A group of switches that allows multiple selections
class SwitchGroup<T> extends StatefulWidget {
  /// List of switch options
  final List<SwitchOption<T>> options;

  /// Currently selected values
  final List<T> values;

  /// Callback when selection changes
  final ValueChanged<List<T>>? onChanged;

  /// Group label/title
  final String? label;

  /// Optional description for the group
  final String? description;

  /// Direction of the group layout
  final Axis direction;

  /// Spacing between switches
  final double? spacing;

  /// Whether the entire group is disabled
  final bool disabled;

  /// Size of the switches
  final SwitchSize size;

  const SwitchGroup({
    super.key,
    required this.options,
    required this.values,
    this.onChanged,
    this.label,
    this.description,
    this.direction = Axis.vertical,
    this.spacing,
    this.disabled = false,
    this.size = SwitchSize.md,
  });

  @override
  State<SwitchGroup<T>> createState() => _SwitchGroupState<T>();
}

class _SwitchGroupState<T> extends State<SwitchGroup<T>> {
  /// Build group header with label and description
  Widget? _buildHeader(BuildContext context) {
    if (widget.label == null && widget.description == null) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: TokenAdapters.textStyleFromTokens(
              tokenStyle: TokenTextStyle.labelLarge,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (widget.description != null) ...[
          if (widget.label != null) SizedBox(height: context.spacing.xs),
          Text(
            widget.description!,
            style: TokenAdapters.textStyleFromTokens(
              tokenStyle: TokenTextStyle.bodySmall,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  /// Add spacing between widgets
  List<Widget> _addSpacing(List<Widget> children) {
    if (children.isEmpty) return children;

    final effectiveSpacing = widget.spacing ?? context.spacing.md;
    final spacedChildren = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(
          widget.direction == Axis.horizontal
              ? SizedBox(width: effectiveSpacing)
              : SizedBox(height: effectiveSpacing),
        );
      }
    }

    return spacedChildren;
  }

  @override
  Widget build(BuildContext context) {
    // Build switches
    final switches = widget.options.map((option) {
      final isSelected = widget.values.contains(option.value);
      final isDisabled = widget.disabled || option.disabled;

      return CustomSwitch(
        value: isSelected,
        onChanged: isDisabled
            ? null
            : (value) {
                final newValues = List<T>.from(widget.values);
                if (value) {
                  if (!newValues.contains(option.value)) {
                    newValues.add(option.value);
                  }
                } else {
                  newValues.remove(option.value);
                }
                widget.onChanged?.call(newValues);
              },
        label: option.label,
        description: option.description,
        size: widget.size,
        disabled: isDisabled,
      );
    }).toList();

    final spacedSwitches = _addSpacing(switches);

    Widget switchGroup;
    if (widget.direction == Axis.horizontal) {
      switchGroup = Wrap(
        spacing: widget.spacing ?? context.spacing.md,
        runSpacing: widget.spacing ?? context.spacing.sm,
        children: switches,
      );
    } else {
      switchGroup = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: spacedSwitches,
      );
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_buildHeader(context) != null) ...[
            _buildHeader(context)!,
            SizedBox(height: context.spacing.md),
          ],
          switchGroup,
        ],
      ),
    );
  }
}

/// Model for a switch option in a group
class SwitchOption<T> {
  /// The value of this switch option
  final T value;

  /// The label text to display
  final String label;

  /// Optional description text
  final String? description;

  /// Whether this option is disabled
  final bool disabled;

  const SwitchOption({
    required this.value,
    required this.label,
    this.description,
    this.disabled = false,
  });
}