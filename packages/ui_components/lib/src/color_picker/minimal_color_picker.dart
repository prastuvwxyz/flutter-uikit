import 'package:flutter/material.dart';

/// Minimal color picker implementing a subset of the UIK-132 spec.
///
/// Supports:
/// - passing an initial color
/// - notifying on color change
/// - hex input
/// - recent colors palette
class MinimalColorPicker extends StatefulWidget {
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

  const MinimalColorPicker({
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
  State<MinimalColorPicker> createState() => _MinimalColorPickerState();
}

class _MinimalColorPickerState extends State<MinimalColorPicker> {
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
  void didUpdateWidget(covariant MinimalColorPicker oldWidget) {
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
      return '#${c.alpha.toRadixString(16).padLeft(2, '0')}${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
    }
    return '#${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'
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
            Expanded(child: Center(child: _buildColorWheelPlaceholder())),
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

  // Placeholder for a real color wheel; shows a simple hue slider for now.
  Widget _buildColorWheelPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
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
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Slider(
          value: HSVColor.fromColor(_color).hue,
          min: 0,
          max: 360,
          onChanged: (v) {
            final hsv = HSVColor.fromColor(_color);
            _applyColor(hsv.withHue(v).toColor());
          },
        ),
      ],
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
