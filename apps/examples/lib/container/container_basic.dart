import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a basic container
class BasicContainerExample extends StatelessWidget {
  /// Constructor
  const BasicContainerExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Container')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple container with fixed size
            const MinimalContainer(
              width: 200,
              height: 100,
              backgroundColor: Colors.blue,
              child: Center(
                child: Text(
                  'Basic Container',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Container with padding and margin
            const MinimalContainer(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              backgroundColor: Colors.amber,
              child: Text('Container with padding and margin'),
            ),

            const SizedBox(height: 20),

            // Container with constraints
            MinimalContainer(
              constraints: const BoxConstraints(maxWidth: 300, minHeight: 50),
              backgroundColor: Colors.green[200],
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Container with constraints that limit its size',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
