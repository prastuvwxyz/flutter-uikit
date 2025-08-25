import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example demonstrating basic usage of MinimalTabs component.
class BasicTabsExample extends StatefulWidget {
  /// Creates a [BasicTabsExample] widget.
  const BasicTabsExample({super.key});

  @override
  State<BasicTabsExample> createState() => _BasicTabsExampleState();
}

class _BasicTabsExampleState extends State<BasicTabsExample> {
  int _selectedTabIndex = 0;

  final List<TabItem> _tabs = const [
    TabItem(label: 'Overview'),
    TabItem(label: 'Analytics'),
    TabItem(label: 'Reports'),
    TabItem(label: 'Notifications', badgeCount: 3),
    TabItem(label: 'Settings'),
  ];

  final List<Widget> _tabContents = const [
    Center(child: Text('Overview Content')),
    Center(child: Text('Analytics Content')),
    Center(child: Text('Reports Content')),
    Center(child: Text('Notifications Content')),
    Center(child: Text('Settings Content')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Tabs Example')),
      body: Column(
        children: [
          MinimalTabs(
            tabs: _tabs,
            selectedIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
          const Divider(height: 1),
          Expanded(child: _tabContents[_selectedTabIndex]),
        ],
      ),
    );
  }
}
