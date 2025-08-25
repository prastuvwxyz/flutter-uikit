import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Confirmation dialog example for validating user actions
class DialogConfirmExample extends StatelessWidget {
  /// Creates a confirmation dialog example
  const DialogConfirmExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmation Dialog Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showDeleteConfirmation(context);
              },
              child: const Text('Delete Item'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showDiscardChanges(context);
              },
              child: const Text('Discard Changes'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showCustomConfirmation(context);
              },
              child: const Text('Custom Confirmation'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final result = await MinimalDialog.show<bool>(
      context: context,
      title: 'Delete Item',
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'Are you sure you want to delete this item? '
          'This action cannot be undone.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Delete'),
        ),
      ],
    );

    if (result == true) {
      // Handle delete action
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item deleted')));
    }
  }

  Future<void> _showDiscardChanges(BuildContext context) async {
    final result = await MinimalDialog.show<bool>(
      context: context,
      title: 'Discard Changes',
      size: DialogSize.sm,
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Keep Editing'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Discard'),
        ),
      ],
    );

    if (result == true) {
      // Handle discard action
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Changes discarded')));
    }
  }

  Future<void> _showCustomConfirmation(BuildContext context) async {
    final result = await MinimalDialog.show<String>(
      context: context,
      title: 'Choose Action',
      icon: const Icon(Icons.help_outline, color: Colors.blue),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text('Please select one of the following actions to proceed:'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop('cancel');
          },
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop('save');
          },
          child: const Text('Save Draft'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop('publish');
          },
          child: const Text('Publish'),
        ),
      ],
    );

    if (result != null && result != 'cancel') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Action selected: $result')));
    }
  }
}
