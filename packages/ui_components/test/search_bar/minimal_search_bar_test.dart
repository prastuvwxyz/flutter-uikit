import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('typing triggers onChanged after debounce', (tester) async {
    String last = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalSearchBar(
            suggestions: ['apple', 'banana'],
            onChanged: (v) => last = v,
            debounceTime: Duration(milliseconds: 100),
          ),
        ),
      ),
    );

    final field = find.byType(TextField);
    expect(field, findsOneWidget);

    await tester.enterText(field, 'app');
    // not yet after debounce
    await tester.pump(Duration(milliseconds: 50));
    expect(last, '');

    // after debounce
    await tester.pump(Duration(milliseconds: 100));
    expect(last, 'app');
  });
}
