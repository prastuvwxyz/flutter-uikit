import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Form dialog example demonstrating input fields in a dialog
class DialogFormExample extends StatefulWidget {
  /// Creates a form dialog example
  const DialogFormExample({Key? key}) : super(key: key);

  @override
  State<DialogFormExample> createState() => _DialogFormExampleState();
}

class _DialogFormExampleState extends State<DialogFormExample> {
  final List<Map<String, dynamic>> _savedData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Dialog Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _showFormDialog(context);
              },
              child: const Text('Add New Item'),
            ),
            const SizedBox(height: 24),
            Text('Saved Items', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: _savedData.isEmpty
                  ? const Center(
                      child: Text('No items added yet. Try adding one!'),
                    )
                  : ListView.builder(
                      itemCount: _savedData.length,
                      itemBuilder: (context, index) {
                        final item = _savedData[index];
                        return ListTile(
                          title: Text(item['title'] ?? ''),
                          subtitle: Text(item['description'] ?? ''),
                          leading: const Icon(Icons.description),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditFormDialog(context, index, item);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFormDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? category = 'Task';

    final categories = ['Task', 'Meeting', 'Note', 'Event'];
    bool isUrgent = false;

    final result = await MinimalDialog.show<Map<String, dynamic>>(
      context: context,
      title: 'Add New Item',
      scrollable: true,
      content: StatefulBuilder(
        builder: (context, setState) {
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: category,
                  items: categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      category = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isUrgent,
                      onChanged: (value) {
                        setState(() {
                          isUrgent = value ?? false;
                        });
                      },
                    ),
                    const Text('Mark as urgent'),
                  ],
                ),
              ],
            ),
          );
        },
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
            if (formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop({
                'title': titleController.text,
                'description': descriptionController.text,
                'category': category,
                'isUrgent': isUrgent,
              });
            }
          },
          child: const Text('Save'),
        ),
      ],
    );

    if (result != null) {
      setState(() {
        _savedData.add(result);
      });
    }
  }

  Future<void> _showEditFormDialog(
    BuildContext context,
    int index,
    Map<String, dynamic> existingData,
  ) async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: existingData['title']);
    final descriptionController = TextEditingController(
      text: existingData['description'],
    );
    String? category = existingData['category'] ?? 'Task';
    bool isUrgent = existingData['isUrgent'] ?? false;

    final categories = ['Task', 'Meeting', 'Note', 'Event'];

    final result = await MinimalDialog.show<Map<String, dynamic>>(
      context: context,
      title: 'Edit Item',
      scrollable: true,
      content: StatefulBuilder(
        builder: (context, setState) {
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: category,
                  items: categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      category = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isUrgent,
                      onChanged: (value) {
                        setState(() {
                          isUrgent = value ?? false;
                        });
                      },
                    ),
                    const Text('Mark as urgent'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Item'),
                content: const Text(
                  'Are you sure you want to delete this item?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop('delete');
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop({
                'title': titleController.text,
                'description': descriptionController.text,
                'category': category,
                'isUrgent': isUrgent,
              });
            }
          },
          child: const Text('Save'),
        ),
      ],
    );

    if (result != null) {
      setState(() {
        if (result == 'delete') {
          _savedData.removeAt(index);
        } else {
          _savedData[index] = result;
        }
      });
    }
  }
}
