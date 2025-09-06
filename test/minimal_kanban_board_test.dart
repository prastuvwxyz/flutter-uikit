import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders columns and cards', (WidgetTester tester) async {
    final columns = [
      KanbanColumn(
        id: 'todo',
        title: 'To Do',
        cards: [KanbanCard(id: 'c1', title: 'Task 1')],
      ),
      KanbanColumn(id: 'done', title: 'Done', cards: []),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MinimalKanbanBoard(columns: columns)),
      ),
    );
    expect(find.text('To Do'), findsOneWidget);
    expect(find.text('Task 1'), findsOneWidget);
  });
}
