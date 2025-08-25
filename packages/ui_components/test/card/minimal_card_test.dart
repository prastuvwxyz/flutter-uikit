import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_tokens/ui_tokens.dart';
import '../../lib/src/card/minimal_card.dart';

void main() {
  group('MinimalCard', () {
    testWidgets('renders with child content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(body: MinimalCard(child: const Text('Card Content'))),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('handles onTap callback', (tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: MinimalCard(
              onTap: () => tapCount++,
              child: const Text('Tappable Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tappable Card'));
      expect(tapCount, 1);
    });

    testWidgets('handles onLongPress callback', (tester) async {
      int longPressCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: MinimalCard(
              onLongPress: () => longPressCount++,
              child: const Text('Long Pressable Card'),
            ),
          ),
        ),
      );

      await tester.longPress(find.text('Long Pressable Card'));
      expect(longPressCount, 1);
    });

    testWidgets('shows selected state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: MinimalCard(
              selected: true,
              child: const Text('Selected Card'),
            ),
          ),
        ),
      );

      final Semantics semantics = tester.widget(find.byType(Semantics));
      expect(semantics.properties.selected, isTrue);

      // The selected card should have a primary container color background
      final Container container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimatedContainer),
          matching: find.byType(Container),
        ),
      );

      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNotNull);
    });

    testWidgets('outlined variant shows border instead of shadow', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: MinimalCard(
              outlined: true,
              child: const Text('Outlined Card'),
            ),
          ),
        ),
      );

      final AnimatedContainer container = tester.widget(
        find.byType(AnimatedContainer),
      );
      final BoxDecoration decoration = container.decoration as BoxDecoration;

      expect(decoration.border, isNotNull);
      expect(decoration.boxShadow, isNull);
    });

    testWidgets('default card has elevation and shadow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(body: MinimalCard(child: const Text('Default Card'))),
        ),
      );

      final AnimatedContainer container = tester.widget(
        find.byType(AnimatedContainer),
      );
      final BoxDecoration decoration = container.decoration as BoxDecoration;

      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.isNotEmpty, isTrue);
    });

    testWidgets('custom padding is applied', (tester) async {
      const customPadding = EdgeInsets.all(24.0);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: MinimalCard(
              padding: customPadding,
              child: const Text('Custom Padding Card'),
            ),
          ),
        ),
      );

      final Padding padding = tester.widget(
        find.descendant(
          of: find.byType(InkWell),
          matching: find.byType(Padding),
        ),
      );

      expect(padding.padding, equals(customPadding));
    });
  });
}
