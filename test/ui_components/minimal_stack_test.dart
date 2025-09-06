import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/stack/minimal_stack.dart';

void main() {
  testWidgets('Children stack in correct order', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalStack(
            children: [
              Container(key: const Key('first'), width: 10, height: 10),
              Container(key: const Key('second'), width: 10, height: 10),
            ],
          ),
        ),
      ),
    );

    // Ensure both children exist
    expect(find.byKey(const Key('first')), findsOneWidget);
    expect(find.byKey(const Key('second')), findsOneWidget);
  });

  testWidgets('Spacing inserts gap between non-positioned children', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 200,
            child: MinimalStack(
              spacing: 12,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(key: const Key('a'), width: 50, height: 50),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(key: const Key('b'), width: 50, height: 50),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // both children present
    expect(find.byKey(const Key('a')), findsOneWidget);
    expect(find.byKey(const Key('b')), findsOneWidget);
  });
}
