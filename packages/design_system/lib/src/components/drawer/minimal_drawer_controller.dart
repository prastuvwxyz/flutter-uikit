import 'package:flutter/material.dart';
import 'minimal_drawer.dart';

/// A controller for a [MinimalDrawer] that allows opening and closing
/// the drawer from other widgets.
class MinimalDrawerController extends StatefulWidget {
  /// The key that identifies the drawer that this controller is controlling.
  final GlobalKey<MinimalDrawerState> drawerKey;

  /// The child widget below this widget in the tree.
  final Widget child;

  /// Creates a controller for a [MinimalDrawer].
  ///
  /// The [child] and [drawerKey] arguments are required.
  const MinimalDrawerController({
    Key? key,
    required this.drawerKey,
    required this.child,
  }) : super(key: key);

  /// Opens the drawer.
  static void open(BuildContext context) {
    final controller = _getControllerOf(context);
    controller?._open();
  }

  /// Closes the drawer.
  static void close(BuildContext context) {
    final controller = _getControllerOf(context);
    controller?._close();
  }

  /// Toggles the drawer between open and closed.
  static void toggle(BuildContext context) {
    final controller = _getControllerOf(context);
    controller?._toggle();
  }

  static _MinimalDrawerControllerState? _getControllerOf(BuildContext context) {
    final state = context
        .findAncestorStateOfType<_MinimalDrawerControllerState>();
    return state;
  }

  @override
  _MinimalDrawerControllerState createState() =>
      _MinimalDrawerControllerState();
}

class _MinimalDrawerControllerState extends State<MinimalDrawerController> {
  void _open() {
    widget.drawerKey.currentState?.open();
  }

  void _close() {
    widget.drawerKey.currentState?.close();
  }

  void _toggle() {
    final drawerState = widget.drawerKey.currentState;
    if (drawerState?.controller.status == AnimationStatus.dismissed) {
      drawerState?.open();
    } else {
      drawerState?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
