import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Shows on hover after delay and hides when hover ends', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: MinimalTooltip(
              message: 'Hello tooltip',
              showDelay: Duration(milliseconds: 200),
              hideDelay: Duration(milliseconds: 50),
              child: Container(width: 100, height: 30, color: Colors.blue),
            ),
          ),
        ),
      ),
    );

    final finder = find.byType(MinimalTooltip);
    expect(finder, findsOneWidget);

    final target = find.byType(Container);
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    await tester.pumpAndSettle();

    // Move mouse over the target
    final targetBox = tester.getCenter(target);
    await gesture.moveTo(targetBox);
    await tester.pump();

    // before delay, tooltip not visible
    expect(find.text('Hello tooltip'), findsNothing);

    // after show delay
    await tester.pump(Duration(milliseconds: 250));
    expect(find.text('Hello tooltip'), findsOneWidget);

    // move out
    await gesture.moveTo(Offset(0, 0));
    await tester.pump();
    await tester.pump(Duration(milliseconds: 100));
    expect(find.text('Hello tooltip'), findsNothing);
  });
}
