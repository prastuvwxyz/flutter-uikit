import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example showing avatar status indicators
class AvatarStatusExample extends StatelessWidget {
  /// Creates an avatar status example
  const AvatarStatusExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Avatar Status Indicators',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusExample('Online', AvatarStatus.online),
              _buildStatusExample('Offline', AvatarStatus.offline),
              _buildStatusExample('Away', AvatarStatus.away),
              _buildStatusExample('Busy', AvatarStatus.busy),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Avatar with Badge',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MinimalAvatar(
                src: 'https://randomuser.me/api/portraits/men/32.jpg',
                size: AvatarSize.lg,
                badge: _buildBadge('3'),
              ),
              MinimalAvatar(
                initials: 'JD',
                size: AvatarSize.lg,
                badge: _buildBadge('7'),
              ),
              MinimalAvatar(
                icon: const Icon(Icons.person),
                size: AvatarSize.lg,
                badge: _buildBadge('!'),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Interactive Avatars',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MinimalAvatar(
                src: 'https://randomuser.me/api/portraits/women/65.jpg',
                size: AvatarSize.lg,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Avatar tapped')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusExample(String label, AvatarStatus status) {
    return Column(
      children: [
        MinimalAvatar(
          src:
              'https://randomuser.me/api/portraits/women/${(status.index + 1) * 22}.jpg',
          size: AvatarSize.lg,
          status: status,
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
