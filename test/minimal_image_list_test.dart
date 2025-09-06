import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('MinimalImageList builds grid and enforces aspect ratio', (
    WidgetTester tester,
  ) async {
    // Create a few placeholder MinimalImage widgets using asset src
    final images = List.generate(
      6,
      (i) => MinimalImage(
        src: 'assets/images/placeholder.png',
        alt: 'image-$i',
        width: 100,
        height: 100,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalImageList(
            children: images,
            crossAxisCount: 3,
            aspectRatio: 1.0,
            spacing: 8.0,
            shrinkWrap: true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Expect GridView to contain the number of items
    expect(find.byType(MinimalImage), findsNWidgets(6));

    // Each grid tile should include an AspectRatio widget
    expect(find.byType(AspectRatio), findsNWidgets(6));
  });
}
