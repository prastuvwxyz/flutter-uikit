import 'package:flutter/material.dart';
import 'toolbar_options.dart';
import 'rich_text_controller.dart';

/// A minimal rich text editor with a basic toolbar and markdown-friendly controller.
class MinimalRichTextEditor extends StatefulWidget {
  final RichTextController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<TextSelection>? onSelectionChanged;
  final String? placeholder;
  final bool readOnly;
  final bool enabled;
  final double minHeight;
  final double? maxHeight;
  final bool showToolbar;
  final RichTextToolbarOptions toolbarOptions;
  final bool enableMarkdown;
  final bool autoFocus;
  final TextInputType keyboardType;

  const MinimalRichTextEditor({
    Key? key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSelectionChanged,
    this.placeholder,
    this.readOnly = false,
    this.enabled = true,
    this.minHeight = 120.0,
    this.maxHeight,
    this.showToolbar = true,
    this.toolbarOptions = RichTextToolbarOptions.all,
    this.enableMarkdown = true,
    this.autoFocus = false,
    this.keyboardType = TextInputType.multiline,
  }) : super(key: key);

  @override
  State<MinimalRichTextEditor> createState() => _MinimalRichTextEditorState();
}

class _MinimalRichTextEditorState extends State<MinimalRichTextEditor> {
  late final RichTextController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? RichTextController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    widget.onChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showToolbar) _buildToolbar(),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.minHeight,
            maxHeight: widget.maxHeight ?? double.infinity,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            autofocus: widget.autoFocus,
            keyboardType: widget.keyboardType,
            maxLines: null,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: widget.onChanged,
            onTap: () => widget.onSelectionChanged?.call(_controller.selection),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        if (widget.toolbarOptions.bold)
          IconButton(
            icon: const Icon(Icons.format_bold),
            onPressed: widget.readOnly
                ? null
                : () => setState(() => _controller.toggleBold()),
          ),
        if (widget.toolbarOptions.italic)
          IconButton(icon: const Icon(Icons.format_italic), onPressed: null),
        if (widget.toolbarOptions.underline)
          IconButton(icon: const Icon(Icons.format_underline), onPressed: null),
      ],
    );
  }
}
