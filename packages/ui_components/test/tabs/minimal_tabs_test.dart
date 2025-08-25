import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  group('MinimalTabs', () {
    testWidgets('Renders correct number of tabs', (WidgetTester tester) async {
      final tabs = [
        const TabItem(label: 'Tab 1'),
        const TabItem(label: 'Tab 2'),
        const TabItem(label: 'Tab 3'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(body: MinimalTabs(tabs: tabs)),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('Shows selected tab with indicator', (
      WidgetTester tester,
    ) async {
      final tabs = [
        const TabItem(label: 'Tab 1'),
        const TabItem(label: 'Tab 2'),
        const TabItem(label: 'Tab 3'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(body: MinimalTabs(tabs: tabs, selectedIndex: 1)),
        ),
      );

      // Verify Tab 2 is selected
      expect(find.byType(TabBar), findsOneWidget);

      // Check for selection - this is simplified as full indicator testing
      // requires more complex verification via RenderObject inspection
      final tabController = tester
          .widget<TabBar>(find.byType(TabBar))
          .controller;
      expect(tabController?.index, 1);
    });

    testWidgets('Triggers onTabChanged when tab is tapped', (
      WidgetTester tester,
    ) async {
      final tabs = [
        const TabItem(label: 'Tab 1'),
        const TabItem(label: 'Tab 2'),
        const TabItem(label: 'Tab 3'),
      ];

      int selectedTabIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return MinimalTabs(
                  tabs: tabs,
                  selectedIndex: selectedTabIndex,
                  onTabChanged: (index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Tap on the second tab
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      // Verify the selected tab index was updated
      expect(selectedTabIndex, 1);
    });

    testWidgets('Arrow keys navigate between tabs', (
      WidgetTester tester,
    ) async {
      final tabs = [
        const TabItem(label: 'Tab 1'),
        const TabItem(label: 'Tab 2'),
        const TabItem(label: 'Tab 3'),
      ];

      int selectedTabIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return MinimalTabs(
                  tabs: tabs,
                  selectedIndex: selectedTabIndex,
                  onTabChanged: (index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Simulate right arrow key press
      await simulateKeyEvent(tester, LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(selectedTabIndex, 1);

      // Simulate right arrow key press again
      await simulateKeyEvent(tester, LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(selectedTabIndex, 2);

      // Simulate left arrow key press
      await simulateKeyEvent(tester, LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(selectedTabIndex, 1);
    });

    testWidgets('Displays badges on tabs correctly', (
      WidgetTester tester,
    ) async {
      final tabs = [
        const TabItem(label: 'Tab 1'),
        const TabItem(label: 'Tab 2', badgeCount: 5),
        const TabItem(label: 'Tab 3', badgeCount: 99),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(body: MinimalTabs(tabs: tabs)),
        ),
      );

      // Find text for badge counts
      expect(find.text('5'), findsOneWidget);
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('Disabled tab cannot be selected', (WidgetTester tester) async {
      final tabs = [
        const TabItem(label: 'Tab 1'),
        const TabItem(label: 'Tab 2', disabled: true),
        const TabItem(label: 'Tab 3'),
      ];

      int selectedTabIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return MinimalTabs(
                  tabs: tabs,
                  selectedIndex: selectedTabIndex,
                  onTabChanged: (index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Try to tap on the disabled tab
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      // Selected index should remain unchanged
      expect(selectedTabIndex, 0);
    });

    testWidgets('Different variants render correctly', (
      WidgetTester tester,
    ) async {
      final tabs = List.generate(3, (i) => TabItem(label: 'Tab ${i + 1}'));

      // Test underline variant
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: MinimalTabs(tabs: tabs, variant: TabVariant.underline),
          ),
        ),
      );

      expect(find.byType(MinimalTabs), findsOneWidget);

      // Test pill variant
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: MinimalTabs(tabs: tabs, variant: TabVariant.pill),
          ),
        ),
      );

      expect(find.byType(MinimalTabs), findsOneWidget);

      // Test segmented variant
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: MinimalTabs(tabs: tabs, variant: TabVariant.segmented),
          ),
        ),
      );

      expect(find.byType(MinimalTabs), findsOneWidget);
    });
  });
}

Future<void> simulateKeyEvent(
  WidgetTester tester,
  LogicalKeyboardKey key,
) async {
  await tester.sendKeyEvent(key);
  await tester.pump();
}
