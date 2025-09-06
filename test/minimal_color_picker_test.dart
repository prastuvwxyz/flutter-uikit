import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('MinimalColorPicker builds and hex input updates color', (
    WidgetTester tester,
  ) async {
    Color? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalColorPicker(
            color: Colors.blue,
            onColorChanged: (c) => picked = c,
            showCustomInput: true,
          ),
        ),
      ),
    );

    expect(find.byType(MinimalColorPicker), findsOneWidget);

    // Enter a hex color and submit
    final hexField = find.byType(TextField);
    expect(hexField, findsOneWidget);

    await tester.enterText(hexField, '#ff00ff');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(picked, isNotNull);
    expect(picked, equals(const Color(0xFFFF00FF)));
  });
}
