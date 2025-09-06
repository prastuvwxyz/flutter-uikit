import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('MinimalDashboardWidget displays title and toggles collapse', (
    WidgetTester tester,
  ) async {
    var collapsed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalDashboardWidget(
            title: 'Test Widget',
            content: const Text('Hello'),
            isCollapsible: true,
            onCollapse: (v) => collapsed = v,
          ),
        ),
      ),
    );

    // Title is present
    expect(find.text('Test Widget'), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);

    // Tap collapse button (IconButton uses expand_less/expand_more)
    final collapseButton = find.byTooltip('Collapse');
    expect(collapseButton, findsOneWidget);

    await tester.tap(collapseButton);
    await tester.pumpAndSettle();

    // Content should be gone and callback called
    expect(find.text('Hello'), findsNothing);
    expect(collapsed, isTrue);
  });
}
