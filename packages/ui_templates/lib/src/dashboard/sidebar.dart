import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  Widget _buildNavItem(IconData icon, String label, {bool selected = false}) {
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.blueAccent : null),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: () {},
      selected: selected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Minimal UI',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(Icons.dashboard, 'Dashboard', selected: true),
                _buildNavItem(Icons.bar_chart, 'Analytics'),
                _buildNavItem(Icons.shopping_bag, 'Ecommerce'),
                _buildNavItem(Icons.account_balance, 'Banking'),
                _buildNavItem(Icons.calendar_today, 'Calendar'),
                const Divider(),
                _buildNavItem(Icons.settings, 'Settings'),
                _buildNavItem(Icons.help_outline, 'Help'),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.person, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Admin',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
