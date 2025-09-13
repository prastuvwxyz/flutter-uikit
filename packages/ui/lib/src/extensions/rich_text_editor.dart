import 'package:flutter/material.dart';

/// A rich text editor widget with formatting capabilities
class RichTextEditor extends StatefulWidget {
  /// Initial HTML content
  final String? initialContent;

  /// Callback when content changes
  final Function(String html, String plainText)? onChanged;

  /// Whether the editor is read-only
  final bool readOnly;

  /// Custom toolbar configuration
  final RichTextToolbarConfig? toolbarConfig;

  /// Maximum number of lines
  final int? maxLines;

  /// Minimum number of lines
  final int minLines;

  /// Text style for the editor
  final TextStyle? textStyle;

  /// Decoration for the input field
  final InputDecoration? decoration;

  /// Focus node for the editor
  final FocusNode? focusNode;

  /// Auto focus the editor
  final bool autofocus;

  /// Placeholder text
  final String? placeholder;

  const RichTextEditor({
    super.key,
    this.initialContent,
    this.onChanged,
    this.readOnly = false,
    this.toolbarConfig,
    this.maxLines,
    this.minLines = 5,
    this.textStyle,
    this.decoration,
    this.focusNode,
    this.autofocus = false,
    this.placeholder,
  });

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final Set<RichTextFormat> _activeFormats = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent ?? '');
    _focusNode = widget.focusNode ?? FocusNode();

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    widget.onChanged?.call(_controller.text, _controller.text);
  }

  void _applyFormat(RichTextFormat format) {
    final selection = _controller.selection;
    if (!selection.isValid) return;

    setState(() {
      if (_activeFormats.contains(format)) {
        _activeFormats.remove(format);
      } else {
        _activeFormats.add(format);
      }
    });

    // Apply format to selected text (simplified implementation)
    final text = _controller.text;
    final selectedText = text.substring(selection.start, selection.end);

    String formattedText;
    switch (format) {
      case RichTextFormat.bold:
        formattedText = '**$selectedText**';
        break;
      case RichTextFormat.italic:
        formattedText = '*$selectedText*';
        break;
      case RichTextFormat.underline:
        formattedText = '<u>$selectedText</u>';
        break;
      case RichTextFormat.strikethrough:
        formattedText = '~~$selectedText~~';
        break;
      case RichTextFormat.code:
        formattedText = '`$selectedText`';
        break;
      default:
        formattedText = selectedText;
    }

    final newText = text.replaceRange(selection.start, selection.end, formattedText);
    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + formattedText.length),
    );
  }

  void _insertList(bool ordered) {
    final selection = _controller.selection;
    final text = _controller.text;

    final lines = text.split('\n');
    final lineIndex = text.substring(0, selection.start).split('\n').length - 1;

    String listItem;
    if (ordered) {
      listItem = '1. ';
    } else {
      listItem = '" ';
    }

    lines[lineIndex] = listItem + lines[lineIndex];
    final newText = lines.join('\n');

    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + listItem.length),
    );
  }

  void _insertLink() {
    final selection = _controller.selection;
    if (!selection.isValid) return;

    final text = _controller.text;
    final selectedText = text.substring(selection.start, selection.end);
    final linkText = selectedText.isEmpty ? 'Link Text' : selectedText;
    final formattedText = '[$linkText](https://example.com)';

    final newText = text.replaceRange(selection.start, selection.end, formattedText);
    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection(
        baseOffset: selection.start + 1,
        extentOffset: selection.start + linkText.length + 1,
      ),
    );
  }

  Widget _buildToolbar() {
    final config = widget.toolbarConfig ?? RichTextToolbarConfig.defaultConfig();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Wrap(
        children: [
          if (config.showBold)
            _ToolbarButton(
              icon: Icons.format_bold,
              isActive: _activeFormats.contains(RichTextFormat.bold),
              onPressed: () => _applyFormat(RichTextFormat.bold),
              tooltip: 'Bold',
            ),
          if (config.showItalic)
            _ToolbarButton(
              icon: Icons.format_italic,
              isActive: _activeFormats.contains(RichTextFormat.italic),
              onPressed: () => _applyFormat(RichTextFormat.italic),
              tooltip: 'Italic',
            ),
          if (config.showUnderline)
            _ToolbarButton(
              icon: Icons.format_underlined,
              isActive: _activeFormats.contains(RichTextFormat.underline),
              onPressed: () => _applyFormat(RichTextFormat.underline),
              tooltip: 'Underline',
            ),
          if (config.showStrikethrough)
            _ToolbarButton(
              icon: Icons.strikethrough_s,
              isActive: _activeFormats.contains(RichTextFormat.strikethrough),
              onPressed: () => _applyFormat(RichTextFormat.strikethrough),
              tooltip: 'Strikethrough',
            ),
          if (config.showCode)
            _ToolbarButton(
              icon: Icons.code,
              isActive: _activeFormats.contains(RichTextFormat.code),
              onPressed: () => _applyFormat(RichTextFormat.code),
              tooltip: 'Code',
            ),
          if (config.showBulletList)
            _ToolbarButton(
              icon: Icons.format_list_bulleted,
              onPressed: () => _insertList(false),
              tooltip: 'Bullet List',
            ),
          if (config.showNumberedList)
            _ToolbarButton(
              icon: Icons.format_list_numbered,
              onPressed: () => _insertList(true),
              tooltip: 'Numbered List',
            ),
          if (config.showLink)
            _ToolbarButton(
              icon: Icons.link,
              onPressed: _insertLink,
              tooltip: 'Insert Link',
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (widget.toolbarConfig?.enabled != false)
          _buildToolbar(),
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            style: widget.textStyle ?? theme.textTheme.bodyLarge,
            decoration: widget.decoration?.copyWith(
              hintText: widget.placeholder,
            ) ?? InputDecoration(
              hintText: widget.placeholder,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ),
        ),
      ],
    );
  }
}

/// Toolbar button widget
class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;
  final String? tooltip;

  const _ToolbarButton({
    required this.icon,
    required this.onPressed,
    this.isActive = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
      style: IconButton.styleFrom(
        backgroundColor: isActive ? theme.colorScheme.primary.withValues(alpha: 0.12) : null,
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Rich text formatting options
enum RichTextFormat {
  bold,
  italic,
  underline,
  strikethrough,
  code,
  heading1,
  heading2,
  heading3,
  bulletList,
  numberedList,
  link,
  quote,
}

/// Configuration for the rich text toolbar
class RichTextToolbarConfig {
  final bool enabled;
  final bool showBold;
  final bool showItalic;
  final bool showUnderline;
  final bool showStrikethrough;
  final bool showCode;
  final bool showBulletList;
  final bool showNumberedList;
  final bool showLink;
  final bool showHeadings;
  final bool showQuote;

  const RichTextToolbarConfig({
    this.enabled = true,
    this.showBold = true,
    this.showItalic = true,
    this.showUnderline = true,
    this.showStrikethrough = false,
    this.showCode = true,
    this.showBulletList = true,
    this.showNumberedList = true,
    this.showLink = true,
    this.showHeadings = false,
    this.showQuote = false,
  });

  static RichTextToolbarConfig defaultConfig() => const RichTextToolbarConfig();

  static RichTextToolbarConfig minimal() => const RichTextToolbarConfig(
    showBold: true,
    showItalic: true,
    showUnderline: false,
    showStrikethrough: false,
    showCode: false,
    showBulletList: false,
    showNumberedList: false,
    showLink: false,
    showHeadings: false,
    showQuote: false,
  );

  static RichTextToolbarConfig extended() => const RichTextToolbarConfig(
    showBold: true,
    showItalic: true,
    showUnderline: true,
    showStrikethrough: true,
    showCode: true,
    showBulletList: true,
    showNumberedList: true,
    showLink: true,
    showHeadings: true,
    showQuote: true,
  );
}

/// A markdown preview widget for rich text content
class MarkdownPreview extends StatelessWidget {
  final String content;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  const MarkdownPreview({
    super.key,
    required this.content,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: _buildMarkdownContent(context),
      ),
    );
  }

  Widget _buildMarkdownContent(BuildContext context) {
    final theme = Theme.of(context);
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8.0));
        continue;
      }

      // Handle different markdown elements (simplified)
      if (line.startsWith('# ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              line.substring(2),
              style: theme.textTheme.headlineLarge,
            ),
          ),
        );
      } else if (line.startsWith('## ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              line.substring(3),
              style: theme.textTheme.headlineMedium,
            ),
          ),
        );
      } else if (line.startsWith('" ') || line.startsWith('- ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('" '),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: textStyle ?? theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _parseInlineMarkdown(line, context),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _parseInlineMarkdown(String text, BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: text,
        style: textStyle ?? theme.textTheme.bodyLarge,
      ),
    );
  }
}

/// Extension for easy rich text editor creation
extension RichTextEditorExtension on Widget {
  /// Wrap with a rich text editor
  Widget withRichTextEditor({
    String? initialContent,
    Function(String html, String plainText)? onChanged,
    bool readOnly = false,
    RichTextToolbarConfig? toolbarConfig,
  }) {
    return Column(
      children: [
        this,
        Expanded(
          child: RichTextEditor(
            initialContent: initialContent,
            onChanged: onChanged,
            readOnly: readOnly,
            toolbarConfig: toolbarConfig,
          ),
        ),
      ],
    );
  }
}