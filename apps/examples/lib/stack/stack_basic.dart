import 'package:flutter/material.dart';
import 'package:ui_components/src/stack/minimal_stack.dart';

class StackBasicExample extends StatelessWidget {
  const StackBasicExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: MinimalStack(
          spacing: 8.0,
          children: [
            Container(color: Colors.blue.withOpacity(0.2)),
            Align(
              alignment: Alignment.center,
              child: Container(width: 100, height: 100, color: Colors.red),
            ),
            const Positioned(top: 8, right: 8, child: Icon(Icons.star)),
          ],
        ),
      ),
    );
  }
}
