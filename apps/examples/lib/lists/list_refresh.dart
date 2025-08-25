import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a [MinimalList] with pull-to-refresh functionality.
class RefreshListExample extends StatefulWidget {
  /// Creates a [RefreshListExample] widget.
  const RefreshListExample({super.key});

  @override
  State<RefreshListExample> createState() => _RefreshListExampleState();
}

class _RefreshListExampleState extends State<RefreshListExample> {
  late List<Map<String, dynamic>> _items;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _items = List.generate(20, (index) {
            return {
              'id': index,
              'title': 'Item ${index + 1}',
              'updated': DateTime.now().toString(),
            };
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        // Update the items with new timestamp
        _items = List.generate(20, (index) {
          return {
            'id': index,
            'title': 'Refreshed Item ${index + 1}',
            'updated': DateTime.now().toString(),
          };
        });
      });
    }
  }

  void _loadMore() {
    // Simulate loading more items
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final lastId = _items.isNotEmpty ? _items.last['id'] as int : -1;

        setState(() {
          _items.addAll(
            List.generate(10, (index) {
              final newIndex = lastId + 1 + index;
              return {
                'id': newIndex,
                'title': 'Item ${newIndex + 1}',
                'updated': DateTime.now().toString(),
              };
            }),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pull to Refresh Example')),
      body: MinimalList<Map<String, dynamic>>(
        loading: _isLoading,
        items: _hasError ? null : _items,
        error: _buildErrorWidget(),
        onRefresh: _onRefresh,
        onLoadMore: _loadMore,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, item, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Last updated: ${item['updated']}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            'Failed to load items',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadItems, child: const Text('Try Again')),
        ],
      ),
    );
  }
}
