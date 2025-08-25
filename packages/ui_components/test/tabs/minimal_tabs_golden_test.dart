import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  group('MinimalTabs Golden Tests', () {
    testWidgets('Underline variant', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: Center(
              child: MinimalTabs(
                tabs: const [
                  TabItem(label: 'Home'),
                  TabItem(label: 'Profile'),
                  TabItem(label: 'Settings'),
                ],
                variant: TabVariant.underline,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalTabs),
        matchesGoldenFile('goldens/minimal_tabs_underline.png'),
      );
    });

    testWidgets('Pill variant', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: Center(
              child: MinimalTabs(
                tabs: const [
                  TabItem(label: 'Day'),
                  TabItem(label: 'Week'),
                  TabItem(label: 'Month'),
                ],
                variant: TabVariant.pill,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalTabs),
        matchesGoldenFile('goldens/minimal_tabs_pill.png'),
      );
    });

    testWidgets('Segmented variant', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: Center(
              child: MinimalTabs(
                tabs: const [
                  TabItem(label: 'Details'),
                  TabItem(label: 'Reviews'),
                  TabItem(label: 'Related'),
                ],
                variant: TabVariant.segmented,
                fullWidth: true,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalTabs),
        matchesGoldenFile('goldens/minimal_tabs_segmented.png'),
      );
    });

    testWidgets('With badges', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: Center(
              child: MinimalTabs(
                tabs: const [
                  TabItem(label: 'Inbox', badgeCount: 3),
                  TabItem(label: 'Sent'),
                  TabItem(label: 'Archived', badgeCount: 99),
                  TabItem(label: 'Trash', badgeCount: 999),
                ],
                variant: TabVariant.underline,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalTabs),
        matchesGoldenFile('goldens/minimal_tabs_with_badges.png'),
      );
    });

    testWidgets('Scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: MinimalTabs(
                  tabs: const [
                    TabItem(label: 'Dashboard'),
                    TabItem(label: 'Analytics'),
                    TabItem(label: 'Customers'),
                    TabItem(label: 'Inventory'),
                    TabItem(label: 'Reports'),
                    TabItem(label: 'Settings'),
                  ],
                  scrollable: true,
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalTabs),
        matchesGoldenFile('goldens/minimal_tabs_scrollable.png'),
      );
    });
  });
}
