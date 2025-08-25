import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a responsive grid layout using MinimalGrid
class GridResponsiveExample extends StatelessWidget {
  /// Creates a responsive grid example
  const GridResponsiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Responsive Grid',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Resize window to see the grid adapt',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: MinimalGrid(
                  minItemWidth: 150,
                  spacing: 16,
                  childAspectRatio: 1.5,
                  breakpoints: const GridBreakpoints(
                    mobile: 1,
                    tablet: 3,
                    desktop: 5,
                  ),
                  children: List.generate(
                    12,
                    (index) => _ResponsiveGridItem(index: index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResponsiveGridItem extends StatelessWidget {
  const _ResponsiveGridItem({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue.shade300,
      Colors.purple.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.red.shade300,
      Colors.teal.shade300,
    ];

    final color = colors[index % colors.length];

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Item ${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
