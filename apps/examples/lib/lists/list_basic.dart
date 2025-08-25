import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a basic [MinimalList] implementation.
class BasicListExample extends StatelessWidget {
  /// Creates a [BasicListExample] widget.
  const BasicListExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample list items
    final List<String> items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Basic List Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MinimalList<String>(
          items: items,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, item, index) {
            return ListTile(
              title: Text(item),
              subtitle: Text('This is item #${index + 1}'),
              leading: CircleAvatar(child: Text('${index + 1}')),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          onItemTap: (item, index) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Tapped on $item')));
          },
        ),
      ),
    );
  }
}
