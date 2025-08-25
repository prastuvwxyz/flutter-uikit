import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/drawer/minimal_drawer.dart';
import 'package:ui_components/src/drawer/minimal_drawer_controller.dart';

void main() {
  testWidgets('MinimalDrawer opens with smooth animation', (
    WidgetTester tester,
  ) async {
    final GlobalKey<MinimalDrawerState> drawerKey =
        GlobalKey<MinimalDrawerState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalDrawerController(
            drawerKey: drawerKey,
            child: Stack(
              children: [
                const SizedBox.expand(),
                MinimalDrawer(
                  key: drawerKey,
                  child: const Text('Drawer Content'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Initially the drawer should be closed (off-screen)
    expect(find.text('Drawer Content'), findsNothing);

    // Open the drawer
    drawerKey.currentState?.open();
    await tester.pump();

    // After the animation starts, we should see part of the drawer
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Drawer Content'), findsOneWidget);

    // Complete the animation
    await tester.pumpAndSettle();
    expect(find.text('Drawer Content'), findsOneWidget);
  });

  testWidgets('MinimalDrawer closes when backdrop is tapped', (
    WidgetTester tester,
  ) async {
    final GlobalKey<MinimalDrawerState> drawerKey =
        GlobalKey<MinimalDrawerState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalDrawerController(
            drawerKey: drawerKey,
            child: Stack(
              children: [
                const SizedBox.expand(),
                MinimalDrawer(
                  key: drawerKey,
                  child: const Text('Drawer Content'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Open the drawer
    drawerKey.currentState?.open();
    await tester.pumpAndSettle();
    expect(find.text('Drawer Content'), findsOneWidget);

    // Find the scrim/backdrop and tap it
    final scrimFinder = find.byType(GestureDetector).first;
    await tester.tap(scrimFinder);
    await tester.pumpAndSettle();

    // Drawer should be closed now
    expect(find.text('Drawer Content'), findsNothing);
  });

  testWidgets('MinimalDrawer closes when escape key is pressed', (
    WidgetTester tester,
  ) async {
    final GlobalKey<MinimalDrawerState> drawerKey =
        GlobalKey<MinimalDrawerState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalDrawerController(
            drawerKey: drawerKey,
            child: Stack(
              children: [
                const SizedBox.expand(),
                MinimalDrawer(
                  key: drawerKey,
                  child: const Text('Drawer Content'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Open the drawer
    drawerKey.currentState?.open();
    await tester.pumpAndSettle();
    expect(find.text('Drawer Content'), findsOneWidget);

    // Simulate pressing the escape key
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    // Drawer should be closed now
    expect(find.text('Drawer Content'), findsNothing);
  });

  testWidgets('MinimalDrawer supports custom width', (
    WidgetTester tester,
  ) async {
    final GlobalKey<MinimalDrawerState> drawerKey =
        GlobalKey<MinimalDrawerState>();
    const customWidth = 250.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalDrawerController(
            drawerKey: drawerKey,
            child: Stack(
              children: [
                const SizedBox.expand(),
                MinimalDrawer(
                  key: drawerKey,
                  width: customWidth,
                  child: const Text('Drawer Content'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Open the drawer
    drawerKey.currentState?.open();
    await tester.pumpAndSettle();

    // Find the SizedBox that constrains the drawer width
    final sizedBoxFinder = find.byType(SizedBox).last;
    final SizedBox sizedBox = tester.widget(sizedBoxFinder);

    expect(sizedBox.width, equals(customWidth));
  });

  testWidgets('MinimalDrawerController can toggle the drawer', (
    WidgetTester tester,
  ) async {
    final GlobalKey<MinimalDrawerState> drawerKey =
        GlobalKey<MinimalDrawerState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: MinimalDrawerController(
              drawerKey: drawerKey,
              child: Stack(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () => MinimalDrawerController.toggle(context),
                      child: const Text('Toggle Drawer'),
                    ),
                  ),
                  MinimalDrawer(
                    key: drawerKey,
                    child: const Text('Drawer Content'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Initially the drawer should be closed
    expect(find.text('Drawer Content'), findsNothing);

    // Tap the toggle button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Drawer should be open
    expect(find.text('Drawer Content'), findsOneWidget);

    // Tap the toggle button again
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Drawer should be closed again
    expect(find.text('Drawer Content'), findsNothing);
  });
}
