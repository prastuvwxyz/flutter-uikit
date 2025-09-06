import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('shows initial datetime formatted', (WidgetTester tester) async {
    final dt = DateTime(2025, 9, 6, 14, 30);
    final fmt = DateFormat.yMd().add_jm();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MinimalDateTimePicker(initialDateTime: dt)),
      ),
    );

    expect(find.text(fmt.format(dt)), findsOneWidget);
  });
}
