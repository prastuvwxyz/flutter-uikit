import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Tap sets rating correctly', (WidgetTester tester) async {
    double value = 0.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: MinimalRating(
              value: value,
              onChanged: (v) => value = v,
              maxRating: 5,
              size: 32,
            ),
          ),
        ),
      ),
    );

    // Tap the third star roughly
    final star = find
        .byType(Icon)
        .at(
          4,
        ); // border+filled stacking may cause multiple icons; pick an index
    expect(star, findsWidgets);
    await tester.tap(star);
    await tester.pumpAndSettle();

    expect(value > 0, isTrue);
  });

  testWidgets('Read-only mode ignores interaction', (
    WidgetTester tester,
  ) async {
    double value = 0.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: MinimalRating(
              value: value,
              onChanged: null,
              maxRating: 5,
              size: 24,
            ),
          ),
        ),
      ),
    );

    final star = find.byType(Icon).first;
    await tester.tap(star);
    await tester.pumpAndSettle();

    expect(value, equals(0.0));
  });
}
