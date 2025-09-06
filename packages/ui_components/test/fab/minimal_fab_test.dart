import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders with required properties', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MinimalFloatingActionButton(
            onPressed: null,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );

    expect(find.byType(MinimalFloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('handles tap events correctly', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalFloatingActionButton(
            onPressed: () => tapped = true,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(MinimalFloatingActionButton));
    expect(tapped, isTrue);
  });

  testWidgets('shows loading state correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MinimalFloatingActionButton(
            onPressed: null,
            isLoading: true,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
  });

  testWidgets('supports different sizes', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            MinimalFloatingActionButton(
              onPressed: () {},
              size: MinimalFABSize.mini,
              child: const Icon(Icons.add),
            ),
            MinimalFloatingActionButton(
              onPressed: () {},
              size: MinimalFABSize.regular,
              child: const Icon(Icons.add),
            ),
            MinimalFloatingActionButton(
              onPressed: () {},
              size: MinimalFABSize.large,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(MinimalFloatingActionButton), findsNWidgets(3));
  });

  testWidgets('supports extended variant', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MinimalFloatingActionButton(
            onPressed: null,
            isExtended: true,
            icon: Icon(Icons.add),
            label: Text('Add Item'),
          ),
        ),
      ),
    );

    expect(find.text('Add Item'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
