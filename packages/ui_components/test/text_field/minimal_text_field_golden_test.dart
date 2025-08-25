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

  group('MinimalTextField Golden Tests', () {
    testWidgets('default state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          const MinimalTextField(
            label: 'Username',
            placeholder: 'Enter your username',
          ),
        ),
      );
      await expectLater(
        find.byType(MinimalTextField),
        matchesGoldenFile('golden/minimal_text_field_default.png'),
      );
    });

    testWidgets('focused state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          const MinimalTextField(
            label: 'Username',
            placeholder: 'Enter your username',
          ),
        ),
      );

      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MinimalTextField),
        matchesGoldenFile('golden/minimal_text_field_focused.png'),
      );
    });

    testWidgets('filled state', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'John Doe');

      await tester.pumpWidget(
        buildTestWrapper(
          MinimalTextField(label: 'Username', controller: controller),
        ),
      );

      await expectLater(
        find.byType(MinimalTextField),
        matchesGoldenFile('golden/minimal_text_field_filled.png'),
      );
    });

    testWidgets('error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          const MinimalTextField(
            label: 'Email',
            placeholder: 'Enter your email',
            errorText: 'Invalid email format',
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalTextField),
        matchesGoldenFile('golden/minimal_text_field_error.png'),
      );
    });

    testWidgets('disabled state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          const MinimalTextField(
            label: 'Username',
            placeholder: 'Enter your username',
            enabled: false,
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalTextField),
        matchesGoldenFile('golden/minimal_text_field_disabled.png'),
      );
    });

    testWidgets('with icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          const MinimalTextField(
            label: 'Search',
            placeholder: 'Search...',
            leading: Icon(Icons.search),
            trailing: Icon(Icons.clear),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalTextField),
        matchesGoldenFile('golden/minimal_text_field_with_icons.png'),
      );
    });

    testWidgets('multiline', (WidgetTester tester) async {
      final controller = TextEditingController(
        text:
            'This is a multiline text field example with multiple lines of text.',
      );

      await tester.pumpWidget(
        buildTestWrapper(
          MinimalTextField(
            label: 'Description',
            placeholder: 'Enter description',
            maxLines: 3,
            controller: controller,
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalTextField),
        matchesGoldenFile('golden/minimal_text_field_multiline.png'),
      );
    });
  });
}
