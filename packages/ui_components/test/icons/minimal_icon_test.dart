import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders with required properties', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MinimalIcon(Icons.home, size: 24.0)),
    );

    expect(find.byType(MinimalIcon), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
  });

  testWidgets('provides custom semantic labels', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MinimalIcon(Icons.menu, semanticLabel: 'Open navigation menu'),
      ),
    );

    final semantics = tester.getSemantics(find.byType(MinimalIcon));
    expect(semantics.label, equals('Open navigation menu'));
  });

  testWidgets('supports different sizes', (tester) async {
    const sizes = [12.0, 16.0, 24.0, 32.0];
    for (final s in sizes) {
      await tester.pumpWidget(
        MaterialApp(home: MinimalIcon(Icons.home, size: s)),
      );

      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.size, equals(s));
    }
  });
}
