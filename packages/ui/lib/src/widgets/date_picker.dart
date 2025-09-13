import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DatePickerMode { day, month, year }

class DatePicker extends StatefulWidget {
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final DatePickerMode mode;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final DateFormat? format;
  final bool enabled;
  final bool readOnly;
  final bool showClearButton;

  const DatePicker({
    super.key,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.mode = DatePickerMode.day,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.format,
    this.enabled = true,
    this.readOnly = false,
    this.showClearButton = true,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late TextEditingController _controller;
  late DateFormat _format;

  @override
  void initState() {
    super.initState();
    _format = widget.format ?? DateFormat.yMd();
    _controller = TextEditingController(text: _displayValue(widget.value));
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = _displayValue(widget.value);
    }
    if (widget.format != oldWidget.format) {
      _format = widget.format ?? DateFormat.yMd();
      _controller.text = _displayValue(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _displayValue(DateTime? v) {
    if (v == null) return '';
    try {
      return _format.format(v);
    } catch (_) {
      return v.toIso8601String();
    }
  }

  void _openCalendar() async {
    if (!widget.enabled) return;
    if (widget.readOnly && widget.onChanged == null) return;

    final initial = widget.value ?? widget.initialDate ?? DateTime.now();
    final first = widget.firstDate ?? DateTime(1900);
    final last = widget.lastDate ?? DateTime(2100);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      helpText: widget.label,
    );

    if (picked != null) {
      widget.onChanged?.call(picked);
      _controller.text = _displayValue(picked);
    }
  }

  void _clearDate() {
    if (!widget.enabled || !widget.showClearButton) return;
    widget.onChanged?.call(null);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.enabled
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.38),
            ),
          ),
          SizedBox(height: 4),
        ],
        GestureDetector(
          onTap: widget.enabled ? _openCalendar : null,
          child: AbsorbPointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.errorText != null
                    ? colorScheme.error
                    : widget.enabled
                      ? colorScheme.outline
                      : colorScheme.outline.withValues(alpha: 0.38),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      readOnly: true,
                      enabled: widget.enabled,
                      decoration: InputDecoration(
                        hintText: widget.placeholder,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                        suffixIcon: widget.showClearButton && widget.value != null
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: widget.enabled
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                                ),
                                onPressed: widget.enabled ? _clearDate : null,
                                tooltip: 'Clear date',
                              )
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.calendar_today,
                      color: widget.enabled
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.helperText != null || widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              widget.errorText ?? widget.helperText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: widget.errorText != null
                  ? colorScheme.error
                  : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}