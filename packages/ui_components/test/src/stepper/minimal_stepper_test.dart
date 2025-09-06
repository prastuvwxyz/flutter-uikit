import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('MinimalStepper renders and taps step', (tester) async {
    int tapped = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalStepper(
            currentStep: 0,
            steps: [
              StepData(
                title: const Text('One'),
                content: const Text('Content 1'),
              ),
              StepData(
                title: const Text('Two'),
                content: const Text('Content 2'),
              ),
            ],
            onStepTapped: (i) => tapped = i,
          ),
        ),
      ),
    );

    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);

    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();

    // Since StepData tap triggers onStepTapped with index
    expect(tapped, 1);
  });
}
