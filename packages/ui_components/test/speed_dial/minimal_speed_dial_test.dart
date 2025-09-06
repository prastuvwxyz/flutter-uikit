import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/speed_dial/minimal_speed_dial.dart';
import 'package:ui_components/src/speed_dial/speed_dial_child.dart';

void main() {
  testWidgets('Tap expands/collapses speed dial and overlay dismisses', (
    tester,
  ) async {
    bool childTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalSpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            children: [
              SpeedDialChild(
                icon: Icons.ac_unit,
                onTap: () {
                  childTapped = true;
                },
              ),
            ],
          ),
        ),
      ),
    );

    // Initially closed
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.ac_unit), findsNothing);

    // Open
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    // Tap child
    await tester.tap(find.byIcon(Icons.ac_unit));
    await tester.pumpAndSettle();
    expect(childTapped, isTrue);

    // Re-open and tap overlay to dismiss
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.ac_unit), findsOneWidget);

    // Tap overlay (a full-screen Container with a GestureDetector)
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.ac_unit), findsNothing);
  });
}
