import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalListTile(
            title: const Text('Title'),
            subtitle: const Text('Subtitle'),
          ),
        ),
      ),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
  });

  testWidgets('calls onTap and onLongPress', (tester) async {
    var tapped = false;
    var longPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalListTile(
            title: const Text('T'),
            onTap: () => tapped = true,
            onLongPress: () => longPressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('T'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);

    await tester.longPress(find.text('T'));
    await tester.pumpAndSettle();
    expect(longPressed, isTrue);
  });

  testWidgets('disabled prevents interactions', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalListTile(
            title: const Text('T'),
            enabled: false,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('T'));
    await tester.pumpAndSettle();
    expect(tapped, isFalse);
  });

  testWidgets('selected uses selectedTileColor', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalListTile(
            title: const Text('T'),
            selected: true,
            selectedTileColor: Colors.red,
          ),
        ),
      ),
    );

    // Find the Material that belongs to the MinimalListTile itself (descendant)
    final tileFinder = find.byType(MinimalListTile);
    final material = tester
        .widgetList<Material>(
          find.descendant(of: tileFinder, matching: find.byType(Material)),
        )
        .first;
    expect(material.color, Colors.red);
  });
}
