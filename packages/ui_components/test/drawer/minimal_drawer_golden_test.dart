import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/drawer/minimal_drawer.dart';
import 'package:ui_components/src/drawer/minimal_drawer_controller.dart';

void main() {
  final GlobalKey<MinimalDrawerState> drawerKey =
      GlobalKey<MinimalDrawerState>();

  // Helper function to build a navigation item
  Widget _buildNavItem(String title, IconData icon) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: () {});
  }

  Widget buildTestApp({bool withNavigationItems = false}) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: MinimalDrawerController(
          drawerKey: drawerKey,
          child: Stack(
            children: [
              const Center(child: Text('Main Content')),
              MinimalDrawer(
                key: drawerKey,
                child: withNavigationItems
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'Navigation',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildNavItem('Dashboard', Icons.dashboard),
                          _buildNavItem('Profile', Icons.person),
                          _buildNavItem('Settings', Icons.settings),
                          _buildNavItem('Help', Icons.help),
                          const Divider(),
                          _buildNavItem('Logout', Icons.exit_to_app),
                        ],
                      )
                    : const Center(child: Text('Drawer Content')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('MinimalDrawer Golden Tests', () {
    testWidgets('Drawer closed state golden test', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/drawer_closed.png'),
      );
    });

    testWidgets('Drawer open state golden test', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      drawerKey.currentState?.open();
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/drawer_open.png'),
      );
    });

    testWidgets('Drawer with navigation items golden test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestApp(withNavigationItems: true));
      drawerKey.currentState?.open();
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/drawer_with_navigation_items.png'),
      );
    });
  });
}
