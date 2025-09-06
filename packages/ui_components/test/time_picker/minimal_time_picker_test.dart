import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  testWidgets('MinimalTimePicker builds and shows placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Theme(
            data: ThemeData.light().copyWith(extensions: [UiTokens.standard()]),
            child: const MinimalTimePicker(placeholder: 'Select time'),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Select time'), findsOneWidget);
  });
}
