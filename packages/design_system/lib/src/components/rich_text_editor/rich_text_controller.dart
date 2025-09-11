import 'package:flutter/widgets.dart';

/// A minimal controller for rich text content.
class RichTextController extends TextEditingController {
  RichTextController({String? text}) : super(text: text);

  /// Apply a simple toggle for bold by wrapping selection with ** markers.
  void toggleBold() {
    final sel = selection;
    if (sel.isValid && sel.isCollapsed == false) {
      final selected = text.substring(sel.start, sel.end);
      final replaced = '**$selected**';
      value = value.replaced(
        TextRange(start: sel.start, end: sel.end),
        replaced,
      );
      selection = TextSelection.collapsed(offset: sel.start + replaced.length);
    }
  }
}
