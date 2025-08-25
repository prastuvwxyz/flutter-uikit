import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  group('MinimalDialog Golden Tests', () {
    testWidgets('basic - renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light().copyWith(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                child: MinimalDialog(
                  title: 'Basic Dialog',
                  content: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'This is a basic dialog with title and actions.',
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: () {}, child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await expectLater(
        find.byType(RepaintBoundary).first,
        matchesGoldenFile('goldens/minimal_dialog_basic.png'),
      );
    });

    testWidgets('with-icon - renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light().copyWith(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                child: MinimalDialog(
                  title: 'Dialog with Icon',
                  icon: const Icon(Icons.info_outline, color: Colors.blue),
                  content: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('This is a dialog with an icon in the header.'),
                  ),
                  actions: [
                    TextButton(onPressed: () {}, child: const Text('Cancel')),
                    ElevatedButton(onPressed: () {}, child: const Text('OK')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await expectLater(
        find.byType(RepaintBoundary).first,
        matchesGoldenFile('goldens/minimal_dialog_with_icon.png'),
      );
    });

    testWidgets('fullscreen - renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light().copyWith(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                child: SizedBox(
                  width: 800,
                  height: 600,
                  child: MinimalDialog(
                    title: 'Fullscreen Dialog',
                    size: DialogSize.fullscreen,
                    content: const Center(
                      child: Text('This is a fullscreen dialog.'),
                    ),
                    actions: [
                      TextButton(onPressed: () {}, child: const Text('Close')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await expectLater(
        find.byType(RepaintBoundary).first,
        matchesGoldenFile('goldens/minimal_dialog_fullscreen.png'),
      );
    });

    testWidgets('scrollable - renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light().copyWith(extensions: [UiTokens.standard()]),
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                child: SizedBox(
                  width: 500,
                  height: 400,
                  child: MinimalDialog(
                    title: 'Scrollable Dialog',
                    scrollable: true,
                    content: Column(
                      children: List.generate(
                        15,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                color: Colors.blue.withOpacity(0.2),
                                alignment: Alignment.center,
                                child: Text('${index + 1}'),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Scrollable content line ${index + 1}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: () {}, child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await expectLater(
        find.byType(RepaintBoundary).first,
        matchesGoldenFile('goldens/minimal_dialog_scrollable.png'),
      );
    });
  });
}
