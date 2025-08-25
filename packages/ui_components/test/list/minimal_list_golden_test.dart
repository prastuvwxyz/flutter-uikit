import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('MinimalList - Golden Tests', () {
    Widget buildTestApp(Widget child) {
      return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: Center(child: SizedBox(width: 400, height: 600, child: child)),
        ),
      );
    }

    testWidgets('default state', (WidgetTester tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

      await tester.pumpWidget(
        buildTestApp(
          MinimalList<String>(
            items: items,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, item, index) => ListTile(
              title: Text(item),
              subtitle: Text('Item description #${index + 1}'),
              leading: CircleAvatar(child: Text('${index + 1}')),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalList),
        matchesGoldenFile('goldens/minimal_list_default.png'),
      );
    });

    testWidgets('loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MinimalList<String>(
            loading: true,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, item, index) => ListTile(title: Text(item)),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalList),
        matchesGoldenFile('goldens/minimal_list_loading.png'),
      );
    });

    testWidgets('empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MinimalList<String>(
            items: const [],
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, item, index) => ListTile(title: Text(item)),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalList),
        matchesGoldenFile('goldens/minimal_list_empty.png'),
      );
    });

    testWidgets('with-separators', (WidgetTester tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

      await tester.pumpWidget(
        buildTestApp(
          MinimalList<String>(
            items: items,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, item, index) => ListTile(
              title: Text(item),
              subtitle: Text('Item description #${index + 1}'),
            ),
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalList),
        matchesGoldenFile('goldens/minimal_list_with_separators.png'),
      );
    });
  });
}
