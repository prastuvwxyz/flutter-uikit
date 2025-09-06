import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart' as uic;

class MenuBasicExample extends StatelessWidget {
  const MenuBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = uic.MenuController();

    return Scaffold(
      appBar: AppBar(title: const Text('MinimalMenu Basic')),
      body: Center(
        child: uic.MinimalMenu(
          menuController: controller,
          anchorChildBuilder: (ctx, ctrl, _) {
            return ElevatedButton(
              onPressed: ctrl.toggle,
              child: const Text('Open menu'),
            );
          },
          children: [
            uic.MenuItem(
              title: const Text('First item'),
              onTap: () {
                controller.close();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('First')));
              },
            ),
            uic.MenuItem(
              title: const Text('Second item'),
              onTap: () {
                controller.close();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Second')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
