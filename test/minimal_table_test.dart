import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('MinimalTable renders and reacts to sort & selection', (
    WidgetTester tester,
  ) async {
    var sortCalled = -1;
    var selected = false;

    final columns = [
      MinimalTableColumn(
        label: const Text('Name'),
        onSort: (i) => sortCalled = i,
      ),
      MinimalTableColumn(label: const Text('Age'), numeric: true),
    ];

    final rows = [
      MinimalTableRow(
        cells: [const Text('Alice'), const Text('30')],
        selected: selected,
        onSelectChanged: (v) => selected = v ?? false,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalTable(
            columns: columns,
            rows: rows,
            showCheckboxColumn: true,
          ),
        ),
      ),
    );

    // basic render
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);

    // tap sort on header
    await tester.tap(find.text('Name'));
    await tester.pumpAndSettle();
    expect(sortCalled, 0);

    // tap row checkbox
    final checkboxFinder = find.byType(Checkbox);
    expect(checkboxFinder, findsOneWidget);
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();
    expect(selected, true);
  });
}
