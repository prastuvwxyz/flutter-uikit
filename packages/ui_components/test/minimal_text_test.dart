import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/semantics.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders with required properties', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MinimalText('Hello World', variant: TextVariant.h1),
      ),
    );

    expect(find.text('Hello World'), findsOneWidget);
    expect(find.byType(MinimalText), findsOneWidget);
  });

  testWidgets('applies custom color correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MinimalText('Colored Text', color: Colors.red)),
    );

    final textWidget = tester.widget<Text>(find.text('Colored Text'));
    expect(textWidget.style!.color, equals(Colors.red));
  });

  testWidgets('handles text overflow correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 100,
          child: MinimalText(
            'This is a very long text that should overflow',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(
      find.text('This is a very long text that should overflow'),
    );
    expect(textWidget.maxLines, equals(1));
    expect(textWidget.overflow, equals(TextOverflow.ellipsis));
  });

  testWidgets('provides semantics for headings', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MinimalText('Main Heading', variant: TextVariant.h1),
      ),
    );

    final semantics = tester.getSemantics(find.text('Main Heading'));
    expect(semantics.hasFlag(SemanticsFlag.isHeader), isTrue);
  });
}
