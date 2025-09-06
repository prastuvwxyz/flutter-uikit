import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

/// MinimalTimePicker
/// - Shows a field with label/placeholder/helperText and opens a time picker dialog
/// - Supports 12/24 hour format, minute interval, clearing, enabled/readOnly
class MinimalTimePicker extends StatefulWidget {
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

  const MinimalTimePicker({
    Key? key,
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
  }) : super(key: key);

  @override
  State<MinimalTimePicker> createState() => _MinimalTimePickerState();
}

class _MinimalTimePickerState extends State<MinimalTimePicker> {
  TimeOfDay? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value ?? widget.initialTime;
  }

  @override
  void didUpdateWidget(covariant MinimalTimePicker oldWidget) {
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
      builder: (context, child) {
        // Allow tokens/theme to be applied; keep default otherwise
        return child ?? const SizedBox.shrink();
      },
      helpText: widget.label,
    );

    if (picked != null) {
      // Apply minute interval snapping
      final int minute =
          (picked.minute / widget.minuteInterval).round() *
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
        ? t.hour
        : ((t.hourOfPeriod == 0) ? 12 : t.hourOfPeriod);
    final minute = t.minute.toString().padLeft(2, '0');
    final ampm = widget.is24HourFormat
        ? ''
        : (t.period == DayPeriod.am ? ' AM' : ' PM');
    return '$hour:$minute$ampm';
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
                        if (widget.label != null)
                          Text(
                            widget.label!,
                            style: typography.labelSmall.copyWith(
                              color: !widget.enabled
                                  ? colors.neutral.shade400
                                  : colors.neutral.shade700,
                            ),
                          ),
                        Text(
                          _format(_selected),
                          style: typography.bodyMedium.copyWith(
                            color: _selected == null
                                ? colors.neutral.shade400
                                : colors.neutral.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.showClearButton && _selected != null)
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
                    Icons.access_time,
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
