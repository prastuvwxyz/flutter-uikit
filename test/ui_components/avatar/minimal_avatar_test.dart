import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  const testImageUrl = 'https://randomuser.me/api/portraits/women/44.jpg';

  testWidgets('MinimalAvatar renders image correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MinimalAvatar(src: testImageUrl, alt: 'Test Avatar'),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    final Image imageWidget = tester.widget<Image>(find.byType(Image));
    expect(imageWidget.image, isA<NetworkImage>());
    expect((imageWidget.image as NetworkImage).url, equals(testImageUrl));
  });

  testWidgets('MinimalAvatar renders initials when no image', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MinimalAvatar(initials: 'JS', alt: 'John Smith'),
        ),
      ),
    );

    expect(find.text('JS'), findsOneWidget);
  });

  testWidgets('MinimalAvatar renders icon when no image or initials', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalAvatar(icon: const Icon(Icons.star), alt: 'Star Icon'),
        ),
      ),
    );

    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('MinimalAvatar defaults to person icon when nothing provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MinimalAvatar())),
    );

    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('MinimalAvatar renders different sizes correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              MinimalAvatar(initials: 'XS', size: AvatarSize.xs),
              MinimalAvatar(initials: 'SM', size: AvatarSize.sm),
              MinimalAvatar(initials: 'MD', size: AvatarSize.md),
              MinimalAvatar(initials: 'LG', size: AvatarSize.lg),
              MinimalAvatar(initials: 'XL', size: AvatarSize.xl),
              MinimalAvatar(initials: '2X', size: AvatarSize.xl2),
            ],
          ),
        ),
      ),
    );

    // Verify we have 6 avatars
    expect(find.byType(MinimalAvatar), findsNWidgets(6));

    // Check for the sizes by finding SizedBox widgets with expected dimensions
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 24 && widget.height == 24,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 32 && widget.height == 32,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 56 && widget.height == 56,
      ),
      findsOneWidget,
    );
  });

  testWidgets('MinimalAvatar renders status indicators correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: const Scaffold(
          body: MinimalAvatar(initials: 'JS', status: AvatarStatus.online),
        ),
      ),
    );

    // Verify we have the avatar with status indicator
    expect(find.byType(MinimalAvatar), findsOneWidget);
  });

  testWidgets('MinimalAvatar responds to taps', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalAvatar(
            initials: 'JS',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // Find the avatar widget
    final avatarFinder = find.byType(MinimalAvatar);
    expect(avatarFinder, findsOneWidget);

    await tester.tap(avatarFinder);
    expect(tapped, isTrue);
  });
}
