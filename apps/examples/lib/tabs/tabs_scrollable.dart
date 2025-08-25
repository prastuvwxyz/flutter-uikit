import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example demonstrating scrollable tabs with many options.
class ScrollableTabsExample extends StatefulWidget {
  /// Creates a [ScrollableTabsExample] widget.
  const ScrollableTabsExample({super.key});

  @override
  State<ScrollableTabsExample> createState() => _ScrollableTabsExampleState();
}

class _ScrollableTabsExampleState extends State<ScrollableTabsExample> {
  int _selectedTabIndex = 0;

  final List<TabItem> _tabs = const [
    TabItem(label: 'Dashboard', icon: Icons.dashboard),
    TabItem(label: 'Analytics', icon: Icons.analytics),
    TabItem(label: 'Reports', icon: Icons.description),
    TabItem(label: 'Calendar', icon: Icons.calendar_today),
    TabItem(label: 'Messages', icon: Icons.message, badgeCount: 5),
    TabItem(label: 'Notifications', icon: Icons.notifications, badgeCount: 2),
    TabItem(label: 'Settings', icon: Icons.settings),
    TabItem(label: 'Profile', icon: Icons.person),
    TabItem(label: 'Help', icon: Icons.help),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scrollable Tabs Example')),
      body: Column(
        children: [
          MinimalTabs(
            tabs: _tabs,
            selectedIndex: _selectedTabIndex,
            scrollable: true,
            variant: TabVariant.pill,
            onTabChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: Center(
              child: Text(
                'Selected tab: ${_tabs[_selectedTabIndex].label}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
