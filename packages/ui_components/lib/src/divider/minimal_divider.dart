import 'package:flutter/material.dart';
import '../../tokens/color_tokens.dart';
import '../../tokens/typography_tokens.dart';

/// Direction of the divider
enum DividerDirection { horizontal, vertical }

/// Position of the optional label
enum DividerLabelPosition { center, start, end }

/// Visual variant of the divider
enum DividerVariant { solid, dashed, dotted }

/// A minimal, token-friendly divider used as a visual separator.
class MinimalDivider extends StatelessWidget {
  final double thickness;
  final Color? color;
  final DividerDirection direction;
  final double? spacing;
  final String? label;
  final TextStyle? labelStyle;
  final DividerLabelPosition labelPosition;
  final DividerVariant variant;
  final double indent;
  final double endIndent;

  const MinimalDivider({
    super.key,
    this.thickness = 1.0,
    this.color,
    this.direction = DividerDirection.horizontal,
    this.spacing,
    this.label,
    this.labelStyle,
    this.labelPosition = DividerLabelPosition.center,
    this.variant = DividerVariant.solid,
    this.indent = 0.0,
    this.endIndent = 0.0,
  });

  bool get _isHorizontal => direction == DividerDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? ColorTokens.outline;
    final effectiveLabelStyle =
        labelStyle ?? TypographyTokens.labelMd.copyWith(color: Colors.black87);
    final gap = spacing ?? 8.0;

    Widget line(BuildContext c) {
      if (variant == DividerVariant.solid) {
        return _SolidLine(
          color: effectiveColor,
          thickness: thickness,
          isHorizontal: _isHorizontal,
        );
      }
      return CustomPaint(
        size: _isHorizontal
            ? Size(double.infinity, thickness)
            : Size(thickness, double.infinity),
        painter: _DashedLinePainter(
          color: effectiveColor,
          thickness: thickness,
          dotted: variant == DividerVariant.dotted,
          horizontal: _isHorizontal,
        ),
      );
    }

    // Horizontal with optional label
    if (_isHorizontal) {
      final child = label == null
          ? Padding(
              padding: EdgeInsets.only(left: indent, right: endIndent),
              child: SizedBox(height: thickness, child: line(context)),
            )
          : Padding(
              padding: EdgeInsets.only(
                left: indent,
                right: endIndent,
                top: gap,
                bottom: gap,
              ),
              child: Row(
                children: [
                  if (labelPosition != DividerLabelPosition.start)
                    Expanded(child: line(context))
                  else
                    SizedBox(width: 8),
                  if (labelPosition == DividerLabelPosition.start)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        label!,
                        style: effectiveLabelStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (labelPosition == DividerLabelPosition.center) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        label!,
                        style: effectiveLabelStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(child: line(context)),
                  ],
                  if (labelPosition == DividerLabelPosition.end)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        label!,
                        style: effectiveLabelStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            );

      return Semantics(
        container: true,
        explicitChildNodes: false,
        label: 'separator',
        child: child,
      );
    }

    // Vertical
    return Semantics(
      container: true,
      explicitChildNodes: false,
      label: 'separator',
      child: Padding(
        padding: EdgeInsets.only(
          top: indent,
          bottom: endIndent,
          left: gap,
          right: gap,
        ),
        child: SizedBox(width: thickness, child: line(context)),
      ),
    );
  }
}

class _SolidLine extends StatelessWidget {
  final Color color;
  final double thickness;
  final bool isHorizontal;

  const _SolidLine({
    required this.color,
    required this.thickness,
    required this.isHorizontal,
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal
        ? Container(height: thickness, color: color)
        : Container(width: thickness, color: color);
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool dotted;
  final bool horizontal;

  _DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.dotted,
    required this.horizontal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dashWidth = dotted ? thickness : thickness * 4;
    final dashSpace = dotted ? thickness * 2 : thickness * 3;

    if (horizontal) {
      double x = 0;
      final y = size.height / 2;
      while (x < size.width) {
        final end = (x + dashWidth).clamp(0, size.width) as double;
        canvas.drawLine(Offset(x, y), Offset(end, y), paint);
        x += dashWidth + dashSpace;
      }
    } else {
      double y = 0;
      final x = size.width / 2;
      while (y < size.height) {
        final end = (y + dashWidth).clamp(0, size.height) as double;
        canvas.drawLine(Offset(x, y), Offset(x, end), paint);
        y += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.dotted != dotted ||
        oldDelegate.horizontal != horizontal;
  }
}
