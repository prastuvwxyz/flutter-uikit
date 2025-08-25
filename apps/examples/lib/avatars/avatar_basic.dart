import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of basic avatar usage
class AvatarBasicExample extends StatelessWidget {
  /// Creates a basic avatar example
  const AvatarBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Avatar Examples',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Image avatar
              const MinimalAvatar(
                src: 'https://randomuser.me/api/portraits/women/44.jpg',
                alt: 'Jane Smith profile picture',
              ),
              const SizedBox(width: 16),

              // Initials avatar
              const MinimalAvatar(initials: 'JS', alt: 'Jane Smith initials'),
              const SizedBox(width: 16),

              // Icon avatar
              MinimalAvatar(
                icon: const Icon(Icons.person),
                alt: 'Default user icon',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
