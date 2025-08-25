import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/container/minimal_container.dart';

void main() {
  group('MinimalContainer', () {
    testWidgets('Padding applied correctly to child', (
      WidgetTester tester,
    ) async {
      const padding = EdgeInsets.all(16.0);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MinimalContainer(padding: padding, child: Text('Test')),
          ),
        ),
      );

      // Find the Padding widget and check its value
      final paddingWidget = tester.widget<Padding>(
        find.descendant(
          of: find.byType(Container),
          matching: find.byType(Padding),
        ),
      );

      expect(paddingWidget.padding, padding);
    });

    testWidgets('Margin affects container positioning', (
      WidgetTester tester,
    ) async {
      const margin = EdgeInsets.all(16.0);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MinimalContainer(margin: margin, child: Text('Test')),
          ),
        ),
      );

      // Find the Padding widget created by margin and check its value
      final marginWidget = tester.widget<Padding>(find.byType(Padding).first);
      expect(marginWidget.padding, margin);
    });

    testWidgets('Border displays properly', (WidgetTester tester) async {
      final border = Border.all(color: Colors.black, width: 2.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalContainer(border: border, child: const Text('Test')),
          ),
        ),
      );

      // Find the Container and check its decoration
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;

      expect(boxDecoration.border, border);
    });

    testWidgets('Border radius rounds corners', (WidgetTester tester) async {
      final borderRadius = BorderRadius.circular(8.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalContainer(
              borderRadius: borderRadius,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      // Find the Container and check its decoration
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;

      expect(boxDecoration.borderRadius, borderRadius);
    });

    testWidgets('Background color fills container', (
      WidgetTester tester,
    ) async {
      const backgroundColor = Colors.blue;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MinimalContainer(
              backgroundColor: backgroundColor,
              child: Text('Test'),
            ),
          ),
        ),
      );

      // Find the Container and check its decoration
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;

      expect(boxDecoration.color, backgroundColor);
    });

    testWidgets('Box shadow renders correctly', (WidgetTester tester) async {
      final boxShadow = [
        const BoxShadow(
          color: Colors.black26,
          blurRadius: 4.0,
          offset: Offset(0, 2),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalContainer(
              boxShadow: boxShadow,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      // Find the Container and check its decoration
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;

      expect(boxDecoration.boxShadow, boxShadow);
    });

    testWidgets('Child alignment works', (WidgetTester tester) async {
      const alignment = Alignment.center;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MinimalContainer(alignment: alignment, child: Text('Test')),
          ),
        ),
      );

      // Find the Container and check its alignment
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.alignment, alignment);
    });

    testWidgets('Constraints limit container size', (
      WidgetTester tester,
    ) async {
      const constraints = BoxConstraints(maxWidth: 200, maxHeight: 100);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MinimalContainer(
              constraints: constraints,
              child: Text('Test'),
            ),
          ),
        ),
      );

      // Find the Container and check its constraints
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints, constraints);
    });
  });
}
