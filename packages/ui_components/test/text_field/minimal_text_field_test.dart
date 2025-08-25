import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  testWidgets('MinimalTextField renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[UiTokens.standard()],
        ),
        home: Scaffold(
          body: Center(
            child: MinimalTextField(
              label: 'Test Label',
              placeholder: 'Test placeholder',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test Label'), findsOneWidget);
    expect(find.text('Test placeholder'), findsOneWidget);
  });

  testWidgets('MinimalTextField shows helper text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[UiTokens.standard()],
        ),
        home: Scaffold(
          body: Center(
            child: MinimalTextField(
              label: 'Test Label',
              helperText: 'Helper text',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Helper text'), findsOneWidget);
  });

  testWidgets('MinimalTextField shows error text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[UiTokens.standard()],
        ),
        home: Scaffold(
          body: Center(
            child: MinimalTextField(
              label: 'Test Label',
              errorText: 'Error message',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('MinimalTextField shows required indicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[UiTokens.standard()],
        ),
        home: Scaffold(
          body: Center(
            child: MinimalTextField(label: 'Test Label', required: true),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('* Required'), findsOneWidget);
  });

  testWidgets('MinimalTextField handles text input', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[UiTokens.standard()],
        ),
        home: Scaffold(
          body: Center(
            child: MinimalTextField(
              label: 'Test Label',
              controller: controller,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Test input');
    expect(controller.text, 'Test input');
  });

  testWidgets('MinimalTextField onChanged callback', (
    WidgetTester tester,
  ) async {
    String changedValue = '';

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[UiTokens.standard()],
        ),
        home: Scaffold(
          body: Center(
            child: MinimalTextField(
              label: 'Test Label',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Changed text');
    expect(changedValue, 'Changed text');
  });

  testWidgets('MinimalTextField toggles password visibility', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[UiTokens.standard()],
        ),
        home: Scaffold(
          body: Center(
            child: MinimalTextField(
              label: 'Password',
              type: TextFieldType.password,
            ),
          ),
        ),
      ),
    );

    // Enter text to make the visibility toggle appear
    await tester.enterText(find.byType(TextFormField), 'password123');
    await tester.pumpAndSettle();

    // Find the visibility icon button
    final iconButton = find.byIcon(Icons.visibility_outlined);
    expect(iconButton, findsOneWidget);

    // Get the first EditableText widget from the tree
    EditableText editableText = tester.widget(find.byType(EditableText));

    // By default password should be obscured
    expect(editableText.obscureText, true);

    // Tap the icon to toggle visibility
    await tester.tap(iconButton);
    await tester.pumpAndSettle();

    // Get the updated EditableText widget
    editableText = tester.widget(find.byType(EditableText));

    // Password should now be visible
    expect(editableText.obscureText, false);

    // Icon should have changed
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets('MinimalTextField validation runs on submit', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[UiTokens.standard()],
        ),
        home: Scaffold(
          body: Center(
            child: MinimalTextField(
              label: 'Email',
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );

    // Enter invalid email
    await tester.enterText(find.byType(TextFormField), 'invalidemail');

    // Submit the field
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Should show validation error
    expect(find.text('Enter a valid email'), findsOneWidget);

    // Enter valid email
    await tester.enterText(find.byType(TextFormField), 'valid@email.com');

    // Submit again
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Error should be gone
    expect(find.text('Enter a valid email'), findsNothing);
  });
}
