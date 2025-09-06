import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Title displays correctly and description shows when provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalEmptyState(
            title: 'No items',
            description: 'Please add items',
          ),
        ),
      ),
    );

    expect(find.text('No items'), findsOneWidget);
    expect(find.text('Please add items'), findsOneWidget);
  });

  testWidgets('Icon renders with correct size when provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalEmptyState(
            title: 'Empty',
            icon: Icons.inbox,
            iconSize: 48.0,
          ),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.size, 48.0);
  });

  testWidgets('Custom image displays properly and actions render', (
    WidgetTester tester,
  ) async {
    final actionKey = Key('primary');
    final secondaryKey = Key('secondary');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalEmptyState(
            title: 'Empty',
            image: const SizedBox(
              width: 50,
              height: 50,
              key: Key('illustration'),
            ),
            action: ElevatedButton(
              key: actionKey,
              onPressed: () {},
              child: const Text('Add'),
            ),
            secondaryAction: TextButton(
              key: secondaryKey,
              onPressed: () {},
              child: const Text('Later'),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('illustration')), findsOneWidget);
    expect(find.byKey(actionKey), findsOneWidget);
    expect(find.byKey(secondaryKey), findsOneWidget);
  });
}
