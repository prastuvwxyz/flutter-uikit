import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders MinimalTextareaAutosize', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalTextareaAutosize(placeholder: 'Enter text here'),
        ),
      ),
    );

    expect(find.byType(MinimalTextareaAutosize), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('shows character count when enabled', (tester) async {
    final controller = TextEditingController(text: 'Hello');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalTextareaAutosize(
            controller: controller,
            showCharacterCount: true,
            maxLength: 100,
          ),
        ),
      ),
    );

    expect(find.text('5/100'), findsOneWidget);
  });
}
