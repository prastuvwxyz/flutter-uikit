import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a virtualized [MinimalList] with large dataset.
class VirtualListExample extends StatefulWidget {
  /// Creates a [VirtualListExample] widget.
  const VirtualListExample({super.key});

  @override
  State<VirtualListExample> createState() => _VirtualListExampleState();
}

class _VirtualListExampleState extends State<VirtualListExample> {
  late List<Map<String, dynamic>> _items;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Generate 1000 items to demonstrate virtualization
    _generateItems();
  }

  void _generateItems() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _items = List.generate(1000, (index) {
            return {
              'id': index,
              'title': 'Item ${index + 1}',
              'description': 'Description for item ${index + 1}',
            };
          });
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Virtual List Example')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'This list contains 1,000 items rendered efficiently with virtualization',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: MinimalList<Map<String, dynamic>>(
              loading: _isLoading,
              items: _items,
              virtualized: true, // Enable virtualization (default)
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, item, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.primaries[index % Colors.primaries.length],
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                  ),
                );
              },
              onItemTap: (item, index) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on item ${index + 1}')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
