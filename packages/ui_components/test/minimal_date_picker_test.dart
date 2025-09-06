import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Calendar opens on icon tap and clear works', (
    WidgetTester tester,
  ) async {
    DateTime? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MinimalDatePicker(
                value: selected,
                onChanged: (d) => setState(() => selected = d),
                label: 'Date',
                placeholder: 'Select date',
              );
            },
          ),
        ),
      ),
    );

    // Icon button present
    final icon = find.byIcon(Icons.calendar_today);
    expect(icon, findsOneWidget);

    await tester.tap(icon);
    await tester.pumpAndSettle();

    // The date picker dialog should appear
    expect(find.byType(Dialog), findsOneWidget);

    // Dismiss dialog (we don't assert selection here)
    if (find.text('OK').evaluate().isNotEmpty) {
      await tester.tap(find.text('OK'));
    } else {
      Navigator.of(tester.element(find.byType(Dialog))).pop();
    }
    await tester.pumpAndSettle();

    // Manually set a value to simulate a selection and show clear button
    await tester.runAsync(() async {
      // Using a small delay to mimic user flow
      await Future<void>.delayed(Duration(milliseconds: 10));
      selected = DateTime.now();
    });
    // Rebuild with new state
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalDatePicker(
            value: selected,
            onChanged: (d) => selected = d,
            label: 'Date',
            placeholder: 'Select date',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final clear = find.byIcon(Icons.clear);
    expect(clear, findsOneWidget);

    await tester.tap(clear);
    await tester.pumpAndSettle();

    expect(selected == null, true);
  });
}
