import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/bottom_navigation/minimal_bottom_navigation.dart';
import 'package:ui_components/src/bottom_navigation/bottom_navigation_item.dart'
    as nav;
import 'package:flutter/services.dart';

void main() {
  testWidgets('Arrow keys navigate between items', (tester) async {
    int currentIndex = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalBottomNavigation(
          items: [
            nav.BottomNavigationItem(icon: Icon(Icons.home), label: 'Home'),
            nav.BottomNavigationItem(icon: Icon(Icons.search), label: 'Search'),
            nav.BottomNavigationItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: currentIndex,
          onTap: (i) => currentIndex = i,
        ),
      ),
    );
    // Simulate right arrow key
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    // Simulate left arrow key
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    // (Stub: implement focus and selection assertions)
  });
}
