import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Defines breakpoints for responsive grid layouts
class GridBreakpoints {
  /// Creates a set of grid breakpoints for different screen sizes
  ///
  /// * [mobile] - Number of columns to use on mobile screens
  /// * [tablet] - Number of columns to use on tablet screens
  /// * [desktop] - Number of columns to use on desktop screens
  /// * [mobileWidth] - Maximum width for mobile breakpoint (default: 600)
  /// * [tabletWidth] - Maximum width for tablet breakpoint (default: 960)
  const GridBreakpoints({
    this.mobile = 1,
    this.tablet = 2,
    this.desktop = 4,
    this.mobileWidth = 600,
    this.tabletWidth = 960,
  });

  /// Number of columns for mobile screens
  final int mobile;

  /// Number of columns for tablet screens
  final int tablet;

  /// Number of columns for desktop screens
  final int desktop;

  /// Maximum width for mobile breakpoint
  final double mobileWidth;

  /// Maximum width for tablet breakpoint
  final double tabletWidth;

  /// Default grid breakpoint configuration
  static const GridBreakpoints standard = GridBreakpoints();

  /// Returns the number of columns based on the current screen width
  int columnsForWidth(double width) {
    if (width <= mobileWidth) {
      return mobile;
    } else if (width <= tabletWidth) {
      return tablet;
    } else {
      return desktop;
    }
  }
}

/// A responsive grid layout component with automatic sizing,
/// breakpoint adaptation, and gap management.
///
/// The [Grid] can work in multiple modes:
/// 1. Fixed column mode - when [columns] is provided
/// 2. Responsive mode - when [minItemWidth] is provided
/// 3. Natural sizing mode - when [naturalHeight] is true
///
/// In responsive mode, the grid will automatically calculate the
/// number of columns based on the available width and [minItemWidth].
/// In natural sizing mode, items will size to their content height.
class Grid extends StatelessWidget {
  /// Creates a responsive grid layout.
  ///
  /// The [children] argument must not be null.
  ///
  /// Either [columns] or [minItemWidth] should be provided for proper layout.
  /// If both are provided, [columns] takes precedence over [minItemWidth].
  ///
  /// The [spacing] parameter sets both [crossAxisSpacing] and [mainAxisSpacing]
  /// if they are not explicitly provided.
  ///
  /// Set [naturalHeight] to true for behavior where items size to content.
  const Grid({
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
    this.naturalHeight = false,
    this.itemHeight,
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
  /// Ignored when [naturalHeight] is true.
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

  /// Whether items should size naturally to their content height.
  /// When true, [childAspectRatio] is ignored and [itemHeight] may be used.
  final bool naturalHeight;

  /// Fixed height for grid items when [naturalHeight] is true.
  /// If null, items will size to their intrinsic height.
  final double? itemHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate effective spacing
        final effectiveCrossAxisSpacing = crossAxisSpacing ?? spacing ?? 0.0;
        final effectiveMainAxisSpacing = mainAxisSpacing ?? spacing ?? 0.0;

        // Calculate number of columns
        final effectiveColumns = _calculateColumns(constraints.maxWidth);

        // Use different layout strategies based on naturalHeight
        if (naturalHeight) {
          return _buildNaturalHeightGrid(
            effectiveColumns,
            effectiveCrossAxisSpacing,
            effectiveMainAxisSpacing,
            constraints.maxWidth,
          );
        } else {
          return _buildFixedAspectRatioGrid(
            effectiveColumns,
            effectiveCrossAxisSpacing,
            effectiveMainAxisSpacing,
          );
        }
      },
    );
  }

  /// Builds a grid with fixed aspect ratio (traditional GridView)
  Widget _buildFixedAspectRatioGrid(
    int effectiveColumns,
    double effectiveCrossAxisSpacing,
    double effectiveMainAxisSpacing,
  ) {
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
          selected: false,
          child: children[index],
        );
      },
    );
  }

  /// Builds a grid with natural height sizing
  Widget _buildNaturalHeightGrid(
    int effectiveColumns,
    double effectiveCrossAxisSpacing,
    double effectiveMainAxisSpacing,
    double maxWidth,
  ) {
    // Calculate available width for items (remove unused itemWidth variable)

    // Group children into rows
    final rows = <List<Widget>>[];
    for (int i = 0; i < children.length; i += effectiveColumns) {
      final rowChildren = children.sublist(
        i,
        math.min(i + effectiveColumns, children.length),
      );
      rows.add(rowChildren);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows.map((rowChildren) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: rows.last == rowChildren ? 0 : effectiveMainAxisSpacing,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...rowChildren.asMap().entries.map((entry) {
                final index = entry.key;
                final child = entry.value;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: itemHeight != null
                            ? SizedBox(
                                height: itemHeight,
                                child: Semantics(
                                  container: true,
                                  selected: false,
                                  child: child,
                                ),
                              )
                            : Semantics(
                                container: true,
                                selected: false,
                                child: child,
                              ),
                      ),
                      if (index < rowChildren.length - 1)
                        SizedBox(width: effectiveCrossAxisSpacing),
                    ],
                  ),
                );
              }).toList(),
              // Fill remaining space if row is not complete
              ...List.generate(
                effectiveColumns - rowChildren.length,
                (index) => const Expanded(child: SizedBox()),
              ),
            ],
          ),
        );
      }).toList(),
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
