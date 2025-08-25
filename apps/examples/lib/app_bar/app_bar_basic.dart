import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example showcasing a basic MinimalAppBar.
class BasicAppBarExample extends StatelessWidget {
  /// Creates a new [BasicAppBarExample].
  const BasicAppBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Simple app bar with a title
      appBar: MinimalAppBar(
        title: const Text('Basic App Bar'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menu button pressed')),
            );
          },
        ),
      ),
      body: const Center(child: Text('Basic App Bar Example')),
    );
  }
}

/// Entry point for the example
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BasicAppBarExample(),
    ),
  );
}
