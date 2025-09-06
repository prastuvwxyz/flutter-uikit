import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui_tokens/ui_tokens.dart';

enum DateTimePickerMode { date, time, dateAndTime }

class MinimalDateTimePicker extends StatefulWidget {
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
  final String? helperText;
  final String? errorText;
  final DateTimePickerMode mode;

  const MinimalDateTimePicker({
    Key? key,
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
    this.helperText,
    this.errorText,
    this.mode = DateTimePickerMode.dateAndTime,
  }) : super(key: key);

  @override
  State<MinimalDateTimePicker> createState() => _MinimalDateTimePickerState();
}

class _MinimalDateTimePickerState extends State<MinimalDateTimePicker> {
  late DateTime? _selected;
  late DateFormat _format;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDateTime;
    _format = widget.dateFormat ?? DateFormat.yMd().add_jm();
  }

  @override
  void didUpdateWidget(covariant MinimalDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDateTime != oldWidget.initialDateTime) {
      _selected = widget.initialDateTime;
    }
    if (widget.dateFormat != oldWidget.dateFormat) {
      _format = widget.dateFormat ?? DateFormat.yMd().add_jm();
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
        helpText: null,
      );
      if (pickedDate == null && widget.mode == DateTimePickerMode.date) return;
    }

    if (widget.mode == DateTimePickerMode.time ||
        widget.mode == DateTimePickerMode.dateAndTime) {
      final initialTime = TimeOfDay.fromDateTime(current);
      pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        helpText: null,
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

    // apply minute interval
    if (widget.minuteInterval > 1) {
      final int m =
          ((result.minute / widget.minuteInterval).round()) *
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
    if (_selected == null) return '';
    try {
      return _format.format(_selected!);
    } catch (_) {
      return _selected!.toIso8601String();
    }
  }

  void _clear() {
    if (!widget.enabled) return;
    setState(() => _selected = null);
    widget.onDateTimeChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final colors = tokens.colorTokens;
    final typography = tokens.typographyTokens;
    final spacing = tokens.spacingTokens;
    final radius = tokens.radiusTokens;

    final hasError = widget.errorText != null;
    final borderColor = !widget.enabled
        ? colors.neutral.shade300
        : hasError
        ? colors.error
        : colors.neutral.shade400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _openPicker,
          child: AbsorbPointer(
            absorbing: true,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.0),
                borderRadius: BorderRadius.circular(radius.md),
                color: tokens.colorTokens.neutral[50],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _display(),
                          style: typography.bodyMedium.copyWith(
                            color: _selected == null
                                ? colors.neutral.shade400
                                : colors.neutral.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selected != null)
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                        color: colors.neutral.shade600,
                      ),
                      onPressed: widget.enabled ? _clear : null,
                      tooltip: 'Clear',
                    ),
                  Icon(
                    Icons.event,
                    color: widget.enabled
                        ? colors.neutral.shade600
                        : colors.neutral.shade400,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.helperText != null || hasError)
          Padding(
            padding: EdgeInsets.only(left: spacing.md, top: spacing.sm / 2),
            child: Text(
              hasError ? widget.errorText! : widget.helperText!,
              style: typography.labelSmall.copyWith(
                color: hasError ? colors.error : colors.neutral.shade500,
              ),
            ),
          ),
      ],
    );
  }
}
