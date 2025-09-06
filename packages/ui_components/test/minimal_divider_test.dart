import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Horizontal divider spans available width', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: Column(children: const [MinimalDivider()]),
          ),
        ),
      ),
    );

    final finder = find.byType(MinimalDivider);
    expect(finder, findsOneWidget);

    final divider = tester.firstWidget(finder) as MinimalDivider;
    expect(divider.direction, DividerDirection.horizontal);
  });

  testWidgets('Label displays correctly at specified position', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: Column(
              children: const [
                MinimalDivider(
                  label: 'Hello',
                  labelPosition: DividerLabelPosition.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
  });
}
