import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Overlay shows when isLoading true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalLoadingOverlay(
          isLoading: true,
          child: Scaffold(body: Text('behind')),
          message: 'Loading...',
        ),
      ),
    );

    // overlay should show loading text
    expect(find.text('Loading...'), findsOneWidget);
  });
}
