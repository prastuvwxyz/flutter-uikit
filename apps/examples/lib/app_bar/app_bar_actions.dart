import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example showcasing a MinimalAppBar with action buttons.
class AppBarWithActionsExample extends StatelessWidget {
  /// Creates a new [AppBarWithActionsExample].
  const AppBarWithActionsExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title and multiple action buttons
      appBar: MinimalAppBar(
        title: const Text('App Bar with Actions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Back button pressed')),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search button pressed')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter button pressed')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('More options button pressed')),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('App Bar with Actions Example')),
    );
  }
}

/// Entry point for the example
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppBarWithActionsExample(),
    ),
  );
}
