import 'package:flutter/material.dart';

/// A simple masonry-style grid layout using Wrap widget.
/// For more advanced masonry layouts, consider using flutter_staggered_grid_view package.
class Masonry extends StatelessWidget {
  const Masonry({
    super.key,
    required this.children,
    this.columns = 2,
    this.spacing = 8.0,
    this.runSpacing,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
  });

  /// The widgets to display in the masonry layout
  final List<Widget> children;

  /// Number of columns (affects child width calculation)
  final int columns;

  /// Horizontal spacing between items
  final double spacing;

  /// Vertical spacing between rows
  final double? runSpacing;

  /// Alignment of the children within each run
  final WrapAlignment alignment;

  /// Alignment of the runs themselves
  final WrapAlignment runAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final totalSpacing = spacing * (columns - 1);
        final itemWidth = (availableWidth - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing ?? spacing,
          alignment: alignment,
          runAlignment: runAlignment,
          children: children.map((child) => SizedBox(
            width: itemWidth,
            child: child,
          )).toList(),
        );
      },
    );
  }
}