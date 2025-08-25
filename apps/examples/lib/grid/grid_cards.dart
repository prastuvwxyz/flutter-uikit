import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a grid layout with cards using MinimalGrid
class GridCardsExample extends StatelessWidget {
  /// Creates a grid cards example
  const GridCardsExample({super.key});

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
                'Card Grid',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: MinimalGrid(
                  minItemWidth: 250,
                  spacing: 16,
                  childAspectRatio: 4 / 3,
                  children: const [
                    _ProductCard(
                      title: 'Wireless Headphones',
                      price: '\$149.99',
                      imageUrl: 'https://picsum.photos/id/3/300/200',
                    ),
                    _ProductCard(
                      title: 'Smart Watch',
                      price: '\$299.99',
                      imageUrl: 'https://picsum.photos/id/26/300/200',
                    ),
                    _ProductCard(
                      title: 'Bluetooth Speaker',
                      price: '\$79.99',
                      imageUrl: 'https://picsum.photos/id/39/300/200',
                    ),
                    _ProductCard(
                      title: 'Smartphone',
                      price: '\$699.99',
                      imageUrl: 'https://picsum.photos/id/160/300/200',
                    ),
                    _ProductCard(
                      title: 'Laptop',
                      price: '\$1,299.99',
                      imageUrl: 'https://picsum.photos/id/119/300/200',
                    ),
                    _ProductCard(
                      title: 'Tablet',
                      price: '\$499.99',
                      imageUrl: 'https://picsum.photos/id/180/300/200',
                    ),
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  final String title;
  final String price;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return MinimalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                // Show a placeholder until image loads
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                // Show an error icon if image fails to load
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
