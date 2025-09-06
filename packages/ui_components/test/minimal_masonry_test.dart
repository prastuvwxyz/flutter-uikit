import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

class _TestDelegate implements MinimalMasonryDelegate {
  @override
  final int crossAxisCount;

  _TestDelegate(this.crossAxisCount);

  @override
  double getItemAspectRatio(int index) => (index % 3 + 1).toDouble();
}

void main() {
  testWidgets('MinimalMasonry renders children', (tester) async {
    final children = List.generate(
      6,
      (i) => Container(key: ValueKey('c$i'), height: 50.0 + i * 10),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalMasonry(
            children: children,
            delegate: _TestDelegate(2),
            spacing: 4,
          ),
        ),
      ),
    );

    // Ensure all children exist in the tree
    for (var i = 0; i < children.length; i++) {
      expect(find.byKey(ValueKey('c$i')), findsOneWidget);
    }
  });
}
