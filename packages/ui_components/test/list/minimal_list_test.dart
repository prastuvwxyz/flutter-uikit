import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('MinimalList', () {
    testWidgets('renders items correctly', (WidgetTester tester) async {
      // Arrange
      final List<String> items = ['Item 1', 'Item 2', 'Item 3'];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalList<String>(
              items: items,
              itemBuilder: (context, item, index) =>
                  ListTile(title: Text(item)),
            ),
          ),
        ),
      );

      // Assert
      for (final item in items) {
        expect(find.text(item), findsOneWidget);
      }
    });

    testWidgets('shows loading state', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalList<String>(
              loading: true,
              items: const ['Item 1', 'Item 2', 'Item 3'],
              itemBuilder: (context, item, index) =>
                  ListTile(title: Text(item)),
            ),
          ),
        ),
      );

      // Assert - no items should be visible in loading state
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('shows empty state when items is empty', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalList<String>(
              items: const [],
              itemBuilder: (context, item, index) =>
                  ListTile(title: Text(item)),
            ),
          ),
        ),
      );

      // Assert - should show default empty state
      expect(find.text('No items found'), findsOneWidget);
    });

    testWidgets('shows custom empty state', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalList<String>(
              items: const [],
              empty: const Text('Custom empty message'),
              itemBuilder: (context, item, index) =>
                  ListTile(title: Text(item)),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Custom empty message'), findsOneWidget);
    });

    testWidgets('shows separators when provided', (WidgetTester tester) async {
      // Arrange
      final List<String> items = ['Item 1', 'Item 2', 'Item 3'];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalList<String>(
              items: items,
              itemBuilder: (context, item, index) =>
                  ListTile(title: Text(item)),
              separatorBuilder: (context, index) =>
                  const Divider(height: 10, thickness: 2, color: Colors.red),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Divider), findsNWidgets(items.length - 1));
    });

    testWidgets('calls onItemTap when item is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      final List<String> items = ['Item 1', 'Item 2', 'Item 3'];
      String? tappedItem;
      int? tappedIndex;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalList<String>(
              items: items,
              itemBuilder: (context, item, index) =>
                  ListTile(title: Text(item)),
              onItemTap: (item, index) {
                tappedItem = item;
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      // Tap on the first item
      await tester.tap(find.text('Item 1'));
      await tester.pump();

      // Assert
      expect(tappedItem, 'Item 1');
      expect(tappedIndex, 0);
    });

    testWidgets('virtualized list handles large data sets', (
      WidgetTester tester,
    ) async {
      // Arrange - create 1000 items
      final largeItemList = List.generate(1000, (index) => 'Item $index');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: MinimalList<String>(
                virtualized: true,
                items: largeItemList,
                itemBuilder: (context, item, index) =>
                    ListTile(title: Text(item)),
              ),
            ),
          ),
        ),
      );

      // Assert - only visible items are built
      // We can't check exact number as it depends on screen size,
      // but we can verify the first few items are visible and later ones aren't
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 999'), findsNothing);
    });

    // Add more tests for other functionality
  });
}
