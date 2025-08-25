import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class AlertVariantsExample extends StatelessWidget {
  const AlertVariantsExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alert Variants')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filled Alerts (Default)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.success,
              title: 'Success',
              message: 'This is a filled success alert.',
              variant: AlertVariant.filled,
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.error,
              title: 'Error',
              message: 'This is a filled error alert.',
              variant: AlertVariant.filled,
            ),
            const SizedBox(height: 32),
            const Text(
              'Outlined Alerts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.warning,
              title: 'Warning',
              message: 'This is an outlined warning alert.',
              variant: AlertVariant.outlined,
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.info,
              title: 'Information',
              message: 'This is an outlined info alert.',
              variant: AlertVariant.outlined,
            ),
            const SizedBox(height: 32),
            const Text(
              'Ghost Alerts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.success,
              title: 'Success',
              message: 'This is a ghost success alert.',
              variant: AlertVariant.ghost,
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.error,
              title: 'Error',
              message: 'This is a ghost error alert.',
              variant: AlertVariant.ghost,
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.warning,
              title: 'Warning',
              message: 'This is a ghost warning alert.',
              variant: AlertVariant.ghost,
            ),
            const SizedBox(height: 16),
            const MinimalAlert(
              type: AlertType.info,
              title: 'Information',
              message: 'This is a ghost info alert.',
              variant: AlertVariant.ghost,
            ),
          ],
        ),
      ),
    );
  }
}
