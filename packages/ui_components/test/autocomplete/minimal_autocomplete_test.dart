import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter/services.dart';

void main() {
  testWidgets('Basic selection updates value and calls onChanged', (
    WidgetTester tester,
  ) async {
    String? selected;
    final options = ['apple', 'banana', 'cherry'];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalAutocomplete<String>(
            options: options,
            onChanged: (v) => selected = v,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'ban');
    await tester.pumpAndSettle();

    // Tap the option
    expect(find.text('banana'), findsWidgets);
    await tester.tap(find.text('banana').first);
    await tester.pumpAndSettle();

    expect(selected, 'banana');
  });

  testWidgets('Arrow keys navigate options', (WidgetTester tester) async {
    String? selected;
    final options = ['a', 'b', 'c'];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalAutocomplete<String>(
            options: options,
            onChanged: (v) => selected = v,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    // open options by focusing
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();

    // Press Enter to select highlighted
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    // selection may be the first option
    expect(selected != null, true);
  });
}
