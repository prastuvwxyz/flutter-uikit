import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/radio_group/minimal_radio_group.dart';
import 'package:ui_components/src/radio_group/radio_option.dart';

void main() {
  testWidgets('Selection updates value and triggers callback', (tester) async {
    String? selected;
    final options = const [
      RadioOption(value: 'a', label: 'A'),
      RadioOption(value: 'b', label: 'B'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalRadioGroup<String>(
            options: options,
            value: null,
            onChanged: (v) => selected = v,
          ),
        ),
      ),
    );

    expect(selected, isNull);
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(selected, 'b');
  });

  testWidgets('Disabled state ignores taps', (tester) async {
    String? selected;
    final options = const [
      RadioOption(value: 'a', label: 'A'),
      RadioOption(value: 'b', label: 'B'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalRadioGroup<String>(
            options: options,
            value: null,
            disabled: true,
            onChanged: (v) => selected = v,
          ),
        ),
      ),
    );

    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    expect(selected, isNull);
  });
}
