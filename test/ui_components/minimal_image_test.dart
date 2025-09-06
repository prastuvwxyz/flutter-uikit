import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Tap callback triggers and placeholder shows', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MinimalImage(
          src: 'assets/non_existing.png',
          width: 100,
          height: 100,
          placeholder: Container(key: Key('placeholder'), color: Colors.red),
          onTap: () {
            tapped = true;
          },
          fadeInDuration: Duration(milliseconds: 10),
        ),
      ),
    );

    // placeholder should be present immediately while image resolves
    expect(find.byKey(Key('placeholder')), findsOneWidget);

    // tap the widget
    await tester.tap(find.byType(MinimalImage));
    expect(tapped, isTrue);
  });
}
