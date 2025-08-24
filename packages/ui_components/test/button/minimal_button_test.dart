import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_tokens/ui_tokens.dart';
import '../../lib/src/button/minimal_button.dart';

void main() {
  group('MinimalButton', () {
    testWidgets('renders with text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              UiTokens.standard(),
            ],
          ),
          home: Scaffold(
            body: MinimalButton(
              child: const Text('Button Text'),
            ),
          ),
        ),
      );
      
      expect(find.text('Button Text'), findsOneWidget);
    });
    
    testWidgets('handles onPressed callback', (tester) async {
      int pressCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              UiTokens.standard(),
            ],
          ),
          home: Scaffold(
            body: MinimalButton(
              onPressed: () => pressCount++,
              child: const Text('Pressable Button'),
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Pressable Button'));
      expect(pressCount, 1);
      
      await tester.tap(find.text('Pressable Button'));
      expect(pressCount, 2);
    });
    
    testWidgets('disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              UiTokens.standard(),
            ],
          ),
          home: Scaffold(
            body: MinimalButton(
              onPressed: null,
              child: const Text('Disabled Button'),
            ),
          ),
        ),
      );
      
      expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
    });
    
    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              UiTokens.standard(),
            ],
          ),
          home: Scaffold(
            body: MinimalButton(
              isLoading: true,
              child: const Text('Loading Button'),
            ),
          ),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Button'), findsNothing);
    });
    
    testWidgets('renders with leading icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              UiTokens.standard(),
            ],
          ),
          home: Scaffold(
            body: MinimalButton(
              leading: const Icon(Icons.star),
              child: const Text('Icon Button'),
            ),
          ),
        ),
      );
      
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Icon Button'), findsOneWidget);
    });
    
    testWidgets('renders with trailing icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              UiTokens.standard(),
            ],
          ),
          home: Scaffold(
            body: MinimalButton(
              trailing: const Icon(Icons.arrow_forward),
              child: const Text('Icon Button'),
            ),
          ),
        ),
      );
      
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Icon Button'), findsOneWidget);
    });
    
    testWidgets('expands to full width when fullWidth is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              UiTokens.standard(),
            ],
          ),
          home: Scaffold(
            body: MinimalButton(
              fullWidth: true,
              child: const Text('Full Width Button'),
            ),
          ),
        ),
      );
      
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, equals(double.infinity));
    });
    
    testWidgets('applies different sizes correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              UiTokens.standard(),
            ],
          ),
          home: Scaffold(
            body: Column(
              children: [
                MinimalButton(
                  size: ButtonSize.sm,
                  child: const Text('Small Button'),
                ),
                MinimalButton(
                  size: ButtonSize.md,
                  child: const Text('Medium Button'),
                ),
                MinimalButton(
                  size: ButtonSize.lg,
                  child: const Text('Large Button'),
                ),
              ],
            ),
          ),
        ),
      );
      
      final smallButton = tester.widget<SizedBox>(
        find.ancestor(
          of: find.text('Small Button'),
          matching: find.byType(SizedBox),
        ).first,
      );
      
      final mediumButton = tester.widget<SizedBox>(
        find.ancestor(
          of: find.text('Medium Button'),
          matching: find.byType(SizedBox),
        ).first,
      );
      
      final largeButton = tester.widget<SizedBox>(
        find.ancestor(
          of: find.text('Large Button'),
          matching: find.byType(SizedBox),
        ).first,
      );
      
      expect(smallButton.height, 32.0);
      expect(mediumButton.height, 40.0);
      expect(largeButton.height, 48.0);
    });
  });
}
