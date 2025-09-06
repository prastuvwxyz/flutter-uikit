import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders pagination and navigates', (WidgetTester tester) async {
    var page = 2;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: MinimalPagination(
              currentPage: page,
              totalPages: 5,
              onPageChanged: (p) => page = p,
            ),
          ),
        ),
      ),
    );

    expect(find.text('2'), findsWidgets);

    // Tap next
    await tester.tap(find.byTooltip('Next'));
    await tester.pumpAndSettle();
    expect(page, 3);

    // Tap first
    await tester.tap(find.byTooltip('First'));
    await tester.pumpAndSettle();
    expect(page, 1);
  });
}
