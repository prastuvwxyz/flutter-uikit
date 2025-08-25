import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:ui_components/src/container/minimal_container.dart';

void main() {
  setUpAll(() {
    // Set up for golden tests
    loadAppFonts();
  });

  group('MinimalContainer Golden Tests', () {
    testGoldens('basic-container', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: MinimalContainer(
            width: 200,
            height: 100,
            child: const Center(child: Text('Basic Container')),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
          platform: TargetPlatform.android,
        ),
        surfaceSize: const Size(250, 150),
      );

      await screenMatchesGolden(tester, 'minimal_container/basic-container');
    });

    testGoldens('with-padding', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: MinimalContainer(
            width: 200,
            height: 100,
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.grey[200],
            child: const Center(child: Text('With Padding')),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
          platform: TargetPlatform.android,
        ),
        surfaceSize: const Size(250, 150),
      );

      await screenMatchesGolden(tester, 'minimal_container/with-padding');
    });

    testGoldens('with-border', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: MinimalContainer(
            width: 200,
            height: 100,
            padding: const EdgeInsets.all(16),
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
            child: const Center(child: Text('With Border')),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
          platform: TargetPlatform.android,
        ),
        surfaceSize: const Size(250, 150),
      );

      await screenMatchesGolden(tester, 'minimal_container/with-border');
    });

    testGoldens('with-shadow', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: MinimalContainer(
            width: 200,
            height: 100,
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            child: const Center(child: Text('With Shadow')),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
          platform: TargetPlatform.android,
        ),
        surfaceSize: const Size(250, 150),
      );

      await screenMatchesGolden(tester, 'minimal_container/with-shadow');
    });

    testGoldens('with-decoration', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: MinimalContainer(
            width: 200,
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'With Decoration',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
          platform: TargetPlatform.android,
        ),
        surfaceSize: const Size(250, 150),
      );

      await screenMatchesGolden(tester, 'minimal_container/with-decoration');
    });
  });
}
