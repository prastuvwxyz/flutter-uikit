import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('MinimalSlider builds and responds to changes', (tester) async {
    double value = 0.2;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalSlider(
            value: value,
            min: 0.0,
            max: 1.0,
            showLabel: true,
            label: 'Volume',
            onChanged: (v) => value = v,
          ),
        ),
      ),
    );

    // ensure label text is present
    expect(find.text('Volume'), findsOneWidget);

    // simulate a drag on the slider by moving the thumb to the middle
    final slider = find.byType(Slider);
    expect(slider, findsOneWidget);

    await tester.drag(slider, const Offset(50, 0));
    await tester.pumpAndSettle();

    expect(value, isNonZero);
  });
}
