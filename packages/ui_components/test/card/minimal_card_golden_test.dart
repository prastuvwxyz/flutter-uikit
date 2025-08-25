import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  Widget buildTestWrapper(Widget child) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        extensions: <ThemeExtension<dynamic>>[UiTokens.standard()],
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: child),
        ),
      ),
    );
  }

  group('MinimalCard Golden Tests', () {
    testWidgets('default state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          SizedBox(
            width: 300,
            height: 200,
            child: MinimalCard(
              child: const Center(child: Text('Default Card')),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(MinimalCard),
        matchesGoldenFile('golden/minimal_card_default.png'),
      );
    });

    testWidgets('elevated state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          SizedBox(
            width: 300,
            height: 200,
            child: MinimalCard(
              elevation: 4.0,
              child: const Center(child: Text('Elevated Card')),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(MinimalCard),
        matchesGoldenFile('golden/minimal_card_elevated.png'),
      );
    });

    testWidgets('outlined state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          SizedBox(
            width: 300,
            height: 200,
            child: MinimalCard(
              outlined: true,
              child: const Center(child: Text('Outlined Card')),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(MinimalCard),
        matchesGoldenFile('golden/minimal_card_outlined.png'),
      );
    });

    testWidgets('selected state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          SizedBox(
            width: 300,
            height: 200,
            child: MinimalCard(
              selected: true,
              child: const Center(child: Text('Selected Card')),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(MinimalCard),
        matchesGoldenFile('golden/minimal_card_selected.png'),
      );
    });

    testWidgets('interactive state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          SizedBox(
            width: 300,
            height: 200,
            child: MinimalCard(
              onTap: () {},
              child: const Center(child: Text('Interactive Card')),
            ),
          ),
        ),
      );

      // Hover over the card to test hover state
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(MinimalCard)));
      await tester.pump();

      await expectLater(
        find.byType(MinimalCard),
        matchesGoldenFile('golden/minimal_card_hover.png'),
      );
    });
  });
}
