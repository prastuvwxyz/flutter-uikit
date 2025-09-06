library ui_components.date_picker.minimal_date_picker;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DatePickerMode { day, month, year }

class MinimalDatePicker extends StatefulWidget {
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

  const MinimalDatePicker({
    Key? key,
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
  }) : super(key: key);

  @override
  State<MinimalDatePicker> createState() => _MinimalDatePickerState();
}

class _MinimalDatePickerState extends State<MinimalDatePicker> {
  late TextEditingController _controller;
  late DateFormat _format;

  @override
  void initState() {
    super.initState();
    _format = widget.format ?? DateFormat.yMd();
    _controller = TextEditingController(text: _displayValue(widget.value));
  }

  @override
  void didUpdateWidget(covariant MinimalDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = _displayValue(widget.value);
    }
    if (widget.format != oldWidget.format) {
      _format = widget.format ?? DateFormat.yMd();
      _controller.text = _displayValue(widget.value);
    }
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

    // mark opening state (not used visually yet)
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

    // closing

    if (picked != null) {
      widget.onChanged?.call(picked);
      _controller.text = _displayValue(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: theme.textTheme.bodyMedium),
          SizedBox(height: 4),
        ],
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                readOnly: true,
                enabled: widget.enabled,
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  helperText: widget.helperText,
                  errorText: widget.errorText,
                  suffixIcon: widget.showClearButton && widget.value != null
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: widget.enabled
                              ? () {
                                  widget.onChanged?.call(null);
                                  _controller.clear();
                                }
                              : null,
                        )
                      : null,
                ),
                onTap: widget.readOnly ? _openCalendar : _openCalendar,
              ),
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: widget.enabled ? _openCalendar : null,
            ),
          ],
        ),
      ],
    );
  }
}
