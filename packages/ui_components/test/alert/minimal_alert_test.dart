import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  testWidgets('MinimalAlert displays correct message', (
    WidgetTester tester,
  ) async {
    const message = 'Test alert message';

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: const Scaffold(body: MinimalAlert(message: message)),
      ),
    );

    expect(find.text(message), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget); // Default info icon
    expect(find.byType(IconButton), findsOneWidget); // Close button
  });

  testWidgets('MinimalAlert displays title when provided', (
    WidgetTester tester,
  ) async {
    const title = 'Alert Title';
    const message = 'Alert message content';

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: const Scaffold(
          body: MinimalAlert(title: title, message: message),
        ),
      ),
    );

    expect(find.text(title), findsOneWidget);
    expect(find.text(message), findsOneWidget);
  });

  testWidgets('MinimalAlert shows different icon based on type', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: const Scaffold(
          body: Column(
            children: [
              MinimalAlert(type: AlertType.success, message: 'Success message'),
              MinimalAlert(type: AlertType.error, message: 'Error message'),
            ],
          ),
        ),
      ),
    );

    // Success alert has check icon
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    // Error alert has error icon
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('MinimalAlert respects showIcon=false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: const Scaffold(
          body: MinimalAlert(message: 'No icon alert', showIcon: false),
        ),
      ),
    );

    // There should be no icon visible
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('MinimalAlert custom icon works correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: Scaffold(
          body: MinimalAlert(
            message: 'Custom icon alert',
            icon: const Icon(Icons.star),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('MinimalAlert triggers onClose callback', (
    WidgetTester tester,
  ) async {
    bool wasClosed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: Scaffold(
          body: MinimalAlert(
            message: 'Closable alert',
            onClose: () {
              wasClosed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // Wait for animation

    expect(wasClosed, true);
  });

  testWidgets('MinimalAlert closable=false hides close button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: const Scaffold(
          body: MinimalAlert(message: 'Non-closable alert', closable: false),
        ),
      ),
    );

    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('MinimalAlert displays actions when provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: Scaffold(
          body: MinimalAlert(
            message: 'Alert with actions',
            actions: [
              TextButton(onPressed: () {}, child: const Text('Action 1')),
              TextButton(onPressed: () {}, child: const Text('Action 2')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Action 1'), findsOneWidget);
    expect(find.text('Action 2'), findsOneWidget);
  });

  testWidgets('MinimalAlert supports different variants', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: const Scaffold(
          body: Column(
            children: [
              MinimalAlert(
                message: 'Filled alert',
                variant: AlertVariant.filled,
              ),
              MinimalAlert(
                message: 'Outlined alert',
                variant: AlertVariant.outlined,
              ),
              MinimalAlert(message: 'Ghost alert', variant: AlertVariant.ghost),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Filled alert'), findsOneWidget);
    expect(find.text('Outlined alert'), findsOneWidget);
    expect(find.text('Ghost alert'), findsOneWidget);
  });

  testWidgets('MinimalAlert can be dismissed with Escape key', (
    WidgetTester tester,
  ) async {
    bool wasClosed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: Scaffold(
          body: MinimalAlert(
            message: 'Escape key test',
            onClose: () {
              wasClosed = true;
            },
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // Wait for animation

    expect(wasClosed, true);
  });
}
