import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?>? onChanged;
  final bool is24HourFormat;
  final int minuteInterval;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final bool showClearButton;
  final TimeOfDay? initialTime;

  const TimePicker({
    super.key,
    this.value,
    this.onChanged,
    this.is24HourFormat = false,
    this.minuteInterval = 1,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.showClearButton = true,
    this.initialTime,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value ?? widget.initialTime;
  }

  @override
  void didUpdateWidget(covariant TimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selected = widget.value;
    }
  }

  Future<void> _openPicker() async {
    if (!widget.enabled || widget.readOnly || widget.onChanged == null) return;

    final initial = _selected ?? TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: widget.label,
    );

    if (picked != null) {
      // Apply minute interval snapping
      final int minute = (picked.minute / widget.minuteInterval).round() *
          widget.minuteInterval;
      final snapped = TimeOfDay(hour: picked.hour, minute: minute % 60);
      setState(() => _selected = snapped);
      widget.onChanged?.call(snapped);
    }
  }

  void _clear() {
    if (!widget.enabled || !widget.showClearButton) return;
    setState(() => _selected = null);
    widget.onChanged?.call(null);
  }

  String _format(TimeOfDay? t) {
    if (t == null) return widget.placeholder ?? '';
    final hour = widget.is24HourFormat
        ? t.hour.toString().padLeft(2, '0')
        : ((t.hourOfPeriod == 0) ? 12 : t.hourOfPeriod).toString();
    final minute = t.minute.toString().padLeft(2, '0');
    final ampm =
        widget.is24HourFormat ? '' : (t.period == DayPeriod.am ? ' AM' : ' PM');
    return '$hour:$minute$ampm';
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
                      _format(_selected),
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
                    Icons.access_time,
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
}