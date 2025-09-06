import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/calendar/minimal_calendar.dart';
import 'package:ui_components/src/calendar/calendar_event.dart';
import 'package:ui_components/src/calendar/calendar_view.dart';

void main() {
  testWidgets('renders month header and selects a date', (
    WidgetTester tester,
  ) async {
    DateTime? selected;
    final today = DateTime.now();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalCalendar(
            selectedDate: today,
            onDateSelected: (d) => selected = d,
          ),
        ),
      ),
    );

    expect(
      find.text('${today.year}-${today.month.toString().padLeft(2, '0')}'),
      findsOneWidget,
    );

    // Tap the first day visible (may be from previous month) and ensure callback runs
    final dayFinder = find.text('1').first;
    await tester.tap(dayFinder);
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
  });
}
