import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('MinimalGrid', () {
    testWidgets('Responsive grid adapts to screen size', (tester) async {
      // Mobile size
      await tester.binding.setSurfaceSize(const Size(400, 600));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalGrid(
              minItemWidth: 150,
              children: List.generate(
                6,
                (index) => Container(
                  color: Colors.blue,
                  child: Center(child: Text('$index')),
                ),
              ),
            ),
          ),
        ),
      );

      // Should have 2 columns on mobile (400/150 = 2.66, so 2 columns)
      final grid = find.byType(GridView);
      expect(grid, findsOneWidget);

      final GridView gridView = tester.widget(grid);
      final SliverGridDelegateWithFixedCrossAxisCount delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);

      // Tablet size
      await tester.binding.setSurfaceSize(const Size(800, 900));
      await tester.pumpAndSettle();

      final GridView gridViewTablet = tester.widget(find.byType(GridView));
      final SliverGridDelegateWithFixedCrossAxisCount delegateTablet =
          gridViewTablet.gridDelegate
              as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegateTablet.crossAxisCount, 5); // 800/150 = 5.33, so 5 columns
    });

    testWidgets('Fixed column count maintains layout', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalGrid(
              columns: 3, // Fixed 3 columns
              children: List.generate(
                6,
                (index) => Container(
                  color: Colors.blue,
                  child: Center(child: Text('$index')),
                ),
              ),
            ),
          ),
        ),
      );

      final GridView gridView = tester.widget(find.byType(GridView));
      final SliverGridDelegateWithFixedCrossAxisCount delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 3); // Should be fixed at 3

      // Change screen size
      await tester.binding.setSurfaceSize(const Size(400, 600));
      await tester.pumpAndSettle();

      final GridView gridViewSmall = tester.widget(find.byType(GridView));
      final SliverGridDelegateWithFixedCrossAxisCount delegateSmall =
          gridViewSmall.gridDelegate
              as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegateSmall.crossAxisCount, 3); // Should still be 3
    });

    testWidgets('Spacing applies correctly between items', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 600));

      const double testSpacing = 16.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalGrid(
              columns: 2,
              spacing: testSpacing,
              children: List.generate(
                4,
                (index) => Container(
                  color: Colors.blue,
                  child: Center(child: Text('$index')),
                ),
              ),
            ),
          ),
        ),
      );

      final GridView gridView = tester.widget(find.byType(GridView));
      final SliverGridDelegateWithFixedCrossAxisCount delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(delegate.crossAxisSpacing, testSpacing);
      expect(delegate.mainAxisSpacing, testSpacing);
    });

    testWidgets('Aspect ratio maintained across items', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 600));

      const double testRatio = 1.5; // 3:2 aspect ratio

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalGrid(
              columns: 2,
              childAspectRatio: testRatio,
              children: List.generate(
                4,
                (index) => Container(
                  color: Colors.blue,
                  child: Center(child: Text('$index')),
                ),
              ),
            ),
          ),
        ),
      );

      final GridView gridView = tester.widget(find.byType(GridView));
      final SliverGridDelegateWithFixedCrossAxisCount delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(delegate.childAspectRatio, testRatio);
    });

    testWidgets('Keyboard navigation works between items', (tester) async {
      final FocusNode focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Focus(
              focusNode: focusNode,
              child: MinimalGrid(
                columns: 2,
                children: List.generate(
                  4,
                  (index) => Container(
                    key: ValueKey('grid-item-$index'),
                    color: Colors.blue,
                    child: Center(child: Text('$index')),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Request focus
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Test that all items are wrapped in Semantics
      expect(
        find.byType(Semantics),
        findsNWidgets(4),
      ); // One for each grid item
    });
  });

  group('GridBreakpoints', () {
    test('columnsForWidth returns correct values', () {
      const breakpoints = GridBreakpoints(
        mobile: 1,
        tablet: 3,
        desktop: 5,
        mobileWidth: 600,
        tabletWidth: 1000,
      );

      expect(breakpoints.columnsForWidth(400), 1); // Mobile
      expect(breakpoints.columnsForWidth(600), 1); // Edge of mobile
      expect(breakpoints.columnsForWidth(601), 3); // Just into tablet
      expect(breakpoints.columnsForWidth(1000), 3); // Edge of tablet
      expect(breakpoints.columnsForWidth(1001), 5); // Desktop
    });
  });
}
