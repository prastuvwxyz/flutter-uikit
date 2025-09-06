import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders banner with message and title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalNotificationBanner(
            title: 'Hello',
            message: 'This is a test',
          ),
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('This is a test'), findsOneWidget);
  });

  testWidgets('dismiss button hides the banner', (WidgetTester tester) async {
    bool dismissed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalNotificationBanner(
            title: 'Hello',
            message: 'Dismiss me',
            isDismissible: true,
            onDismiss: () => dismissed = true,
          ),
        ),
      ),
    );

    expect(find.text('Dismiss me'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(dismissed, isTrue);
  });

  testWidgets('auto-hide hides after duration', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalNotificationBanner(
            message: 'Auto hide',
            autoHide: true,
            autoHideDuration: Duration(milliseconds: 100),
          ),
        ),
      ),
    );

    expect(find.text('Auto hide'), findsOneWidget);
    await tester.pump(Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('Auto hide'), findsNothing);
  });
}
