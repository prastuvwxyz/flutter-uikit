import 'package:flutter/material.dart';

/// A simple masonry (Pinterest-style) layout for variable height children.
///
/// This is a lightweight implementation meant for use inside other scrolling
/// parents. It places children into [delegate.crossAxisCount] columns by
/// estimating heights using the delegate's [getItemAspectRatio].
class MinimalMasonry extends StatelessWidget {
  const MinimalMasonry({
    super.key,
    required this.children,
    required this.delegate,
    this.spacing = 8.0,
    this.physics,
    this.shrinkWrap = false,
  });

  final List<Widget> children;
  final MinimalMasonryDelegate delegate;
  final double spacing;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = delegate.crossAxisCount.clamp(1, children.length);
        final columnWidth =
            (constraints.maxWidth - spacing * (crossCount - 1)) / crossCount;

        // Distribute children into columns based on estimated heights.
        final columns = List<List<int>>.generate(crossCount, (_) => []);
        final columnHeights = List<double>.filled(crossCount, 0.0);

        for (var i = 0; i < children.length; i++) {
          final aspect = delegate.getItemAspectRatio(i);
          final estimatedHeight = columnWidth / (aspect > 0 ? aspect : 1.0);
          // place into shortest column
          var target = 0;
          for (var c = 1; c < crossCount; c++) {
            if (columnHeights[c] < columnHeights[target]) target = c;
          }
          columns[target].add(i);
          columnHeights[target] += estimatedHeight + spacing;
        }

        // Build column widgets
        return SingleChildScrollView(
          physics: physics,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(crossCount, (c) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: c == 0 ? 0.0 : spacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(columns[c].length, (i) {
                      final childIndex = columns[c][i];
                      return Padding(
                        padding: EdgeInsets.only(top: i == 0 ? 0.0 : spacing),
                        child: children[childIndex],
                      );
                    }),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

abstract class MinimalMasonryDelegate {
  int get crossAxisCount;

  /// Return width/height ratio (width divided by height) for item at [index].
  /// A value <= 0 will be treated as 1.0.
  double getItemAspectRatio(int index);
}
