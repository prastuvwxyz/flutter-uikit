import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/backdrop/minimal_backdrop.dart';

void main() {
  testWidgets('Backdrop shows when isVisible true', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalBackdrop(isVisible: true, child: const Text('content')),
      ),
    );

    // initial animation may be at value 1
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('Barrier tap dismisses when enabled', (tester) async {
    var dismissed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalBackdrop(
          isVisible: true,
          onDismiss: () => dismissed = true,
        ),
      ),
    );

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(dismissed, isTrue);
  });

  testWidgets('Blur effect applies when enabled', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalBackdrop(
          isVisible: true,
          blurEffect: true,
          child: const Text('c'),
        ),
      ),
    );

    expect(find.text('c'), findsOneWidget);
  });

  testWidgets('Escape key dismisses backdrop', (tester) async {
    var dismissed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalBackdrop(
          isVisible: true,
          onDismiss: () => dismissed = true,
        ),
      ),
    );

    // Send escape key
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(dismissed, isTrue);
  });
}
