import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example showing different avatar sizes
class AvatarSizesExample extends StatelessWidget {
  /// Creates an avatar sizes example
  const AvatarSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Avatar Size Variants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSizeColumn('XS', AvatarSize.xs),
              _buildSizeColumn('SM', AvatarSize.sm),
              _buildSizeColumn('MD', AvatarSize.md),
              _buildSizeColumn('LG', AvatarSize.lg),
              _buildSizeColumn('XL', AvatarSize.xl),
              _buildSizeColumn('2XL', AvatarSize.xl2),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Avatar Shape Variants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShapeExample('Circle', AvatarShape.circle),
              _buildShapeExample('Square', AvatarShape.square),
              _buildShapeExample('Rounded', AvatarShape.rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeColumn(String label, AvatarSize size) {
    return Column(
      children: [
        MinimalAvatar(
          src:
              'https://randomuser.me/api/portraits/men/${(size.index + 1) * 10}.jpg',
          size: size,
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildShapeExample(String label, AvatarShape shape) {
    return Column(
      children: [
        MinimalAvatar(
          src: 'https://randomuser.me/api/portraits/women/43.jpg',
          size: AvatarSize.lg,
          shape: shape,
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
