import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a basic grid layout using MinimalGrid
class GridBasicExample extends StatelessWidget {
  /// Creates a basic grid example
  const GridBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Grid',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: MinimalGrid(
                  columns: 3,
                  spacing: 8,
                  children: [
                    _GridItem(color: Colors.red, label: '1'),
                    _GridItem(color: Colors.blue, label: '2'),
                    _GridItem(color: Colors.green, label: '3'),
                    _GridItem(color: Colors.amber, label: '4'),
                    _GridItem(color: Colors.purple, label: '5'),
                    _GridItem(color: Colors.teal, label: '6'),
                    _GridItem(color: Colors.brown, label: '7'),
                    _GridItem(color: Colors.orange, label: '8'),
                    _GridItem(color: Colors.indigo, label: '9'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  const _GridItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
