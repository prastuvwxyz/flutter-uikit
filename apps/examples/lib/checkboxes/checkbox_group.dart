import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example showing a group of checkboxes with parent-child relationship
class CheckboxGroupExample extends StatefulWidget {
  /// Creates a CheckboxGroupExample widget
  const CheckboxGroupExample({Key? key}) : super(key: key);

  @override
  State<CheckboxGroupExample> createState() => _CheckboxGroupExampleState();
}

class _CheckboxGroupExampleState extends State<CheckboxGroupExample> {
  // Map to track selected items
  final Map<String, bool> _selections = {
    'notifications': false,
    'email': false,
    'push': false,
    'sms': false,
    'marketing': false,
    'newsletter': false,
    'productUpdates': false,
  };

  // Group memberships
  final Map<String, List<String>> _groups = {
    'notifications': ['email', 'push', 'sms'],
    'marketing': ['newsletter', 'productUpdates'],
  };

  bool? _getGroupValue(String groupName) {
    final children = _groups[groupName] ?? [];
    if (children.isEmpty) return false;

    // If all children are selected, return true
    final allSelected = children.every((child) => _selections[child] == true);
    if (allSelected) return true;

    // If some but not all children are selected, return null (indeterminate)
    final anySelected = children.any((child) => _selections[child] == true);
    if (anySelected) return null;

    // If none are selected, return false
    return false;
  }

  void _onGroupChanged(String groupName, bool? value) {
    final children = _groups[groupName] ?? [];

    setState(() {
      // Update all children with the same value
      for (final child in children) {
        _selections[child] = value == true;
      }

      // Also update the group itself
      _selections[groupName] = value == true;
    });
  }

  void _onItemChanged(String itemName, bool? value) {
    setState(() {
      _selections[itemName] = value == true;

      // Update parent group if necessary
      for (final entry in _groups.entries) {
        if (entry.value.contains(itemName)) {
          // Don't directly update the parent, it will be updated via _getGroupValue
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notifications group
          MinimalCheckbox(
            value: _getGroupValue('notifications'),
            onChanged: (value) => _onGroupChanged('notifications', value),
            label: 'Notifications',
            size: CheckboxSize.lg,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MinimalCheckbox(
                  value: _selections['email'],
                  onChanged: (value) => _onItemChanged('email', value),
                  label: 'Email notifications',
                ),
                MinimalCheckbox(
                  value: _selections['push'],
                  onChanged: (value) => _onItemChanged('push', value),
                  label: 'Push notifications',
                ),
                MinimalCheckbox(
                  value: _selections['sms'],
                  onChanged: (value) => _onItemChanged('sms', value),
                  label: 'SMS notifications',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Marketing group
          MinimalCheckbox(
            value: _getGroupValue('marketing'),
            onChanged: (value) => _onGroupChanged('marketing', value),
            label: 'Marketing',
            size: CheckboxSize.lg,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MinimalCheckbox(
                  value: _selections['newsletter'],
                  onChanged: (value) => _onItemChanged('newsletter', value),
                  label: 'Weekly newsletter',
                ),
                MinimalCheckbox(
                  value: _selections['productUpdates'],
                  onChanged: (value) => _onItemChanged('productUpdates', value),
                  label: 'Product updates',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
