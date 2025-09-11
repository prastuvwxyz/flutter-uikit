import 'package:flutter/material.dart';

class TooltipOverlay {
  static OverlayEntry show(BuildContext context, Widget child) {
    final overlay = OverlayEntry(builder: (_) => child);
    Overlay.of(context).insert(overlay);
    return overlay;
  }

  static void hide(OverlayEntry entry) {
    entry.remove();
  }
}
