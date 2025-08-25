import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_components/src/checkbox/checkbox_types.dart';
import 'package:ui_tokens/ui_tokens.dart';

/// A customizable checkbox component that supports checked, unchecked, and indeterminate states
/// with support for labels, descriptions, error messages, and different sizes.
class MinimalCheckbox extends StatefulWidget {
  /// Creates a MinimalCheckbox.
  ///
  /// The [value] can be true (checked), false (unchecked), or null (indeterminate).
  /// If [onChanged] is null, the checkbox will be disabled.
  const MinimalCheckbox({
    Key? key,
    this.value = false,
    this.onChanged,
    this.label,
    this.description,
    this.required = false,
    this.error,
    this.size = CheckboxSize.md,
    this.labelPosition = CheckboxLabelPosition.right,
  }) : super(key: key);

  /// The current value of the checkbox.
  /// - true: checked
  /// - false: unchecked
  /// - null: indeterminate
  final bool? value;

  /// Called when the value of the checkbox changes.
  /// If null, the checkbox will be disabled.
  final ValueChanged<bool?>? onChanged;

  /// The label displayed next to the checkbox.
  final String? label;

  /// Helper text displayed below the label.
  final String? description;

  /// Whether the checkbox is required.
  final bool required;

  /// Error message displayed when there's a validation error.
  final String? error;

  /// The size of the checkbox (sm, md, lg).
  final CheckboxSize size;

  /// The position of the label relative to the checkbox.
  final CheckboxLabelPosition labelPosition;

  @override
  State<MinimalCheckbox> createState() => _MinimalCheckboxState();
}

class _MinimalCheckboxState extends State<MinimalCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFocused = false;
  bool _isHovered = false;

  bool get _isDisabled => widget.onChanged == null;
  bool get _hasError => widget.error != null && widget.error!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 200,
      ), // Default duration until we get tokens
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Default curve until we get tokens
    );
    _updateAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update with correct tokens
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    _controller.duration = tokens.motionTokens.md;
    _animation = CurvedAnimation(
      parent: _controller,
      curve: tokens.motionTokens.standard,
    );
  }

  @override
  void didUpdateWidget(MinimalCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    if (widget.value == true) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Get appropriate checkbox size based on size variant
  double _getCheckboxSize() {
    switch (widget.size) {
      case CheckboxSize.sm:
        return 16.0;
      case CheckboxSize.md:
        return 20.0;
      case CheckboxSize.lg:
        return 24.0;
    }
  }

  // Build the checkbox itself
  Widget _buildCheckbox() {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final checkboxSize = _getCheckboxSize();
    final borderRadius = tokens.radiusTokens.sm;
    Color borderColor;
    Color fillColor;

    // Determine colors based on state
    if (_isDisabled) {
      borderColor = Colors.grey[400]!.withOpacity(
        0.5,
      ); // outline color with opacity
      fillColor = Colors.transparent;
    } else if (_hasError) {
      borderColor = tokens.colorTokens.error[500]!;
      fillColor = widget.value == true
          ? tokens.colorTokens.error[500]!
          : Colors.transparent;
    } else if (_isFocused || _isHovered) {
      borderColor = tokens.colorTokens.primary.shade500;
      fillColor = widget.value == true
          ? tokens.colorTokens.primary.shade500
          : Colors.transparent;
    } else {
      borderColor = widget.value == true
          ? tokens.colorTokens.primary.shade500
          : Colors.grey[400]!; // outline color
      fillColor = widget.value == true
          ? tokens.colorTokens.primary.shade500
          : Colors.transparent;
    }

    return AnimatedContainer(
      duration: tokens.motionTokens.md,
      curve: tokens.motionTokens.standard,
      width: checkboxSize,
      height: checkboxSize,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(
        child: widget.value == null
            // Indeterminate state (horizontal line)
            ? Container(
                width: checkboxSize * 0.6,
                height: 2,
                color: _isDisabled
                    ? Colors.white.withOpacity(0.5) // onPrimary with opacity
                    : Colors.white, // onPrimary for checked state
              )
            // Checked state (checkmark)
            : widget.value == true
            ? AnimatedOpacity(
                opacity: _animation.value,
                duration: tokens.motionTokens.md,
                child: Icon(
                  Icons.check,
                  size: checkboxSize * 0.7,
                  color: _isDisabled
                      ? Colors.white.withOpacity(0.5) // onPrimary with opacity
                      : Colors.white, // onPrimary for checked state
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  // Build the label content
  Widget _buildLabelContent() {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();

    if (widget.label == null &&
        !widget.required &&
        widget.description == null &&
        !_hasError) {
      return const SizedBox.shrink();
    }

    final TextStyle labelStyle = widget.size == CheckboxSize.sm
        ? tokens.typographyTokens.bodySmall
        : tokens.typographyTokens.bodyMedium;

    final TextStyle descriptionStyle = tokens.typographyTokens.labelSmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null || widget.required)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: labelStyle.copyWith(
                    color: _isDisabled
                        ? Colors.grey[400]!.withOpacity(
                            0.7,
                          ) // outline with opacity
                        : _hasError
                        ? tokens.colorTokens.error[500]
                        : null,
                  ),
                ),
              if (widget.required)
                Text(
                  ' *',
                  style: labelStyle.copyWith(
                    color: _isDisabled
                        ? Colors.grey[400]!.withOpacity(
                            0.7,
                          ) // outline with opacity
                        : tokens.colorTokens.error[500],
                  ),
                ),
            ],
          ),
        if (widget.description != null) ...[
          SizedBox(height: tokens.spacingTokens.sm / 2),
          Text(
            widget.description!,
            style: descriptionStyle.copyWith(
              color: _isDisabled
                  ? Colors.grey[400]!.withOpacity(0.7) // outline with opacity
                  : Colors.grey[400], // outline
            ),
          ),
        ],
        if (_hasError) ...[
          SizedBox(height: tokens.spacingTokens.sm / 2),
          Text(
            widget.error!,
            style: descriptionStyle.copyWith(
              color: tokens.colorTokens.error[500],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();

    // Determine layout based on label position
    Widget content;
    final spacing = widget.size == CheckboxSize.sm
        ? tokens.spacingTokens.sm
        : tokens.spacingTokens.md;

    final checkbox = _buildCheckbox();
    final label = _buildLabelContent();

    if (widget.labelPosition.isHorizontal) {
      // Horizontal layout (left/right)
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: widget.labelPosition == CheckboxLabelPosition.left
            ? TextDirection.rtl
            : TextDirection.ltr,
        children: [
          checkbox,
          SizedBox(width: spacing),
          Flexible(child: label),
        ],
      );
    } else {
      // Vertical layout (top/bottom)
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: widget.labelPosition == CheckboxLabelPosition.top
            ? VerticalDirection.up
            : VerticalDirection.down,
        children: [
          checkbox,
          SizedBox(height: spacing),
          label,
        ],
      );
    }

    // Wrap in mouse region and focus detection
    return MouseRegion(
      cursor: _isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: FocusableActionDetector(
          mouseCursor: _isDisabled
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          focusNode: FocusNode(),
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          actions: <Type, Action<Intent>>{},
          shortcuts: <LogicalKeySet, Intent>{},
          child: Semantics(
            checked: widget.value,
            container: true,
            enabled: !_isDisabled,
            label: widget.label,
            child: ExcludeSemantics(
              child: Container(
                // Make the tap target at least 44x44 for a11y
                constraints: const BoxConstraints(
                  minHeight: 44.0,
                  minWidth: 44.0,
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Handle toggle
  void _handleTap() {
    if (_isDisabled) return;

    // If indeterminate (null), make it checked (true)
    // If checked (true), make it unchecked (false)
    // If unchecked (false), make it checked (true)
    final newValue = (widget.value == null) ? true : !widget.value!;
    widget.onChanged?.call(newValue);
  }
}
