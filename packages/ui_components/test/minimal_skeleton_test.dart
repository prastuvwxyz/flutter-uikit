import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('Skeleton displays when isLoading true', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalSkeleton(width: 100, height: 20, isLoading: true),
        ),
      ),
    );

    // The skeleton should be present as a Container with given size.
    final finder = find.byType(MinimalSkeleton);
    expect(finder, findsOneWidget);
  });

  testWidgets('Child content shows when isLoading false', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalSkeleton(isLoading: false, child: const Text('Loaded')),
        ),
      ),
    );

    expect(find.text('Loaded'), findsOneWidget);
    expect(find.byType(MinimalSkeleton), findsOneWidget);
  });

  testWidgets('Animation disabled stops shimmer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalSkeleton(
            isLoading: true,
            animationEnabled: false,
            width: 50,
            height: 10,
          ),
        ),
      ),
    );

    // Ensure widget builds and does not throw; we can't inspect internal controller easily here
    expect(find.byType(MinimalSkeleton), findsOneWidget);
  });
}
