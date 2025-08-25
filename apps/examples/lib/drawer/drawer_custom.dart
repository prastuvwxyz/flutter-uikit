import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Custom drawer example showing customizations like width, shape, and colors.
class DrawerCustomExample extends StatelessWidget {
  /// Creates a custom drawer example.
  const DrawerCustomExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a key to control the drawer
    final GlobalKey<MinimalDrawerState> drawerKey =
        GlobalKey<MinimalDrawerState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Drawer Example'),
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
            const Center(
              child: Text('This example shows a custom styled drawer'),
            ),
            MinimalDrawer(
              key: drawerKey,
              width: 280.0, // Custom width
              backgroundColor: Colors.indigo[50], // Custom background color
              elevation: 8.0, // Custom elevation
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.palette, color: Colors.white, size: 30),
                        SizedBox(width: 16),
                        Text(
                          'Custom Drawer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customizable properties:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildCustomProperty('Width', '280.0'),
                        _buildCustomProperty('Background', 'indigo[50]'),
                        _buildCustomProperty('Elevation', '8.0'),
                        _buildCustomProperty('BorderRadius', '20.0'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomProperty(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
