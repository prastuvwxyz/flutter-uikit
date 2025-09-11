import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// MinimalSlider: lightweight, accessible slider with optional divisions, label,
/// custom formatter, and theming via colors.
class MinimalSlider extends StatefulWidget {
  const MinimalSlider({
    Key? key,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.showLabel = false,
    this.formatter,
  }) : assert(min <= max),
       super(key: key);

  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final bool showLabel;
  final String Function(double)? formatter;

  @override
  State<MinimalSlider> createState() => _MinimalSliderState();
}

/// Example:
///
/// MinimalSlider(
///   value: 0.5,
///   min: 0.0,
///   max: 1.0,
///   divisions: 10,
///   label: 'Opacity',
///   showLabel: true,
///   formatter: (v) => '${(v * 100).round()}%',
///   onChanged: (v) => print('value: $v'),
/// )

class _MinimalSliderState extends State<MinimalSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value.clamp(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(covariant MinimalSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() => _value = widget.value.clamp(widget.min, widget.max));
    }
  }

  String _format(double v) {
    if (widget.formatter != null) return widget.formatter!(v);
    if (v % 1 == 0) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool disabled = widget.onChanged == null;

    final active = widget.activeColor ?? theme.colorScheme.primary;
    final inactive = widget.inactiveColor ?? theme.colorScheme.surfaceVariant;
    final thumb = widget.thumbColor ?? theme.colorScheme.onPrimary;

    return Semantics(
      label: widget.label,
      value: _format(_value),
      increasedValue: _format(
        ((_value + _step()).clamp(widget.min, widget.max)),
      ),
      decreasedValue: _format(
        ((_value - _step()).clamp(widget.min, widget.max)),
      ),
      enabled: !disabled,
      slider: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(widget.label!, style: theme.textTheme.bodyMedium),
            ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: active,
              inactiveTrackColor: inactive,
              thumbColor: thumb,
              overlayColor: (active).withOpacity(0.12),
              trackHeight: 4,
              valueIndicatorColor: active,
            ),
            child: Slider(
              value: _value.clamp(widget.min, widget.max),
              onChanged: widget.onChanged == null
                  ? null
                  : (v) {
                      final stepped = _snapToDivision(v);
                      widget.onChanged?.call(stepped);
                      setState(() => _value = stepped);
                    },
              onChangeStart: widget.onChangeStart,
              onChangeEnd: widget.onChangeEnd,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              label: widget.showLabel ? _format(_value) : null,
            ),
          ),
        ],
      ),
    );
  }

  double _step() {
    if (widget.divisions == null || widget.divisions! <= 0) {
      // assume small step relative to range
      return (widget.max - widget.min) / 100.0;
    }
    return (widget.max - widget.min) / widget.divisions!;
  }

  double _snapToDivision(double v) {
    if (widget.divisions == null || widget.divisions! <= 0) return v;
    final step = _step();
    final n = ((v - widget.min) / step).round();
    return (widget.min + n * step).clamp(widget.min, widget.max);
  }
}
