import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  setUpAll(() {
    // This is needed for golden tests to work consistently across platforms
    debugDisableShadows = true;
  });

  testWidgets('MinimalAvatar renders photo correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: MinimalAvatar(
              src: 'https://randomuser.me/api/portraits/women/44.jpg',
              alt: 'Test Avatar',
              size: AvatarSize.lg,
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('golden/avatar/avatar_photo.png'),
    );
  });

  testWidgets('MinimalAvatar renders initials correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: MinimalAvatar(
              initials: 'JS',
              alt: 'John Smith',
              size: AvatarSize.lg,
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('golden/avatar/avatar_initials.png'),
    );
  });

  testWidgets('MinimalAvatar renders icon correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: MinimalAvatar(
              icon: const Icon(Icons.person),
              alt: 'Person',
              size: AvatarSize.lg,
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('golden/avatar/avatar_icon.png'),
    );
  });

  testWidgets('MinimalAvatar renders status indicators correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                MinimalAvatar(
                  initials: 'ON',
                  status: AvatarStatus.online,
                  size: AvatarSize.lg,
                ),
                MinimalAvatar(
                  initials: 'OF',
                  status: AvatarStatus.offline,
                  size: AvatarSize.lg,
                ),
                MinimalAvatar(
                  initials: 'AW',
                  status: AvatarStatus.away,
                  size: AvatarSize.lg,
                ),
                MinimalAvatar(
                  initials: 'BU',
                  status: AvatarStatus.busy,
                  size: AvatarSize.lg,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('golden/avatar/avatar_status_indicators.png'),
    );
  });

  testWidgets('MinimalAvatar renders different sizes correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
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
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('golden/avatar/avatar_sizes.png'),
    );
  });

  testWidgets('MinimalAvatar renders different shapes correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                MinimalAvatar(
                  initials: 'CI',
                  shape: AvatarShape.circle,
                  size: AvatarSize.lg,
                ),
                MinimalAvatar(
                  initials: 'SQ',
                  shape: AvatarShape.square,
                  size: AvatarSize.lg,
                ),
                MinimalAvatar(
                  initials: 'RO',
                  shape: AvatarShape.rounded,
                  size: AvatarSize.lg,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('golden/avatar/avatar_shapes.png'),
    );
  });
}
