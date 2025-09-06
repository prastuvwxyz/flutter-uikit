import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Modal shows when isVisible true and barrier tap dismisses', (
    WidgetTester tester,
  ) async {
    bool dismissed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalModal(
            isVisible: true,
            onDismiss: () {
              dismissed = true;
            },
            child: const Text('Hello Modal'),
          ),
        ),
      ),
    );

    // initial animations
    await tester.pumpAndSettle();

    expect(find.text('Hello Modal'), findsOneWidget);

    // Tap on barrier (outside modal) to dismiss
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(dismissed, isTrue);
  });

  testWidgets('Modal hidden when isVisible false', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalModal(
            isVisible: false,
            child: const Text('Hidden Modal'),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Hidden Modal'), findsNothing);
  });
}
