import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example demonstrating different tab variants (underline, pill, segmented).
class TabVariantsExample extends StatefulWidget {
  /// Creates a [TabVariantsExample] widget.
  const TabVariantsExample({super.key});

  @override
  State<TabVariantsExample> createState() => _TabVariantsExampleState();
}

class _TabVariantsExampleState extends State<TabVariantsExample> {
  int _underlineSelectedIndex = 0;
  int _pillSelectedIndex = 0;
  int _segmentedSelectedIndex = 0;

  final List<TabItem> _tabs = const [
    TabItem(label: 'Personal', icon: Icons.person),
    TabItem(label: 'Business', icon: Icons.business),
    TabItem(label: 'Settings', icon: Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tab Variants Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Underline Variant',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            MinimalTabs(
              tabs: _tabs,
              selectedIndex: _underlineSelectedIndex,
              variant: TabVariant.underline,
              onTabChanged: (index) {
                setState(() {
                  _underlineSelectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Pill Variant',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            MinimalTabs(
              tabs: _tabs,
              selectedIndex: _pillSelectedIndex,
              variant: TabVariant.pill,
              onTabChanged: (index) {
                setState(() {
                  _pillSelectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Segmented Variant',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            MinimalTabs(
              tabs: _tabs,
              selectedIndex: _segmentedSelectedIndex,
              variant: TabVariant.segmented,
              fullWidth: true,
              onTabChanged: (index) {
                setState(() {
                  _segmentedSelectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Size Variants',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            MinimalTabs(
              tabs: _tabs.sublist(0, 2),
              selectedIndex: 0,
              variant: TabVariant.underline,
              size: TabSize.sm,
            ),
            const SizedBox(height: 8),
            MinimalTabs(
              tabs: _tabs.sublist(0, 2),
              selectedIndex: 0,
              variant: TabVariant.underline,
              size: TabSize.md,
            ),
            const SizedBox(height: 8),
            MinimalTabs(
              tabs: _tabs.sublist(0, 2),
              selectedIndex: 0,
              variant: TabVariant.underline,
              size: TabSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}
