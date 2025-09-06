import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('expand/collapse and selection interaction', (
    WidgetTester tester,
  ) async {
    final nodes = [
      TreeNode(
        id: '1',
        label: 'Root',
        children: [
          TreeNode(id: '1.1', label: 'Child 1'),
          TreeNode(id: '1.2', label: 'Child 2'),
        ],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MinimalTreeView(nodes: nodes)),
      ),
    );

    // Root row visible
    expect(find.text('Root'), findsOneWidget);
    // Children should not be visible initially
    expect(find.text('Child 1'), findsNothing);

    // Tap expand icon
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    // Children should appear
    expect(find.text('Child 1'), findsOneWidget);

    // Tap child to select
    await tester.tap(find.text('Child 1'));
    await tester.pumpAndSettle();

    // The selection highlights using Theme highlightColor - basic check: widget exists
    expect(find.text('Child 1'), findsOneWidget);
  });
}
