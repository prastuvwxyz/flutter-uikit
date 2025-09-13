import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum RadioDirection {
  vertical,
  horizontal,
}

class RadioOption<T> {
  final T value;
  final String label;
  final String? description;
  final bool disabled;
  final Widget? icon;
  final Widget? trailing;

  const RadioOption({
    required this.value,
    required this.label,
    this.description,
    this.disabled = false,
    this.icon,
    this.trailing,
  });
}

enum RadioLabelPosition {
  left,
  right,
  top,
  bottom,
}

class RadioButton<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? description;
  final bool disabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final RadioLabelPosition labelPosition;
  final bool autofocus;
  final String? tooltip;
  final String? semanticLabel;

  const RadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.description,
    this.disabled = false,
    this.activeColor,
    this.inactiveColor,
    this.labelPosition = RadioLabelPosition.right,
    this.autofocus = false,
    this.tooltip,
    this.semanticLabel,
  });

  bool get isSelected => value == groupValue;

  @override
  State<RadioButton<T>> createState() => _RadioButtonState<T>();
}

class _RadioButtonState<T> extends State<RadioButton<T>> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {});
  }

  void _handleTap() {
    if (widget.disabled || widget.onChanged == null) return;

    widget.onChanged!(widget.value);
    HapticFeedback.selectionClick();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (widget.disabled || widget.onChanged == null) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        _handleTap();
        return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Widget _buildRadioButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveActiveColor = widget.activeColor ?? colorScheme.primary;
    final effectiveInactiveColor = widget.inactiveColor ?? colorScheme.outline;

    return SizedBox(
      width: 20,
      height: 20,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.disabled
                ? effectiveInactiveColor.withValues(alpha: 0.38)
                : widget.isSelected
                    ? effectiveActiveColor
                    : effectiveInactiveColor,
            width: 2,
          ),
          color: widget.isSelected && !widget.disabled
              ? effectiveActiveColor
              : Colors.transparent,
        ),
        child: widget.isSelected
            ? Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.disabled
                        ? effectiveActiveColor.withValues(alpha: 0.38)
                        : Colors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget? _buildLabel(BuildContext context) {
    if (widget.label == null && widget.description == null) return null;

    final theme = Theme.of(context);
    final textColor = widget.disabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
        : theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        if (widget.description != null && widget.label != null)
          SizedBox(height: 4),
        if (widget.description != null)
          Text(
            widget.description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }

  Widget _buildRadioWidget(BuildContext context) {
    final radioButton = _buildRadioButton(context);
    final label = _buildLabel(context);

    if (label == null) return radioButton;

    switch (widget.labelPosition) {
      case RadioLabelPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: label),
            SizedBox(width: 8),
            radioButton,
          ],
        );
      case RadioLabelPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            radioButton,
            SizedBox(width: 8),
            Flexible(child: label),
          ],
        );
      case RadioLabelPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            SizedBox(height: 8),
            radioButton,
          ],
        );
      case RadioLabelPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            radioButton,
            SizedBox(height: 8),
            label,
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget radio = _buildRadioWidget(context);

    radio = MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: radio,
    );

    radio = Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: GestureDetector(
        onTap: _handleTap,
        child: radio,
      ),
    );

    radio = Semantics(
      checked: widget.isSelected,
      inMutuallyExclusiveGroup: true,
      enabled: !widget.disabled,
      onTap: widget.disabled || widget.onChanged == null ? null : _handleTap,
      label: widget.semanticLabel ?? widget.label,
      child: radio,
    );

    if (widget.tooltip != null) {
      radio = Tooltip(
        message: widget.tooltip!,
        child: radio,
      );
    }

    return radio;
  }
}

class RadioGroup<T> extends StatefulWidget {
  final List<RadioOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? description;
  final bool required;
  final String? error;
  final RadioDirection direction;
  final double? spacing;
  final bool disabled;
  final bool showFocusRing;

  const RadioGroup({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.label,
    this.description,
    this.required = false,
    this.error,
    this.direction = RadioDirection.vertical,
    this.spacing,
    this.disabled = false,
    this.showFocusRing = true,
  });

  @override
  State<RadioGroup<T>> createState() => _RadioGroupState<T>();
}

class _RadioGroupState<T> extends State<RadioGroup<T>> {
  late FocusScopeNode _focusScope;

  @override
  void initState() {
    super.initState();
    _focusScope = FocusScopeNode();
  }

  @override
  void dispose() {
    _focusScope.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final navigationKeys = {
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
    };

    if (!navigationKeys.contains(event.logicalKey)) return KeyEventResult.ignored;

    final currentIndex = widget.options.indexWhere((o) => o.value == widget.value);
    if (currentIndex == -1 && widget.options.isNotEmpty) {
      final firstEnabled = widget.options.indexWhere((o) => !o.disabled);
      if (firstEnabled != -1 && !widget.disabled) {
        widget.onChanged?.call(widget.options[firstEnabled].value);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    int nextIndex = currentIndex;
    final isHorizontal = widget.direction == RadioDirection.horizontal;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        if (!isHorizontal) {
          nextIndex = (currentIndex + 1) % widget.options.length;
        }
        break;
      case LogicalKeyboardKey.arrowUp:
        if (!isHorizontal) {
          nextIndex = (currentIndex - 1 + widget.options.length) % widget.options.length;
        }
        break;
      case LogicalKeyboardKey.arrowRight:
        if (isHorizontal) {
          nextIndex = (currentIndex + 1) % widget.options.length;
        }
        break;
      case LogicalKeyboardKey.arrowLeft:
        if (isHorizontal) {
          nextIndex = (currentIndex - 1 + widget.options.length) % widget.options.length;
        }
        break;
    }

    if (nextIndex != currentIndex) {
      final nextOption = widget.options[nextIndex];
      if (!nextOption.disabled && !widget.disabled) {
        widget.onChanged?.call(nextOption.value);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  Widget? _buildHeader(BuildContext context) {
    if (widget.label == null && widget.description == null) return null;

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Row(
            children: [
              Text(
                widget.label!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.required) ...[
                SizedBox(width: 4),
                Text(
                  '*',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        if (widget.description != null) ...[
          if (widget.label != null) SizedBox(height: 4),
          Text(
            widget.description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildError(BuildContext context) {
    if (widget.error == null) return null;

    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Text(
        widget.error!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  List<Widget> _addSpacing(List<Widget> children) {
    if (children.isEmpty) return children;

    final effectiveSpacing = widget.spacing ?? 8.0;
    final spacedChildren = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(
          widget.direction == RadioDirection.horizontal
              ? SizedBox(width: effectiveSpacing)
              : SizedBox(height: effectiveSpacing),
        );
      }
    }

    return spacedChildren;
  }

  @override
  Widget build(BuildContext context) {
    final radioButtons = widget.options.map((option) {
      final isDisabled = widget.disabled || option.disabled;

      return RadioButton<T>(
        value: option.value,
        groupValue: widget.value,
        onChanged: isDisabled ? null : widget.onChanged,
        label: option.label,
        description: option.description,
        disabled: isDisabled,
        tooltip: option.description,
      );
    }).toList();

    final spacedRadioButtons = _addSpacing(radioButtons);

    Widget radioGroup;
    if (widget.direction == RadioDirection.horizontal) {
      radioGroup = Wrap(
        spacing: widget.spacing ?? 8.0,
        runSpacing: widget.spacing ?? 8.0,
        children: radioButtons,
      );
    } else {
      radioGroup = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: spacedRadioButtons,
      );
    }

    return Focus(
      focusNode: _focusScope,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.label,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_buildHeader(context) != null) ...[
              _buildHeader(context)!,
              SizedBox(height: 8),
            ],
            radioGroup,
            if (_buildError(context) != null) _buildError(context)!,
          ],
        ),
      ),
    );
  }
}