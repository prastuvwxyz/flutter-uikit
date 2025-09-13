import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Type of slider component
enum SliderType {
  /// Single value slider (default)
  single,
  /// Range slider with two handles
  range,
}

/// Size variants for slider components
enum SliderSize {
  /// Small slider
  sm,
  /// Medium slider (default)
  md,
  /// Large slider
  lg,
}

/// A customizable slider component with single and range variants
class CustomSlider extends StatefulWidget {
  /// Current value of the slider
  final double value;

  /// Callback when the value changes
  final ValueChanged<double>? onChanged;

  /// Callback when the user starts changing the value
  final ValueChanged<double>? onChangeStart;

  /// Callback when the user finishes changing the value
  final ValueChanged<double>? onChangeEnd;

  /// Minimum value of the slider
  final double min;

  /// Maximum value of the slider
  final double max;

  /// Number of discrete divisions
  final int? divisions;

  /// Label text for the slider
  final String? label;

  /// Active track color
  final Color? activeColor;

  /// Inactive track color
  final Color? inactiveColor;

  /// Thumb color
  final Color? thumbColor;

  /// Whether to show the value label
  final bool showLabel;

  /// Whether to show value labels on the track
  final bool showTrackLabels;

  /// Custom value formatter
  final String Function(double)? formatter;

  /// Size variant of the slider
  final SliderSize size;

  /// Whether the slider is disabled
  final bool disabled;

  /// Whether to auto-focus the slider
  final bool autofocus;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Tooltip text
  final String? tooltip;

  /// Prefix text to show before the value
  final String? prefix;

  /// Suffix text to show after the value
  final String? suffix;

  /// Whether to show the current value as text
  final bool showValue;

  const CustomSlider({
    super.key,
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
    this.showTrackLabels = false,
    this.formatter,
    this.size = SliderSize.md,
    this.disabled = false,
    this.autofocus = false,
    this.semanticLabel,
    this.tooltip,
    this.prefix,
    this.suffix,
    this.showValue = false,
  }) : assert(min <= max),
       assert(value >= min && value <= max);

  /// Factory for percentage slider (0-100)
  factory CustomSlider.percentage({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    String? label,
    Color? activeColor,
    Color? inactiveColor,
    Color? thumbColor,
    bool showLabel = false,
    bool showTrackLabels = false,
    SliderSize size = SliderSize.md,
    bool disabled = false,
    bool autofocus = false,
    String? semanticLabel,
    String? tooltip,
    bool showValue = true,
  }) {
    return CustomSlider(
      key: key,
      value: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: 0.0,
      max: 100.0,
      divisions: 100,
      label: label,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      thumbColor: thumbColor,
      showLabel: showLabel,
      showTrackLabels: showTrackLabels,
      formatter: (value) => '${value.round()}%',
      size: size,
      disabled: disabled,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      suffix: '%',
      showValue: showValue,
    );
  }

  /// Factory for volume slider (0-100)
  factory CustomSlider.volume({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    String? label,
    Color? activeColor,
    Color? inactiveColor,
    Color? thumbColor,
    bool showLabel = false,
    SliderSize size = SliderSize.md,
    bool disabled = false,
    bool autofocus = false,
    String? semanticLabel,
    String? tooltip,
  }) {
    return CustomSlider(
      key: key,
      value: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: 0.0,
      max: 100.0,
      divisions: 100,
      label: label ?? 'Volume',
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      thumbColor: thumbColor,
      showLabel: showLabel,
      formatter: (value) => '${value.round()}',
      size: size,
      disabled: disabled,
      autofocus: autofocus,
      semanticLabel: semanticLabel ?? 'Volume slider',
      tooltip: tooltip,
      showValue: true,
    );
  }

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> with TickerProviderStateMixin {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value.clamp(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(covariant CustomSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _value = widget.value.clamp(widget.min, widget.max);
      });
    }
  }

  /// Get track height based on size
  double get _trackHeight {
    switch (widget.size) {
      case SliderSize.sm:
        return 2.0;
      case SliderSize.md:
        return 4.0;
      case SliderSize.lg:
        return 6.0;
    }
  }

  /// Get thumb radius based on size
  double get _thumbRadius {
    switch (widget.size) {
      case SliderSize.sm:
        return 8.0;
      case SliderSize.md:
        return 12.0;
      case SliderSize.lg:
        return 16.0;
    }
  }

  /// Format value using custom formatter or default
  String _formatValue(double value) {
    if (widget.formatter != null) {
      return widget.formatter!(value);
    }

    String formatted;
    if (value % 1 == 0) {
      formatted = value.toStringAsFixed(0);
    } else {
      formatted = value.toStringAsFixed(2);
    }

    if (widget.prefix != null) {
      formatted = '${widget.prefix}$formatted';
    }
    if (widget.suffix != null) {
      formatted = '$formatted${widget.suffix}';
    }

    return formatted;
  }

  /// Calculate step size
  double _getStepSize() {
    if (widget.divisions == null || widget.divisions! <= 0) {
      return (widget.max - widget.min) / 100.0;
    }
    return (widget.max - widget.min) / widget.divisions!;
  }

  /// Snap value to division if divisions are specified
  double _snapToDivision(double value) {
    if (widget.divisions == null || widget.divisions! <= 0) {
      return value;
    }

    final step = _getStepSize();
    final steppedValue = ((value - widget.min) / step).round() * step + widget.min;
    return steppedValue.clamp(widget.min, widget.max);
  }

  /// Handle value change
  void _handleValueChange(double value) {
    final snappedValue = _snapToDivision(value);
    if (snappedValue != _value) {
      setState(() {
        _value = snappedValue;
      });
      widget.onChanged?.call(snappedValue);
      HapticFeedback.selectionClick();
    }
  }

  /// Handle change start
  void _handleChangeStart(double value) {
    widget.onChangeStart?.call(value);
  }

  /// Handle change end
  void _handleChangeEnd(double value) {
    widget.onChangeEnd?.call(value);
  }

  /// Build label widget
  Widget? _buildLabel() {
    if (widget.label == null) return null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        widget.label!,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Build track labels
  Widget? _buildTrackLabels() {
    if (!widget.showTrackLabels) return null;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatValue(widget.min),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ) ?? TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            _formatValue(widget.max),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ) ?? TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build current value display
  Widget? _buildValueDisplay() {
    if (!widget.showValue) return null;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        _formatValue(_value),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        ) ?? TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = widget.disabled || widget.onChanged == null;

    // Calculate colors
    final activeColor = widget.activeColor ?? colorScheme.primary;
    final inactiveColor = widget.inactiveColor ?? colorScheme.surfaceContainerHighest;
    final thumbColor = widget.thumbColor ?? colorScheme.onPrimary;

    // Calculate accessibility values
    final stepSize = _getStepSize();
    final increasedValue = (_value + stepSize).clamp(widget.min, widget.max);
    final decreasedValue = (_value - stepSize).clamp(widget.min, widget.max);

    Widget slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: isDisabled
            ? activeColor.withValues(alpha: 0.38)
            : activeColor,
        inactiveTrackColor: isDisabled
            ? inactiveColor.withValues(alpha: 0.38)
            : inactiveColor,
        thumbColor: isDisabled
            ? colorScheme.onSurface.withValues(alpha: 0.38)
            : thumbColor,
        overlayColor: activeColor.withValues(alpha: 0.12),
        valueIndicatorColor: activeColor,
        trackHeight: _trackHeight,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: _thumbRadius),
        overlayShape: RoundSliderOverlayShape(overlayRadius: _thumbRadius * 1.5),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colorScheme.onPrimary,
        ) ?? TextStyle(
          fontSize: 12,
          color: colorScheme.onPrimary,
        ),
        showValueIndicator: widget.showLabel
            ? ShowValueIndicator.onlyForDiscrete
            : ShowValueIndicator.never,
      ),
      child: Slider(
        value: _value,
        onChanged: isDisabled ? null : _handleValueChange,
        onChangeStart: isDisabled ? null : _handleChangeStart,
        onChangeEnd: isDisabled ? null : _handleChangeEnd,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
        label: widget.showLabel ? _formatValue(_value) : null,
        semanticFormatterCallback: (value) => _formatValue(value),
      ),
    );

    // Add semantics
    slider = Semantics(
      label: widget.semanticLabel ?? widget.label ?? 'Slider',
      value: _formatValue(_value),
      increasedValue: _formatValue(increasedValue),
      decreasedValue: _formatValue(decreasedValue),
      enabled: !isDisabled,
      slider: true,
      child: slider,
    );

    // Add tooltip if provided
    if (widget.tooltip != null) {
      slider = Tooltip(
        message: widget.tooltip!,
        child: slider,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_buildLabel() != null) _buildLabel()!,
        slider,
        if (_buildTrackLabels() != null) _buildTrackLabels()!,
        if (_buildValueDisplay() != null) _buildValueDisplay()!,
      ],
    );
  }
}

/// Range slider for selecting a range of values
class CustomRangeSlider extends StatefulWidget {
  /// Current range values
  final RangeValues values;

  /// Callback when the values change
  final ValueChanged<RangeValues>? onChanged;

  /// Callback when the user starts changing the values
  final ValueChanged<RangeValues>? onChangeStart;

  /// Callback when the user finishes changing the values
  final ValueChanged<RangeValues>? onChangeEnd;

  /// Minimum value
  final double min;

  /// Maximum value
  final double max;

  /// Number of discrete divisions
  final int? divisions;

  /// Label text for the slider
  final String? label;

  /// Active track color
  final Color? activeColor;

  /// Inactive track color
  final Color? inactiveColor;

  /// Thumb color
  final Color? thumbColor;

  /// Whether to show the value labels
  final bool showLabels;

  /// Whether to show value labels on the track
  final bool showTrackLabels;

  /// Custom value formatter
  final String Function(double)? formatter;

  /// Size variant of the slider
  final SliderSize size;

  /// Whether the slider is disabled
  final bool disabled;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Whether to show current values as text
  final bool showValues;

  const CustomRangeSlider({
    super.key,
    required this.values,
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
    this.showLabels = false,
    this.showTrackLabels = false,
    this.formatter,
    this.size = SliderSize.md,
    this.disabled = false,
    this.semanticLabel,
    this.showValues = false,
  });

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    assert(widget.min <= widget.max, 'min must be less than or equal to max');
    assert(widget.values.start >= widget.min && widget.values.start <= widget.max, 'values.start must be between min and max');
    assert(widget.values.end >= widget.min && widget.values.end <= widget.max, 'values.end must be between min and max');
    assert(widget.values.start <= widget.values.end, 'values.start must be less than or equal to values.end');

    _values = RangeValues(
      widget.values.start.clamp(widget.min, widget.max),
      widget.values.end.clamp(widget.min, widget.max),
    );
  }

  @override
  void didUpdateWidget(covariant CustomRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      setState(() {
        _values = RangeValues(
          widget.values.start.clamp(widget.min, widget.max),
          widget.values.end.clamp(widget.min, widget.max),
        );
      });
    }
  }

  /// Get track height based on size
  double get _trackHeight {
    switch (widget.size) {
      case SliderSize.sm:
        return 2.0;
      case SliderSize.md:
        return 4.0;
      case SliderSize.lg:
        return 6.0;
    }
  }

  /// Get thumb radius based on size
  double get _thumbRadius {
    switch (widget.size) {
      case SliderSize.sm:
        return 8.0;
      case SliderSize.md:
        return 12.0;
      case SliderSize.lg:
        return 16.0;
    }
  }

  /// Format value using custom formatter or default
  String _formatValue(double value) {
    if (widget.formatter != null) {
      return widget.formatter!(value);
    }

    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  /// Handle value change
  void _handleValueChange(RangeValues values) {
    setState(() {
      _values = values;
    });
    widget.onChanged?.call(values);
    HapticFeedback.selectionClick();
  }

  /// Build label widget
  Widget? _buildLabel() {
    if (widget.label == null) return null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        widget.label!,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Build track labels
  Widget? _buildTrackLabels() {
    if (!widget.showTrackLabels) return null;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatValue(widget.min),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ) ?? TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            _formatValue(widget.max),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ) ?? TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build current values display
  Widget? _buildValuesDisplay() {
    if (!widget.showValues) return null;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        '${_formatValue(_values.start)} - ${_formatValue(_values.end)}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        ) ?? TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = widget.disabled || widget.onChanged == null;

    // Calculate colors
    final activeColor = widget.activeColor ?? colorScheme.primary;
    final inactiveColor = widget.inactiveColor ?? colorScheme.surfaceContainerHighest;
    final thumbColor = widget.thumbColor ?? colorScheme.onPrimary;

    Widget rangeSlider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: isDisabled
            ? activeColor.withValues(alpha: 0.38)
            : activeColor,
        inactiveTrackColor: isDisabled
            ? inactiveColor.withValues(alpha: 0.38)
            : inactiveColor,
        thumbColor: isDisabled
            ? colorScheme.onSurface.withValues(alpha: 0.38)
            : thumbColor,
        overlayColor: activeColor.withValues(alpha: 0.12),
        valueIndicatorColor: activeColor,
        trackHeight: _trackHeight,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: _thumbRadius),
        overlayShape: RoundSliderOverlayShape(overlayRadius: _thumbRadius * 1.5),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colorScheme.onPrimary,
        ) ?? TextStyle(
          fontSize: 12,
          color: colorScheme.onPrimary,
        ),
        showValueIndicator: widget.showLabels
            ? ShowValueIndicator.onlyForDiscrete
            : ShowValueIndicator.never,
        rangeValueIndicatorShape: const PaddleRangeSliderValueIndicatorShape(),
      ),
      child: RangeSlider(
        values: _values,
        onChanged: isDisabled ? null : _handleValueChange,
        onChangeStart: widget.onChangeStart,
        onChangeEnd: widget.onChangeEnd,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
      ),
    );

    // Add semantics
    rangeSlider = Semantics(
      label: widget.semanticLabel ?? widget.label ?? 'Range slider',
      value: '${_formatValue(_values.start)} to ${_formatValue(_values.end)}',
      enabled: !isDisabled,
      slider: true,
      child: rangeSlider,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_buildLabel() != null) _buildLabel()!,
        rangeSlider,
        if (_buildTrackLabels() != null) _buildTrackLabels()!,
        if (_buildValuesDisplay() != null) _buildValuesDisplay()!,
      ],
    );
  }
}