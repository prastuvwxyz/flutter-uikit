import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders with child', (tester) async {
    bool selected = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MinimalToggleButton(
          isSelected: selected,
          onPressed: (s) => selected = s,
          child: const Text('Toggle'),
        ),
      ),
    );

    expect(find.text('Toggle'), findsOneWidget);
  });

  testWidgets('toggles on tap', (tester) async {
    bool selected = false;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return MinimalToggleButton(
              isSelected: selected,
              onPressed: (s) => setState(() => selected = s),
              child: const Text('Toggle'),
            );
          },
        ),
      ),
    );

    expect(selected, isFalse);
    await tester.tap(find.byType(MinimalToggleButton));
    await tester.pumpAndSettle();
    expect(selected, isTrue);
  });

  testWidgets('shows loading state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalToggleButton(
          isSelected: false,
          onPressed: (s) {},
          isLoading: true,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('respects disabled state', (tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MinimalToggleButton(
          isSelected: false,
          onPressed: (s) => pressed = true,
          isEnabled: false,
          child: const Text('Toggle'),
        ),
      ),
    );

    await tester.tap(find.byType(MinimalToggleButton));
    await tester.pumpAndSettle();
    expect(pressed, isFalse);
  });

  testWidgets('semantics reflect toggle state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalToggleButton(
          isSelected: true,
          onPressed: (s) {},
          tooltip: 'Toggle favorite',
          child: const Text('Toggle'),
        ),
      ),
    );

    // Look for any Semantics descendant that has the tooltip as label
    final semanticsDescendants = find.descendant(
      of: find.byType(MinimalToggleButton),
      matching: find.byType(Semantics),
    );

    final widgets = semanticsDescendants
        .evaluate()
        .map((e) => e.widget)
        .whereType<Semantics>()
        .toList();
    // Ensure at least one semantics node exists
    expect(widgets, isNotEmpty);

    final hasLabel = widgets.any(
      (s) => s.properties.label == 'Toggle favorite',
    );
    final hasSelected = widgets.any((s) => s.properties.selected == true);

    expect(hasLabel || hasSelected, isTrue);
  });
}
