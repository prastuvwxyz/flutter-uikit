import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/bottom_navigation/minimal_bottom_navigation.dart';
import 'package:ui_components/src/bottom_navigation/bottom_navigation_item.dart'
    as nav;
// ...existing code...

void main() {
  group('MinimalBottomNavigation', () {
    testWidgets('Tap selects correct item and triggers callback', (
      tester,
    ) async {
      int tappedIndex = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: MinimalBottomNavigation(
            items: [
              nav.BottomNavigationItem(icon: Icon(Icons.home), label: 'Home'),
              nav.BottomNavigationItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              nav.BottomNavigationItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: 0,
            onTap: (i) => tappedIndex = i,
          ),
        ),
      );
      await tester.tap(find.text('Search'));
      expect(tappedIndex, 1);
    });

    testWidgets('Badge displays correctly on items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MinimalBottomNavigation(
            items: [
              nav.BottomNavigationItem(
                icon: Icon(Icons.home),
                label: 'Home',
                badgeCount: 5,
              ),
              nav.BottomNavigationItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
            ],
            currentIndex: 0,
          ),
        ),
      );
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('Labels show/hide based on configuration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MinimalBottomNavigation(
            items: [
              nav.BottomNavigationItem(icon: Icon(Icons.home), label: 'Home'),
              nav.BottomNavigationItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
            ],
            currentIndex: 0,
            showSelectedLabels: true,
            showUnselectedLabels: false,
          ),
        ),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsNothing);
    });

    testWidgets('Selected item highlights properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MinimalBottomNavigation(
            items: [
              nav.BottomNavigationItem(icon: Icon(Icons.home), label: 'Home'),
              nav.BottomNavigationItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
            ],
            currentIndex: 1,
          ),
        ),
      );
      final selectedText = tester.widget<Text>(find.text('Search'));
      expect(selectedText.style?.fontWeight, FontWeight.bold);
    });
  });
}
