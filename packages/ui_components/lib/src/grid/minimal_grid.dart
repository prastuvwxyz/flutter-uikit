import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'grid_breakpoints.dart';

/// A responsive grid layout component with automatic sizing,
/// breakpoint adaptation, and gap management.
///
/// The [MinimalGrid] can work in two modes:
/// 1. Fixed column mode - when [columns] is provided
/// 2. Responsive mode - when [minItemWidth] is provided
///
/// In responsive mode, the grid will automatically calculate the
/// number of columns based on the available width and [minItemWidth].
class MinimalGrid extends StatelessWidget {
  /// Creates a responsive grid layout.
  ///
  /// The [children] argument must not be null.
  ///
  /// Either [columns] or [minItemWidth] should be provided for proper layout.
  /// If both are provided, [columns] takes precedence over [minItemWidth].
  ///
  /// The [spacing] parameter sets both [crossAxisSpacing] and [mainAxisSpacing]
  /// if they are not explicitly provided.
  const MinimalGrid({
    super.key,
    required this.children,
    this.columns,
    this.spacing,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio = 1.0,
    this.responsive = true,
    this.breakpoints,
    this.minItemWidth,
    this.maxItemWidth,
    this.alignment = WrapAlignment.start,
  });

  /// The widgets to display in the grid.
  final List<Widget> children;

  /// The number of columns in the grid.
  ///
  /// If not provided, the grid will calculate columns based on
  /// [minItemWidth] or [breakpoints].
  final int? columns;

  /// The spacing between grid items (both horizontal and vertical).
  ///
  /// If [crossAxisSpacing] or [mainAxisSpacing] are provided,
  /// they will take precedence over this value.
  final double? spacing;

  /// The horizontal spacing between grid items.
  final double? crossAxisSpacing;

  /// The vertical spacing between grid items.
  final double? mainAxisSpacing;

  /// The ratio of the width to height of each grid item.
  final double childAspectRatio;

  /// Whether the grid should adapt to different screen sizes.
  final bool responsive;

  /// Custom breakpoint configuration for responsive behavior.
  final GridBreakpoints? breakpoints;

  /// Minimum width of each grid item in responsive mode.
  ///
  /// Used to calculate the number of columns when [columns] is not provided.
  final double? minItemWidth;

  /// Maximum width of each grid item in responsive mode.
  final double? maxItemWidth;

  /// Alignment of the grid items within the grid.
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate effective spacing
        final effectiveCrossAxisSpacing = crossAxisSpacing ?? spacing ?? 0.0;
        final effectiveMainAxisSpacing = mainAxisSpacing ?? spacing ?? 0.0;

        // Calculate number of columns
        final effectiveColumns = _calculateColumns(constraints.maxWidth);

        // Build grid items
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: effectiveColumns,
            crossAxisSpacing: effectiveCrossAxisSpacing,
            mainAxisSpacing: effectiveMainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) {
            return Semantics(
              container: true,
              selected: false, // Default state, can be updated with focus
              child: children[index],
            );
          },
        );
      },
    );
  }

  /// Calculates the number of columns based on available width and configuration
  int _calculateColumns(double availableWidth) {
    // If fixed columns are provided, use them
    if (columns != null) {
      return columns!;
    }

    // If responsive is disabled, use a default column count
    if (!responsive) {
      return 1;
    }

    // Use breakpoints if provided
    final effectiveBreakpoints = breakpoints ?? GridBreakpoints.standard;
    if (minItemWidth == null) {
      return effectiveBreakpoints.columnsForWidth(availableWidth);
    }

    // Calculate columns based on minItemWidth
    final spacing = crossAxisSpacing ?? this.spacing ?? 0.0;
    final minColumns = (availableWidth + spacing) / (minItemWidth! + spacing);
    return minColumns.floor().clamp(1, 12); // Reasonable max column limit
  }
}
