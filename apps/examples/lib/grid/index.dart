import 'grid_basic.dart';
import 'grid_cards.dart';
import 'grid_responsive.dart';
import 'package:flutter/material.dart';

/// Grid examples index
class GridExamples extends StatelessWidget {
  /// Creates grid examples index
  const GridExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ExampleCard(
            title: 'Basic Grid',
            description: 'A basic grid layout with fixed columns',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GridBasicExample()),
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            title: 'Responsive Grid',
            description: 'A responsive grid that adapts to screen size',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GridResponsiveExample()),
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            title: 'Card Grid',
            description: 'A grid layout displaying cards',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GridCardsExample()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
