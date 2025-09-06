import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        children: [
          const SizedBox(width: 8),
          Text('Dashboard', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(width: 12),
          Expanded(child: Container()),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(radius: 16, child: Text('A')),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
