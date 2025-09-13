import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateTimePickerMode { date, time, dateAndTime }

class DateTimePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime?>? onDateTimeChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat? dateFormat;
  final bool use24hFormat;
  final int minuteInterval;
  final bool showSeconds;
  final bool enabled;
  final bool readOnly;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final DateTimePickerMode mode;
  final bool showClearButton;

  const DateTimePicker({
    super.key,
    this.initialDateTime,
    this.onDateTimeChanged,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.use24hFormat = false,
    this.minuteInterval = 1,
    this.showSeconds = false,
    this.enabled = true,
    this.readOnly = false,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.mode = DateTimePickerMode.dateAndTime,
    this.showClearButton = true,
  });

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime? _selected;
  late DateFormat _format;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDateTime;
    _format = widget.dateFormat ?? _getDefaultFormat();
  }

  @override
  void didUpdateWidget(covariant DateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDateTime != oldWidget.initialDateTime) {
      _selected = widget.initialDateTime;
    }
    if (widget.dateFormat != oldWidget.dateFormat) {
      _format = widget.dateFormat ?? _getDefaultFormat();
    }
  }

  DateFormat _getDefaultFormat() {
    switch (widget.mode) {
      case DateTimePickerMode.date:
        return DateFormat.yMd();
      case DateTimePickerMode.time:
        return widget.use24hFormat ? DateFormat.Hm() : DateFormat.jm();
      case DateTimePickerMode.dateAndTime:
        return widget.use24hFormat
          ? DateFormat.yMd().add_Hm()
          : DateFormat.yMd().add_jm();
    }
  }

  Future<void> _openPicker() async {
    if (!widget.enabled || widget.readOnly || widget.onDateTimeChanged == null)
      return;

    DateTime current = _selected ?? DateTime.now();

    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    if (widget.mode == DateTimePickerMode.date ||
        widget.mode == DateTimePickerMode.dateAndTime) {
      pickedDate = await showDatePicker(
        context: context,
        initialDate: current,
        firstDate: widget.firstDate ?? DateTime(1900),
        lastDate: widget.lastDate ?? DateTime(2100),
        helpText: widget.label,
      );
      if (pickedDate == null && widget.mode == DateTimePickerMode.date) return;
    }

    if (widget.mode == DateTimePickerMode.time ||
        widget.mode == DateTimePickerMode.dateAndTime) {
      final initialTime = TimeOfDay.fromDateTime(current);
      pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        helpText: widget.label,
      );
      if (pickedTime == null && widget.mode == DateTimePickerMode.time) return;
    }

    DateTime result;
    if (widget.mode == DateTimePickerMode.date) {
      result = DateTime(
        pickedDate!.year,
        pickedDate.month,
        pickedDate.day,
        current.hour,
        current.minute,
      );
    } else if (widget.mode == DateTimePickerMode.time) {
      final t = pickedTime!;
      result = DateTime(
        current.year,
        current.month,
        current.day,
        t.hour,
        t.minute,
      );
    } else {
      final d = pickedDate ?? current;
      final t = pickedTime ?? TimeOfDay.fromDateTime(current);
      result = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    }

    // Apply minute interval
    if (widget.minuteInterval > 1) {
      final int m = ((result.minute / widget.minuteInterval).round()) *
          widget.minuteInterval;
      result = DateTime(
        result.year,
        result.month,
        result.day,
        result.hour,
        m % 60,
      );
    }

    setState(() => _selected = result);
    widget.onDateTimeChanged?.call(result);
  }

  String _display() {
    if (_selected == null) return widget.placeholder ?? '';
    try {
      return _format.format(_selected!);
    } catch (_) {
      return _selected!.toIso8601String();
    }
  }

  void _clear() {
    if (!widget.enabled || !widget.showClearButton) return;
    setState(() => _selected = null);
    widget.onDateTimeChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasError = widget.errorText != null;
    final borderColor = !widget.enabled
        ? colorScheme.outline.withValues(alpha: 0.38)
        : hasError
            ? colorScheme.error
            : colorScheme.outline;

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
          onTap: widget.enabled ? _openPicker : null,
          child: AbsorbPointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
                color: theme.colorScheme.surface,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _display(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _selected == null
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (widget.showClearButton && _selected != null)
                    GestureDetector(
                      onTap: widget.enabled ? _clear : null,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.clear,
                          size: 20,
                          color: widget.enabled
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  Icon(
                    _getIcon(),
                    color: widget.enabled
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.helperText != null || hasError)
          Padding(
            padding: EdgeInsets.only(top: 4, left: 12),
            child: Text(
              hasError ? widget.errorText! : widget.helperText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  IconData _getIcon() {
    switch (widget.mode) {
      case DateTimePickerMode.date:
        return Icons.calendar_today;
      case DateTimePickerMode.time:
        return Icons.access_time;
      case DateTimePickerMode.dateAndTime:
        return Icons.event;
    }
  }
}