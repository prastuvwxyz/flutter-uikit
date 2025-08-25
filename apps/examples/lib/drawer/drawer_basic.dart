import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Basic drawer example showing a simple implementation.
class DrawerBasicExample extends StatelessWidget {
  /// Creates a basic drawer example.
  const DrawerBasicExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a key to control the drawer
    final GlobalKey<MinimalDrawerState> drawerKey =
        GlobalKey<MinimalDrawerState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Drawer Example'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            drawerKey.currentState?.open();
          },
        ),
      ),
      body: MinimalDrawerController(
        drawerKey: drawerKey,
        child: Stack(
          children: [
            const Center(child: Text('Tap the menu icon to open the drawer')),
            MinimalDrawer(
              key: drawerKey,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Basic Drawer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text('This is a simple drawer with basic content.'),
                  SizedBox(height: 20),
                  Text('You can tap outside or press ESC to close it.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
