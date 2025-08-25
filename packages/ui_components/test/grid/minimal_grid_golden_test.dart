import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('MinimalGrid Golden Tests', () {
    testWidgets('fixed-columns golden test', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 400));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: MinimalGrid(
                columns: 3,
                spacing: 16,
                children: List.generate(
                  9,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalGrid),
        matchesGoldenFile('goldens/fixed-columns.png'),
      );
    });

    testWidgets('responsive-grid golden test', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 400));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: MinimalGrid(
                minItemWidth: 120,
                spacing: 16,
                children: List.generate(
                  8,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalGrid),
        matchesGoldenFile('goldens/responsive-grid.png'),
      );
    });

    testWidgets('with-spacing golden test', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 400));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: MinimalGrid(
                columns: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 32,
                children: List.generate(
                  4,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalGrid),
        matchesGoldenFile('goldens/with-spacing.png'),
      );
    });

    testWidgets('different-ratios golden test', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 600));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: MinimalGrid(
                columns: 2,
                spacing: 16,
                childAspectRatio: 1.5, // 3:2 ratio (landscape)
                children: List.generate(
                  4,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalGrid),
        matchesGoldenFile('goldens/different-ratios.png'),
      );
    });
  });
}
