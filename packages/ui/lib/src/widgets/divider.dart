import 'package:flutter/material.dart';
import '../internal/token_adapters.dart';

/// Orientation of the divider
enum DividerOrientation {
  /// Horizontal divider (default)
  horizontal,
  /// Vertical divider
  vertical,
}

/// Thickness variants for dividers
enum DividerThickness {
  /// Thin divider (1px)
  thin,
  /// Medium divider (2px)
  medium,
  /// Thick divider (4px)
  thick,
}

/// Style variants for dividers
enum DividerStyle {
  /// Solid line
  solid,
  /// Dashed line
  dashed,
  /// Dotted line
  dotted,
}

/// A flexible divider widget for separating content
class Divider extends StatelessWidget {
  /// Orientation of the divider
  final DividerOrientation orientation;

  /// Thickness of the divider
  final DividerThickness thickness;

  /// Style of the divider line
  final DividerStyle style;

  /// Custom color for the divider
  final Color? color;

  /// Length of the divider (null for full width/height)
  final double? length;

  /// Margin around the divider
  final EdgeInsetsGeometry? margin;

  /// Optional text label for the divider
  final String? label;

  /// Position of the label (only for horizontal dividers)
  final DividerLabelPosition labelPosition;

  /// Style for the label text
  final TextStyle? labelStyle;

  /// Padding around the label
  final EdgeInsetsGeometry? labelPadding;

  /// Whether to show the divider with reduced opacity when disabled
  final bool disabled;

  const Divider({
    super.key,
    this.orientation = DividerOrientation.horizontal,
    this.thickness = DividerThickness.thin,
    this.style = DividerStyle.solid,
    this.color,
    this.length,
    this.margin,
    this.label,
    this.labelPosition = DividerLabelPosition.center,
    this.labelStyle,
    this.labelPadding,
    this.disabled = false,
  });

  /// Factory for horizontal divider
  factory Divider.horizontal({
    Key? key,
    DividerThickness thickness = DividerThickness.thin,
    DividerStyle style = DividerStyle.solid,
    Color? color,
    double? length,
    EdgeInsetsGeometry? margin,
    String? label,
    DividerLabelPosition labelPosition = DividerLabelPosition.center,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    bool disabled = false,
  }) {
    return Divider(
      key: key,
      orientation: DividerOrientation.horizontal,
      thickness: thickness,
      style: style,
      color: color,
      length: length,
      margin: margin,
      label: label,
      labelPosition: labelPosition,
      labelStyle: labelStyle,
      labelPadding: labelPadding,
      disabled: disabled,
    );
  }

  /// Factory for vertical divider
  factory Divider.vertical({
    Key? key,
    DividerThickness thickness = DividerThickness.thin,
    DividerStyle style = DividerStyle.solid,
    Color? color,
    double? length,
    EdgeInsetsGeometry? margin,
    bool disabled = false,
  }) {
    return Divider(
      key: key,
      orientation: DividerOrientation.vertical,
      thickness: thickness,
      style: style,
      color: color,
      length: length,
      margin: margin,
      disabled: disabled,
    );
  }

  /// Factory for labeled divider
  factory Divider.labeled({
    Key? key,
    required String label,
    DividerThickness thickness = DividerThickness.thin,
    DividerStyle style = DividerStyle.solid,
    Color? color,
    double? length,
    EdgeInsetsGeometry? margin,
    DividerLabelPosition labelPosition = DividerLabelPosition.center,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    bool disabled = false,
  }) {
    return Divider(
      key: key,
      orientation: DividerOrientation.horizontal,
      thickness: thickness,
      style: style,
      color: color,
      length: length,
      margin: margin,
      label: label,
      labelPosition: labelPosition,
      labelStyle: labelStyle,
      labelPadding: labelPadding,
      disabled: disabled,
    );
  }

  /// Get thickness value in pixels
  double get _thicknessPx {
    switch (thickness) {
      case DividerThickness.thin:
        return 1.0;
      case DividerThickness.medium:
        return 2.0;
      case DividerThickness.thick:
        return 4.0;
    }
  }

  /// Get effective color
  Color _getEffectiveColor(BuildContext context) {
    if (color != null) {
      return disabled ? color!.withValues(alpha: 0.38) : color!;
    }

    final defaultColor = Theme.of(context).colorScheme.outline;
    return disabled ? defaultColor.withValues(alpha: 0.38) : defaultColor;
  }

  /// Build the divider line
  Widget _buildDividerLine(BuildContext context, Color effectiveColor) {
    final isHorizontal = orientation == DividerOrientation.horizontal;

    switch (style) {
      case DividerStyle.solid:
        return Container(
          width: isHorizontal ? length : _thicknessPx,
          height: isHorizontal ? _thicknessPx : length,
          color: effectiveColor,
        );

      case DividerStyle.dashed:
        return CustomPaint(
          size: Size(
            isHorizontal ? (length ?? double.infinity) : _thicknessPx,
            isHorizontal ? _thicknessPx : (length ?? double.infinity),
          ),
          painter: DashedLinePainter(
            color: effectiveColor,
            thickness: _thicknessPx,
            isHorizontal: isHorizontal,
            dashLength: 4.0,
            gapLength: 4.0,
          ),
        );

      case DividerStyle.dotted:
        return CustomPaint(
          size: Size(
            isHorizontal ? (length ?? double.infinity) : _thicknessPx,
            isHorizontal ? _thicknessPx : (length ?? double.infinity),
          ),
          painter: DottedLinePainter(
            color: effectiveColor,
            thickness: _thicknessPx,
            isHorizontal: isHorizontal,
            dotSize: _thicknessPx,
            gapLength: 2.0,
          ),
        );
    }
  }

  /// Build labeled horizontal divider
  Widget _buildLabeledDivider(BuildContext context, Color effectiveColor) {
    if (label == null || orientation != DividerOrientation.horizontal) {
      return _buildDividerLine(context, effectiveColor);
    }

    final effectiveLabelStyle = labelStyle ??
        TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.labelSmall,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    final effectiveLabelPadding = labelPadding ?? context.padding(horizontal: TokenSize.sm);

    Widget labelWidget = Container(
      padding: effectiveLabelPadding,
      child: Text(
        label!,
        style: effectiveLabelStyle,
      ),
    );

    // Create divider segments
    Widget leftDivider = Expanded(
      child: _buildDividerLine(context, effectiveColor),
    );

    Widget rightDivider = Expanded(
      child: _buildDividerLine(context, effectiveColor),
    );

    // Arrange based on label position
    List<Widget> children;
    switch (labelPosition) {
      case DividerLabelPosition.left:
        children = [
          labelWidget,
          SizedBox(width: context.spacing.sm),
          rightDivider,
        ];
        break;
      case DividerLabelPosition.center:
        children = [
          leftDivider,
          labelWidget,
          rightDivider,
        ];
        break;
      case DividerLabelPosition.right:
        children = [
          leftDivider,
          SizedBox(width: context.spacing.sm),
          labelWidget,
        ];
        break;
    }

    return Row(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = _getEffectiveColor(context);

    Widget divider = _buildLabeledDivider(context, effectiveColor);

    // Add margin if provided
    if (margin != null) {
      divider = Padding(
        padding: margin!,
        child: divider,
      );
    }

    // Add semantics for accessibility
    return Semantics(
      label: label ?? 'Divider',
      child: divider,
    );
  }
}

/// Label position for labeled dividers
enum DividerLabelPosition {
  /// Label on the left side
  left,
  /// Label in the center
  center,
  /// Label on the right side
  right,
}

/// Custom painter for dashed lines
class DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool isHorizontal;
  final double dashLength;
  final double gapLength;

  const DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.isHorizontal,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final totalLength = isHorizontal ? size.width : size.height;
    final dashAndGap = dashLength + gapLength;
    final dashCount = (totalLength / dashAndGap).floor();

    for (int i = 0; i < dashCount; i++) {
      final startPos = i * dashAndGap;
      final endPos = startPos + dashLength;

      if (isHorizontal) {
        canvas.drawLine(
          Offset(startPos, size.height / 2),
          Offset(endPos, size.height / 2),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(size.width / 2, startPos),
          Offset(size.width / 2, endPos),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for dotted lines
class DottedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool isHorizontal;
  final double dotSize;
  final double gapLength;

  const DottedLinePainter({
    required this.color,
    required this.thickness,
    required this.isHorizontal,
    required this.dotSize,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final totalLength = isHorizontal ? size.width : size.height;
    final dotAndGap = dotSize + gapLength;
    final dotCount = (totalLength / dotAndGap).floor();

    for (int i = 0; i < dotCount; i++) {
      final position = i * dotAndGap + dotSize / 2;

      if (isHorizontal) {
        canvas.drawCircle(
          Offset(position, size.height / 2),
          dotSize / 2,
          paint,
        );
      } else {
        canvas.drawCircle(
          Offset(size.width / 2, position),
          dotSize / 2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A group of items separated by dividers
class DividerGroup extends StatelessWidget {
  /// List of items to separate
  final List<Widget> children;

  /// Divider to use between items
  final Divider divider;

  /// Direction of the group
  final Axis direction;

  /// Whether to show divider after the last item
  final bool showTrailing;

  /// Whether to show divider before the first item
  final bool showLeading;

  const DividerGroup({
    super.key,
    required this.children,
    required this.divider,
    this.direction = Axis.vertical,
    this.showTrailing = false,
    this.showLeading = false,
  });

  /// Factory for vertical group (items stacked vertically with horizontal dividers)
  factory DividerGroup.vertical({
    Key? key,
    required List<Widget> children,
    Divider? divider,
    bool showTrailing = false,
    bool showLeading = false,
  }) {
    return DividerGroup(
      key: key,
      children: children,
      divider: divider ?? Divider.horizontal(),
      direction: Axis.vertical,
      showTrailing: showTrailing,
      showLeading: showLeading,
    );
  }

  /// Factory for horizontal group (items arranged horizontally with vertical dividers)
  factory DividerGroup.horizontal({
    Key? key,
    required List<Widget> children,
    Divider? divider,
    bool showTrailing = false,
    bool showLeading = false,
  }) {
    return DividerGroup(
      key: key,
      children: children,
      divider: divider ?? Divider.vertical(),
      direction: Axis.horizontal,
      showTrailing: showTrailing,
      showLeading: showLeading,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final items = <Widget>[];

    // Add leading divider if requested
    if (showLeading) {
      items.add(divider);
    }

    // Add children with dividers between them
    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);

      // Add divider after each item except the last (unless trailing is requested)
      if (i < children.length - 1 || showTrailing) {
        items.add(divider);
      }
    }

    // Return appropriate layout based on direction
    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      );
    }
  }
}