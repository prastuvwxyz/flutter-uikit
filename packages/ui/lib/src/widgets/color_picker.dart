import 'package:flutter/material.dart';
import 'dart:math';

class ColorPicker extends StatefulWidget {
  final Color color;
  final ValueChanged<Color>? onColorChanged;
  final bool showLabel;
  final bool showAlpha;
  final bool showRecentColors;
  final List<Color> recentColors;
  final bool showMaterialColors;
  final bool showCustomInput;
  final int colorHistory;
  final Size? size;
  final BorderRadius? borderRadius;
  final double wheelWidth;

  const ColorPicker({
    Key? key,
    this.color = Colors.blue,
    this.onColorChanged,
    this.showLabel = true,
    this.showAlpha = false,
    this.showRecentColors = true,
    this.recentColors = const [],
    this.showMaterialColors = true,
    this.showCustomInput = true,
    this.colorHistory = 10,
    this.size,
    this.borderRadius,
    this.wheelWidth = 20.0,
  }) : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _color;
  late TextEditingController _hexController;
  late List<Color> _recent;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
    _hexController = TextEditingController(
      text: _colorToHex(_color, includeAlpha: widget.showAlpha),
    );
    _recent = List<Color>.from(widget.recentColors);
  }

  @override
  void didUpdateWidget(covariant ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _color = widget.color;
      _hexController.text = _colorToHex(_color, includeAlpha: widget.showAlpha);
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color c, {bool includeAlpha = false}) {
    if (includeAlpha) {
      return '#${((c.a * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}${((c.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}${((c.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}${((c.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
    }
    return '#${((c.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}${((c.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}${((c.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  Color? _hexToColor(String hex) {
    final h = hex.replaceAll('#', '').trim();
    if (h.length == 6) {
      try {
        final r = int.parse(h.substring(0, 2), radix: 16);
        final g = int.parse(h.substring(2, 4), radix: 16);
        final b = int.parse(h.substring(4, 6), radix: 16);
        return Color.fromARGB(0xFF, r, g, b);
      } catch (_) {
        return null;
      }
    }
    if (h.length == 8) {
      try {
        final a = int.parse(h.substring(0, 2), radix: 16);
        final r = int.parse(h.substring(2, 4), radix: 16);
        final g = int.parse(h.substring(4, 6), radix: 16);
        final b = int.parse(h.substring(6, 8), radix: 16);
        return Color.fromARGB(a, r, g, b);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  void _applyColor(Color c, {bool addToHistory = true}) {
    setState(() {
      _color = c;
      _hexController.text = _colorToHex(_color, includeAlpha: widget.showAlpha);
      if (addToHistory) {
        _recent.remove(c);
        _recent.insert(0, c);
        if (_recent.length > widget.colorHistory)
          _recent = _recent.sublist(0, widget.colorHistory);
      }
    });
    widget.onColorChanged?.call(_color);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = widget.size ?? const Size(300, 220);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxPlaceholderSize = constraints.maxHeight * 0.6;
                  final placeholderSize = maxPlaceholderSize.isFinite
                      ? max(60.0, min(maxPlaceholderSize, constraints.maxWidth))
                      : min(120.0, constraints.maxWidth);
                  return Center(
                    child: SizedBox(
                      width: placeholderSize,
                      height: placeholderSize,
                      child: _buildColorWheelPlaceholder(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            if (widget.showCustomInput) _buildHexInputRow(),
            if (widget.showRecentColors) const SizedBox(height: 8),
            if (widget.showRecentColors) _buildRecentColorsRow(),
            if (widget.showLabel) const SizedBox(height: 8),
            if (widget.showLabel) _buildLabel(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorWheelPlaceholder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 200.0;
        final availH = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 200.0;
        final maxDim = min(availW, availH);

        final double sliderPreferredHeight = 36.0;
        final double sliderMinHeight = 12.0;
        final bool showSlider =
            availH > 56;
        final double sliderHeight = showSlider
            ? min(sliderPreferredHeight, max(12.0, availH * 0.25))
            : sliderMinHeight;

        final double spacing = showSlider ? max(4.0, maxDim * 0.06) : 4.0;

        final double circleSize = max(
          16.0,
          min(
            120.0,
            maxDim - (showSlider ? (sliderHeight + spacing) : spacing),
          ),
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Colors.red,
                    Colors.yellow,
                    Colors.green,
                    Colors.cyan,
                    Colors.blue,
                    Colors.purple,
                    Colors.red,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),
            if (showSlider)
              SizedBox(
                width: circleSize,
                height: sliderHeight,
                child: Slider(
                  value: HSVColor.fromColor(_color).hue,
                  min: 0,
                  max: 360,
                  onChanged: (v) {
                    final hsv = HSVColor.fromColor(_color);
                    _applyColor(hsv.withHue(v).toColor());
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHexInputRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _hexController,
            decoration: const InputDecoration(labelText: 'Hex'),
            onSubmitted: (v) {
              final c = _hexToColor(v);
              if (c != null) {
                _applyColor(c);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentColorsRow() {
    final items = _recent.isNotEmpty
        ? _recent
        : [Colors.red, Colors.green, Colors.blue, Colors.yellow];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = items[i];
          return GestureDetector(
            onTap: () => _applyColor(c, addToHistory: true),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black12),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      '${_colorToHex(_color, includeAlpha: widget.showAlpha)}',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}