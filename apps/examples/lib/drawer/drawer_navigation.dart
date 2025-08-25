import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Navigation drawer example showing menu items with icons.
class DrawerNavigationExample extends StatefulWidget {
  /// Creates a navigation drawer example.
  const DrawerNavigationExample({Key? key}) : super(key: key);

  @override
  State<DrawerNavigationExample> createState() =>
      _DrawerNavigationExampleState();
}

class _DrawerNavigationExampleState extends State<DrawerNavigationExample> {
  int _selectedIndex = 0;
  final GlobalKey<MinimalDrawerState> _drawerKey =
      GlobalKey<MinimalDrawerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Drawer Example'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _drawerKey.currentState?.open();
          },
        ),
      ),
      body: MinimalDrawerController(
        drawerKey: _drawerKey,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selected page: $_selectedIndex',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  const Text('Tap the menu icon to see the navigation drawer'),
                ],
              ),
            ),
            MinimalDrawer(
              key: _drawerKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Jane Doe',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          'jane.doe@example.com',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  _buildNavItem(0, 'Dashboard', Icons.dashboard),
                  _buildNavItem(1, 'Profile', Icons.person),
                  _buildNavItem(2, 'Settings', Icons.settings),
                  _buildNavItem(3, 'Help', Icons.help),
                  const Divider(),
                  _buildNavItem(4, 'Logout', Icons.exit_to_app),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: _selectedIndex == index ? Colors.blue : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.blue : Colors.black87,
          fontWeight: _selectedIndex == index
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _drawerKey.currentState?.close();
      },
    );
  }
}
