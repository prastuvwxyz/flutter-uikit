import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A text input field that automatically adjusts its height based on content.
/// Lightweight, accessible, and with optional character count.
class MinimalTextareaAutosize extends StatefulWidget {
  const MinimalTextareaAutosize({
    super.key,
    this.controller,
    this.initialValue,
    this.placeholder,
    this.minLines = 1,
    this.maxLines,
    this.minHeight,
    this.maxHeight,
    this.maxLength,
    this.showCharacterCount = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.multiline,
    this.textInputAction,
    this.style,
    this.decoration,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? placeholder;
  final int minLines;
  final int? maxLines;
  final double? minHeight;
  final double? maxHeight;
  final int? maxLength;
  final bool showCharacterCount;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final InputDecoration? decoration;
  final Duration animationDuration;

  @override
  State<MinimalTextareaAutosize> createState() =>
      _MinimalTextareaAutosizeState();
}

class _MinimalTextareaAutosizeState extends State<MinimalTextareaAutosize> {
  late TextEditingController _controller;
  double _currentHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_handleTextChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateHeight();
    });
  }

  @override
  void didUpdateWidget(covariant MinimalTextareaAutosize oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller &&
        widget.controller != null) {
      _controller.removeListener(_handleTextChange);
      _controller = widget.controller!;
      _controller.addListener(_handleTextChange);
      _calculateHeight();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    _calculateHeight();
    widget.onChanged?.call(_controller.text);
  }

  double _getPadding() {
    // provide a small vertical padding estimation
    return 16.0;
  }

  double _getTextWidth() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return MediaQuery.of(context).size.width;
    return box.size.width - 16.0; // assume horizontal padding
  }

  void _calculateHeight() {
    final text = _controller.text.isEmpty
        ? (widget.placeholder ?? '')
        : _controller.text;
    final effectiveStyle =
        widget.style ?? Theme.of(context).textTheme.bodyLarge!;

    final tp = TextPainter(
      text: TextSpan(text: text, style: effectiveStyle),
      textDirection: widget.textDirection ?? Directionality.of(context),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines ?? 10000,
    );

    tp.layout(maxWidth: math.max(0.0, _getTextWidth()));
    double newHeight = tp.height + _getPadding();

    if (widget.minHeight != null)
      newHeight = math.max(newHeight, widget.minHeight!);
    if (widget.maxHeight != null)
      newHeight = math.min(newHeight, widget.maxHeight!);

    if ((newHeight - _currentHeight).abs() > 0.5) {
      setState(() {
        _currentHeight = newHeight;
      });
    }
  }

  Widget _buildCharacterCount() {
    if (!widget.showCharacterCount) return const SizedBox.shrink();

    final currentLength = _controller.text.length;
    final maxLength = widget.maxLength;
    final isOverLimit = maxLength != null && currentLength > maxLength;

    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: isOverLimit
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            maxLength != null ? '$currentLength/$maxLength' : '$currentLength',
            style: style,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decoration =
        widget.decoration ??
        const InputDecoration(border: OutlineInputBorder());

    return Semantics(
      textField: true,
      multiline: true,
      enabled: widget.enabled,
      label: decoration.labelText,
      hint: widget.placeholder,
      value: _controller.text,
      maxValueLength: widget.maxLength,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedContainer(
            duration: widget.animationDuration,
            curve: Curves.easeInOut,
            height: _currentHeight > 0 ? _currentHeight : null,
            constraints: BoxConstraints(
              minHeight: widget.minHeight ?? 0,
              maxHeight: widget.maxHeight ?? double.infinity,
            ),
            child: TextFormField(
              controller: _controller,
              initialValue: widget.controller == null
                  ? widget.initialValue
                  : null,
              focusNode: widget.focusNode,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
              textCapitalization: widget.textCapitalization,
              keyboardType: widget.keyboardType,
              textInputAction:
                  widget.textInputAction ?? TextInputAction.newline,
              style: widget.style,
              decoration: decoration.copyWith(counterText: ''),
              maxLines: widget.maxLines ?? null,
              minLines: widget.minLines,
              validator: widget.validator,
              onFieldSubmitted: widget.onSubmitted,
              maxLength: widget.maxLength,
            ),
          ),
          _buildCharacterCount(),
        ],
      ),
    );
  }
}
