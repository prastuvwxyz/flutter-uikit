import 'package:flutter/widgets.dart';

/// Available toolbar options for the minimal editor.
class RichTextToolbarOptions {
  final bool bold;
  final bool italic;
  final bool underline;

  const RichTextToolbarOptions({
    this.bold = true,
    this.italic = true,
    this.underline = true,
  });

  static const all = RichTextToolbarOptions();
}
