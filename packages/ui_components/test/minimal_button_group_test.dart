import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('renders with required properties', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalButtonGroup(
          children: [
            MinimalButton(onPressed: () {}, child: const Text('Button 1')),
            MinimalButton(onPressed: () {}, child: const Text('Button 2')),
            MinimalButton(onPressed: () {}, child: const Text('Button 3')),
          ],
        ),
      ),
    );

    expect(find.byType(MinimalButtonGroup), findsOneWidget);
    expect(find.text('Button 1'), findsOneWidget);
    expect(find.text('Button 2'), findsOneWidget);
    expect(find.text('Button 3'), findsOneWidget);
  });

  testWidgets('handles single selection correctly', (tester) async {
    Set<int> selectedIndices = {};

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return MinimalButtonGroup(
              selectionMode: ButtonGroupSelectionMode.single,
              selectedIndices: selectedIndices,
              onSelectionChanged: (indices) {
                setState(() {
                  selectedIndices = indices;
                });
              },
              children: [
                MinimalButton(onPressed: () {}, child: const Text('Button 1')),
                MinimalButton(onPressed: () {}, child: const Text('Button 2')),
              ],
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Button 1'));
    await tester.pumpAndSettle();
    expect(selectedIndices, equals({0}));

    await tester.tap(find.text('Button 2'));
    await tester.pumpAndSettle();
    expect(selectedIndices, equals({1}));
  });

  testWidgets('handles multiple selection correctly', (tester) async {
    Set<int> selectedIndices = {};

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return MinimalButtonGroup(
              selectionMode: ButtonGroupSelectionMode.multiple,
              selectedIndices: selectedIndices,
              onSelectionChanged: (indices) {
                setState(() {
                  selectedIndices = indices;
                });
              },
              children: [
                MinimalButton(onPressed: () {}, child: const Text('Button 1')),
                MinimalButton(onPressed: () {}, child: const Text('Button 2')),
              ],
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Button 1'));
    await tester.pumpAndSettle();
    expect(selectedIndices, equals({0}));

    await tester.tap(find.text('Button 2'));
    await tester.pumpAndSettle();
    expect(selectedIndices, equals({0, 1}));
  });

  testWidgets('supports vertical orientation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MinimalButtonGroup(
          direction: Axis.vertical,
          children: [
            MinimalButton(onPressed: () {}, child: const Text('Button 1')),
            MinimalButton(onPressed: () {}, child: const Text('Button 2')),
          ],
        ),
      ),
    );
    final widget = tester.widget<MinimalButtonGroup>(
      find.byType(MinimalButtonGroup),
    );
    expect(widget.direction, equals(Axis.vertical));
  });
}
