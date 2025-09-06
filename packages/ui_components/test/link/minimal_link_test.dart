import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Tap triggers onTap and marks visited', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalLink(
            url: 'https://example.com',
            onTap: () => tapped = true,
            child: const Text('Example Link'),
          ),
        ),
      ),
    );

    expect(find.text('Example Link'), findsOneWidget);

    await tester.tap(find.text('Example Link'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
