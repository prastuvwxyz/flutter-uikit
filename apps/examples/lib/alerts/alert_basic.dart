import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class AlertBasicExample extends StatelessWidget {
  const AlertBasicExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Alerts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Alert Types',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.success,
              title: 'Success',
              message: 'Your changes have been saved successfully.',
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.warning,
              title: 'Warning',
              message: 'Please review your information before continuing.',
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.error,
              title: 'Error',
              message: 'There was a problem processing your request.',
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.info,
              title: 'Information',
              message: 'The system will be under maintenance on Sunday.',
            ),
            const SizedBox(height: 32),
            const Text(
              'Without Title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.success,
              message: 'A simple success alert without title.',
            ),
            const SizedBox(height: 32),
            const Text(
              'Without Icon',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.error,
              title: 'No Icon',
              message: 'This alert has no icon.',
              showIcon: false,
            ),
            const SizedBox(height: 32),
            const Text(
              'Non-closable Alert',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.info,
              title: 'Important Notice',
              message: 'This alert cannot be dismissed.',
              closable: false,
            ),
          ],
        ),
      ),
    );
  }
}
