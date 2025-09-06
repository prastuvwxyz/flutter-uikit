import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('MinimalTimeline renders items in order', (
    WidgetTester tester,
  ) async {
    final items = [
      TimelineItem(content: Text('One')),
      TimelineItem(content: Text('Two')),
      TimelineItem(content: Text('Three')),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MinimalTimeline(items: items, shrinkWrap: true)),
      ),
    );

    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
  });
}
