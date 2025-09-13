import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../internal/token_adapters.dart';
import '../internal/a11y.dart';

/// Enum defining the available sizes for the Checkbox component
enum CheckboxSize {
  /// Small checkbox
  sm,
  /// Medium checkbox (default)
  md,
  /// Large checkbox
  lg,
}

/// Enum defining the available positions for the Checkbox label
enum CheckboxLabelPosition {
  /// Label appears to the left of the checkbox
  left,
  /// Label appears to the right of the checkbox (default)
  right,
  /// Label appears above the checkbox
  top,
  /// Label appears below the checkbox
  bottom,
}

/// Extension on CheckboxLabelPosition to determine positioning properties
extension CheckboxLabelPositionExt on CheckboxLabelPosition {
  /// Returns true if the label position is horizontal (left or right)
  bool get isHorizontal =>
      this == CheckboxLabelPosition.left || this == CheckboxLabelPosition.right;

  /// Returns true if the label position is vertical (top or bottom)
  bool get isVertical =>
      this == CheckboxLabelPosition.top || this == CheckboxLabelPosition.bottom;
}

/// Internal mapping for checkbox size dimensions
class CheckboxSizeData {
  /// Size dimension in logical pixels
  final double size;
  /// Font size to use for labels
  final double fontSize;
  /// Spacing between checkbox and label
  final double spacing;

  const CheckboxSizeData({
    required this.size,
    required this.fontSize,
    required this.spacing,
  });

  /// Get size data for a specific checkbox size
  static CheckboxSizeData forSize(CheckboxSize size) {
    switch (size) {
      case CheckboxSize.sm:
        return const CheckboxSizeData(size: 16, fontSize: 12, spacing: 6);
      case CheckboxSize.md:
        return const CheckboxSizeData(size: 20, fontSize: 14, spacing: 8);
      case CheckboxSize.lg:
        return const CheckboxSizeData(size: 24, fontSize: 16, spacing: 10);
    }
  }
}

/// A customizable checkbox widget with support for labels, sizes, and indeterminate state
class Checkbox extends StatefulWidget {
  /// Whether the checkbox is checked
  final bool? value;

  /// Callback when the checkbox value changes
  final ValueChanged<bool?>? onChanged;

  /// Label text to display next to the checkbox
  final String? label;

  /// Position of the label relative to the checkbox
  final CheckboxLabelPosition labelPosition;

  /// Size of the checkbox
  final CheckboxSize size;

  /// Whether the checkbox is disabled
  final bool disabled;

  /// Custom colors for the checkbox
  final Color? activeColor;

  /// Color when checkbox is not checked
  final Color? inactiveColor;

  /// Color of the check mark
  final Color? checkColor;

  /// Whether to show focus outline
  final bool showFocusRing;

  /// Tooltip text for the checkbox
  final String? tooltip;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Whether the checkbox should auto-focus
  final bool autofocus;

  const Checkbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelPosition = CheckboxLabelPosition.right,
    this.size = CheckboxSize.md,
    this.disabled = false,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.showFocusRing = true,
    this.tooltip,
    this.semanticLabel,
    this.autofocus = false,
  });

  /// Factory for creating a simple checkbox without label
  factory Checkbox.simple({
    Key? key,
    required bool? value,
    required ValueChanged<bool?>? onChanged,
    CheckboxSize size = CheckboxSize.md,
    bool disabled = false,
    Color? activeColor,
    Color? inactiveColor,
    Color? checkColor,
    bool showFocusRing = true,
    String? tooltip,
    String? semanticLabel,
    bool autofocus = false,
  }) {
    return Checkbox(
      key: key,
      value: value,
      onChanged: onChanged,
      size: size,
      disabled: disabled,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      checkColor: checkColor,
      showFocusRing: showFocusRing,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
      autofocus: autofocus,
    );
  }

  /// Factory for creating a labeled checkbox
  factory Checkbox.labeled({
    Key? key,
    required bool? value,
    required ValueChanged<bool?>? onChanged,
    required String label,
    CheckboxLabelPosition labelPosition = CheckboxLabelPosition.right,
    CheckboxSize size = CheckboxSize.md,
    bool disabled = false,
    Color? activeColor,
    Color? inactiveColor,
    Color? checkColor,
    bool showFocusRing = true,
    String? tooltip,
    String? semanticLabel,
    bool autofocus = false,
  }) {
    return Checkbox(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      labelPosition: labelPosition,
      size: size,
      disabled: disabled,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      checkColor: checkColor,
      showFocusRing: showFocusRing,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
      autofocus: autofocus,
    );
  }

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> {
  late FocusNode _focusNode;
  bool _isFocused = false;

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
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _handleTap() {
    if (widget.disabled || widget.onChanged == null) return;

    // Toggle value: null -> false -> true -> null (for tristate)
    bool? newValue;
    if (widget.value == null) {
      newValue = false;
    } else if (widget.value == false) {
      newValue = true;
    } else {
      newValue = null;
    }

    widget.onChanged!(newValue);

    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  /// Get effective colors based on state
  ({Color active, Color inactive, Color check, Color border}) _getEffectiveColors(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultActive = widget.activeColor ?? colorScheme.primary;
    final defaultInactive = widget.inactiveColor ??
        (isDark ? colorScheme.outline : colorScheme.surface);
    final defaultCheck = widget.checkColor ?? colorScheme.onPrimary;
    final defaultBorder = widget.disabled
        ? colorScheme.outline.withValues(alpha: 0.38)
        : colorScheme.outline;

    return (
      active: defaultActive,
      inactive: defaultInactive,
      check: defaultCheck,
      border: defaultBorder,
    );
  }

  /// Build the checkbox visual
  Widget _buildCheckboxVisual(BuildContext context) {
    final sizeData = CheckboxSizeData.forSize(widget.size);
    final colors = _getEffectiveColors(context);
    final isChecked = widget.value == true;
    final isIndeterminate = widget.value == null;

    // Determine background color
    Color backgroundColor;
    if (widget.disabled) {
      backgroundColor = isChecked
          ? colors.active.withValues(alpha: 0.38)
          : colors.inactive.withValues(alpha: 0.12);
    } else if (isChecked || isIndeterminate) {
      backgroundColor = colors.active;
    } else {
      backgroundColor = colors.inactive;
    }

    // Determine border color
    Color borderColor;
    if (widget.disabled) {
      borderColor = colors.border;
    } else if (isChecked || isIndeterminate) {
      borderColor = colors.active;
    } else {
      borderColor = colors.border;
    }

    // Build focus ring
    Widget checkboxVisual = AnimatedContainer(
      duration: TokenAdapters.durationFromTokens(TokenDuration.fast),
      curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
      width: sizeData.size,
      height: sizeData.size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: context.borderRadius(all: TokenRadiusSize.sm),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: isChecked
          ? Icon(
              Icons.check,
              size: sizeData.size * 0.7,
              color: widget.disabled
                  ? colors.check.withValues(alpha: 0.38)
                  : colors.check,
            )
          : isIndeterminate
              ? Container(
                  margin: EdgeInsets.all(sizeData.size * 0.25),
                  decoration: BoxDecoration(
                    color: widget.disabled
                        ? colors.check.withValues(alpha: 0.38)
                        : colors.check,
                    borderRadius: BorderRadius.circular(1),
                  ),
                )
              : null,
    );

    // Add focus ring if needed
    if (widget.showFocusRing && _isFocused && !widget.disabled) {
      checkboxVisual = Container(
        decoration: BoxDecoration(
          borderRadius: context.borderRadius(all: TokenRadiusSize.sm),
          boxShadow: [
            BoxShadow(
              color: colors.active.withValues(alpha: 0.3),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: checkboxVisual,
      );
    }

    return checkboxVisual;
  }

  /// Build the label widget
  Widget? _buildLabel(BuildContext context) {
    if (widget.label == null) return null;

    final sizeData = CheckboxSizeData.forSize(widget.size);
    final textColor = widget.disabled
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)
        : Theme.of(context).colorScheme.onSurface;

    return Text(
      widget.label!,
      style: TokenAdapters.textStyleFromTokens(
        tokenStyle: TokenTextStyle.bodyMedium,
        color: textColor,
      ).copyWith(
        fontSize: sizeData.fontSize,
      ),
    );
  }

  /// Build the complete checkbox widget
  Widget _buildCheckboxWidget(BuildContext context) {
    final sizeData = CheckboxSizeData.forSize(widget.size);
    final checkboxVisual = _buildCheckboxVisual(context);
    final label = _buildLabel(context);

    if (label == null) {
      return checkboxVisual;
    }

    // Arrange checkbox and label based on position
    Widget arrangedContent;
    switch (widget.labelPosition) {
      case CheckboxLabelPosition.left:
        arrangedContent = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            SizedBox(width: sizeData.spacing),
            checkboxVisual,
          ],
        );
        break;
      case CheckboxLabelPosition.right:
        arrangedContent = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkboxVisual,
            SizedBox(width: sizeData.spacing),
            label,
          ],
        );
        break;
      case CheckboxLabelPosition.top:
        arrangedContent = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            SizedBox(height: sizeData.spacing),
            checkboxVisual,
          ],
        );
        break;
      case CheckboxLabelPosition.bottom:
        arrangedContent = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkboxVisual,
            SizedBox(height: sizeData.spacing),
            label,
          ],
        );
        break;
    }

    return arrangedContent;
  }

  /// Handle keyboard events
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

  @override
  Widget build(BuildContext context) {
    Widget checkbox = _buildCheckboxWidget(context);

    // Add mouse region for cursor
    checkbox = MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: checkbox,
    );

    // Add gesture detection and focus handling
    checkbox = A11yFocusableWidget(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      semanticLabel: widget.semanticLabel ?? widget.label,
      onKey: (node, event) => _handleKeyEvent(event),
      child: GestureDetector(
        onTap: _handleTap,
        child: checkbox,
      ),
    );

    // Add semantics
    checkbox = Semantics(
      checked: widget.value == true,
      mixed: widget.value == null,
      enabled: !widget.disabled,
      onTap: widget.disabled || widget.onChanged == null ? null : _handleTap,
      label: widget.semanticLabel ?? widget.label,
      child: checkbox,
    );

    // Add tooltip if provided
    if (widget.tooltip != null) {
      checkbox = Tooltip(
        message: widget.tooltip!,
        child: checkbox,
      );
    }

    return checkbox;
  }
}

/// A group of checkboxes that allows multiple selections
class CheckboxGroup extends StatefulWidget {
  /// List of checkbox options
  final List<CheckboxGroupOption> options;

  /// Currently selected values
  final Set<String> selectedValues;

  /// Callback when selection changes
  final ValueChanged<Set<String>>? onChanged;

  /// Size for all checkboxes in the group
  final CheckboxSize size;

  /// Whether the group is disabled
  final bool disabled;

  /// Direction of the checkbox list
  final Axis direction;

  /// Spacing between checkboxes
  final double? spacing;

  /// Title for the checkbox group
  final String? title;

  const CheckboxGroup({
    super.key,
    required this.options,
    required this.selectedValues,
    this.onChanged,
    this.size = CheckboxSize.md,
    this.disabled = false,
    this.direction = Axis.vertical,
    this.spacing,
    this.title,
  });

  @override
  State<CheckboxGroup> createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  void _handleOptionChanged(String value, bool? checked) {
    if (widget.onChanged == null || widget.disabled) return;

    final newSelection = Set<String>.from(widget.selectedValues);

    if (checked == true) {
      newSelection.add(value);
    } else {
      newSelection.remove(value);
    }

    widget.onChanged!(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSpacing = widget.spacing ??
        (widget.direction == Axis.vertical ? context.spacing.sm : context.spacing.md);

    // Build checkbox widgets
    final checkboxWidgets = widget.options.map((option) {
      final isSelected = widget.selectedValues.contains(option.value);
      final isDisabled = widget.disabled || option.disabled;

      return Checkbox.labeled(
        value: isSelected,
        onChanged: isDisabled ? null : (value) => _handleOptionChanged(option.value, value),
        label: option.label,
        size: widget.size,
        disabled: isDisabled,
        tooltip: option.tooltip,
        semanticLabel: option.semanticLabel,
      );
    }).toList();

    // Arrange checkboxes
    Widget content;
    if (widget.direction == Axis.vertical) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: checkboxWidgets
            .map((checkbox) => Padding(
                  padding: EdgeInsets.only(bottom: effectiveSpacing),
                  child: checkbox,
                ))
            .toList(),
      );
    } else {
      content = Wrap(
        spacing: effectiveSpacing,
        runSpacing: effectiveSpacing,
        children: checkboxWidgets,
      );
    }

    // Add title if provided
    if (widget.title != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title!,
            style: TokenAdapters.textStyleFromTokens(
              tokenStyle: TokenTextStyle.labelLarge,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.spacing.sm),
          content,
        ],
      );
    }

    return content;
  }
}

/// Option for checkbox group
class CheckboxGroupOption {
  /// Unique value identifier
  final String value;

  /// Display label
  final String label;

  /// Whether this option is disabled
  final bool disabled;

  /// Tooltip for this option
  final String? tooltip;

  /// Semantic label for accessibility
  final String? semanticLabel;

  const CheckboxGroupOption({
    required this.value,
    required this.label,
    this.disabled = false,
    this.tooltip,
    this.semanticLabel,
  });
}