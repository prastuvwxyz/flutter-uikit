import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class AlertWithActionsExample extends StatelessWidget {
  const AlertWithActionsExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts With Actions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alert With Action Buttons',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MinimalAlert(
              type: AlertType.warning,
              title: 'Unsaved Changes',
              message: 'You have unsaved changes that will be lost.',
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Discarded changes')),
                    );
                  },
                  child: const Text('Discard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Changes saved')),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MinimalAlert(
              type: AlertType.error,
              title: 'Delete Confirmation',
              message:
                  'Are you sure you want to permanently delete this item? This action cannot be undone.',
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cancelled deletion')),
                    );
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item deleted')),
                    );
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MinimalAlert(
              type: AlertType.info,
              title: 'Update Available',
              message: 'A new version of the application is available.',
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Update later')),
                    );
                  },
                  child: const Text('Later'),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading update...')),
                    );
                  },
                  child: const Text('Learn More'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Updating now...')),
                    );
                  },
                  child: const Text('Update Now'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Alert With Single Action',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MinimalAlert(
              type: AlertType.success,
              title: 'Account Created',
              message: 'Your account has been created successfully.',
              actions: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigating to dashboard')),
                    );
                  },
                  child: const Text('Go to Dashboard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
