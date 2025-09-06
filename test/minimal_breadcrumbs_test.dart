import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/breadcrumbs/minimal_breadcrumbs.dart';
import 'package:ui_components/src/breadcrumbs/breadcrumb_item.dart';

void main() {
  testWidgets('renders items and separators and responds to taps', (
    tester,
  ) async {
    var tapped = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalBreadcrumbs(
            items: [
              const BreadcrumbItem(child: Text('Home')),
              const BreadcrumbItem(child: Text('Library')),
              const BreadcrumbItem(child: Text('Data'), isCurrent: true),
            ],
            onItemTapped: (i) => tapped = i,
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Data'), findsOneWidget);

    // separator default is '/'
    expect(find.text('/'), findsNWidgets(2));

    await tester.tap(find.text('Library'));
    expect(tapped, 1);
  });
}
