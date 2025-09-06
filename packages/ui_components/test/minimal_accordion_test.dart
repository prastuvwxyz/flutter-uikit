import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders with required properties', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalAccordion(
          children: [
            MinimalAccordionPanel(
              headerBuilder: (context, isExpanded) => const Text('Header 1'),
              bodyBuilder: (context) => const Text('Content 1'),
            ),
            MinimalAccordionPanel(
              headerBuilder: (context, isExpanded) => const Text('Header 2'),
              bodyBuilder: (context) => const Text('Content 2'),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(MinimalAccordion), findsOneWidget);
    expect(find.text('Header 1'), findsOneWidget);
    expect(find.text('Header 2'), findsOneWidget);
  });

  testWidgets('expands and collapses panels correctly', (tester) async {
    Set<int> expandedPanels = {};

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return MinimalAccordion(
              expandedPanels: expandedPanels,
              onExpansionChanged: (panels) {
                setState(() {
                  expandedPanels = panels;
                });
              },
              children: [
                MinimalAccordionPanel(
                  headerBuilder: (context, isExpanded) =>
                      const Text('Header 1'),
                  bodyBuilder: (context) => const Text('Content 1'),
                ),
              ],
            );
          },
        ),
      ),
    );

    // Initially collapsed
    expect(find.text('Content 1'), findsNothing);

    // Tap to expand
    await tester.tap(find.text('Header 1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(expandedPanels, contains(0));
    expect(find.text('Content 1'), findsOneWidget);
  });
}
