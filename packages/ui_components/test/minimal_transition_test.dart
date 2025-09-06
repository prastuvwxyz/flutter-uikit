import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/transition/transition.dart';

void main() {
  testWidgets('Fade transition triggers onComplete after animation', (
    WidgetTester tester,
  ) async {
    var completed = false;

    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        home: MinimalTransition(
          type: TransitionType.fade,
          duration: const Duration(milliseconds: 100),
          child: const Text('hello'),
          onComplete: () {
            completed = true;
          },
        ),
      ),
    );

    // start the animation and advance in small frames
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 60));

    expect(completed, isTrue);
  });
}
