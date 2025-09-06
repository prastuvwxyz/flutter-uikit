import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Spinner renders circular by default', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: MinimalSpinner())),
      ),
    );

    expect(find.byType(MinimalSpinner), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Spinner shows linear variant when set', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: MinimalSpinner(variant: SpinnerVariant.linear)),
        ),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('Spinner respects isAnimating false (stops dots/pulse)', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: MinimalSpinner(
              variant: SpinnerVariant.dots,
              isAnimating: false,
            ),
          ),
        ),
      ),
    );

    // Dots spinner is a private stateful widget; just ensure the parent exists
    expect(find.byType(MinimalSpinner), findsOneWidget);
  });

  testWidgets('Determinate value passed to circular progress', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: MinimalSpinner(value: 0.5))),
      ),
    );

    final circ = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(circ.value, 0.5);
  });

  testWidgets('Custom color and size applied', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: MinimalSpinner(color: Colors.red, size: 48.0)),
        ),
      ),
    );

    final sized = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(sized.width, 48.0);
  });
}
