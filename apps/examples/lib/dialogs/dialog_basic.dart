import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Basic dialog example showing title, content and action buttons
class DialogBasicExample extends StatelessWidget {
  /// Creates a basic dialog example
  const DialogBasicExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Dialog Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showBasicDialog(context);
          },
          child: const Text('Open Basic Dialog'),
        ),
      ),
    );
  }

  void _showBasicDialog(BuildContext context) {
    MinimalDialog.show(
      context: context,
      title: 'Information',
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'This is a basic dialog with standard title, content and actions. '
          'Dialogs inform users about a task and can contain critical information, '
          'require decisions, or involve multiple tasks.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
