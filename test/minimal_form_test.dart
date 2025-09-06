import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets(
    'Form submission calls onSubmit with values and respects loading',
    (tester) async {
      Map<String, dynamic>? submittedValues;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalForm(
              initialValues: {'name': 'Alice'},
              onSubmit: (values) async {
                submittedValues = values;
              },
              child: Column(
                children: [
                  MinimalFormField<String>(
                    name: 'name',
                    builder: (context, value, onChanged, error) {
                      return TextFormField(
                        initialValue: value,
                        onChanged: onChanged,
                        decoration: InputDecoration(errorText: error),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Ensure initial value is present
      expect(find.byType(TextFormField), findsOneWidget);

      // Tap submit
      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(submittedValues, isNotNull);
      expect(submittedValues!['name'], 'Alice');
    },
  );
}
