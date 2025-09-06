import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/box/minimal_box.dart';

void main() {
  group('MinimalBox', () {
    testWidgets('Padding applied correctly to child', (
      WidgetTester tester,
    ) async {
      const padding = EdgeInsets.all(16.0);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MinimalBox(padding: padding, child: Text('Test')),
          ),
        ),
      );

      // Find the Padding widget inside the Container
      final paddingWidget = tester.widget<Container>(find.byType(Container));
      expect(paddingWidget.padding, padding);
    });

    testWidgets('Margin affects container positioning', (
      WidgetTester tester,
    ) async {
      const margin = EdgeInsets.all(16.0);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MinimalBox(margin: margin, child: Text('Test')),
          ),
        ),
      );

      // The margin is implemented via a Padding ancestor
      final marginWidget = tester.widget<Padding>(find.byType(Padding).first);
      expect(marginWidget.padding, margin);
    });

    testWidgets('Border displays properly', (WidgetTester tester) async {
      final border = Border.all(color: Colors.black, width: 2.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalBox(border: border, child: const Text('Test')),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;

      expect(boxDecoration.border, border);
    });

    testWidgets('Border radius rounds corners', (WidgetTester tester) async {
      final borderRadius = BorderRadius.circular(8.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalBox(
              borderRadius: borderRadius,
              child: const Text('Test'),
            ),
          ),
        ),
      );

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
            body: MinimalBox(color: backgroundColor, child: Text('Test')),
          ),
        ),
      );

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
            body: MinimalBox(shadow: boxShadow, child: const Text('Test')),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;

      expect(boxDecoration.boxShadow, boxShadow);
    });

    testWidgets('Child alignment works', (WidgetTester tester) async {
      const alignment = Alignment.center;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MinimalBox(alignment: alignment, child: Text('Test')),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.alignment, alignment);
    });

    testWidgets('Rendered size matches width and height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: MinimalBox(width: 250, height: 150, child: Text('Test')),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(Container));
      expect(size, const Size(250, 150));
    });
  });
}
