import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('MinimalRichTextEditor builds and updates text', (
    WidgetTester tester,
  ) async {
    final controller = RichTextController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MinimalRichTextEditor(controller: controller)),
      ),
    );

    expect(find.byType(MinimalRichTextEditor), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.pumpAndSettle();

    expect(controller.text, 'Hello');
  });
}
