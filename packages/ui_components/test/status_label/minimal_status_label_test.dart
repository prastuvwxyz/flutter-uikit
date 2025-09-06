import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Renders status label and responds to tap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: MinimalStatusLabel(
              text: 'Success',
              status: StatusType.success,
              icon: Icons.check_circle,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Success'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await tester.tap(find.text('Success'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
