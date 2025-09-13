import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../internal/token_adapters.dart';

/// Defines the display mode for autocomplete options
enum AutocompleteDisplayMode {
  /// Show options in a dropdown overlay
  dropdown,
  /// Show options inline below the input
  inline,
}

/// Custom option builder function type
typedef AutocompleteOptionBuilder<T> = Widget Function(
  BuildContext context,
  T option,
  bool isHighlighted,
  VoidCallback onSelect,
);

/// Custom string converter function type
typedef AutocompleteStringConverter<T> = String Function(T option);

/// A text input field with intelligent suggestion dropdown
class Autocomplete<T extends Object> extends StatefulWidget {
  /// List of available options
  final List<T> options;

  /// Function to convert option to display string
  final AutocompleteStringConverter<T>? displayStringForOption;

  /// Function to filter options based on query
  final List<T> Function(List<T> options, String query)? optionsFilter;

  /// Custom builder for option items
  final AutocompleteOptionBuilder<T>? optionBuilder;

  /// Callback when option is selected
  final ValueChanged<T>? onSelected;

  /// Initial value
  final T? initialValue;

  /// Text editing controller
  final TextEditingController? controller;

  /// Focus node for the text field
  final FocusNode? focusNode;

  /// Placeholder text
  final String? placeholder;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is required
  final bool required;

  /// Error text to display
  final String? errorText;

  /// Helper text to display
  final String? helperText;

  /// Leading icon for the text field
  final Widget? leadingIcon;

  /// Trailing icon for the text field
  final Widget? trailingIcon;

  /// Display mode for options
  final AutocompleteDisplayMode displayMode;

  /// Maximum number of options to show
  final int maxOptionsToShow;

  /// Minimum characters before showing suggestions
  final int minCharsForSuggestions;

  /// Debounce duration for filtering
  final Duration debounceDuration;

  /// Whether to show all options when field is focused with empty text
  final bool showAllOptionsOnFocus;

  /// Custom empty state widget
  final Widget? emptyBuilder;

  /// Custom loading widget
  final Widget? loadingBuilder;

  /// Whether options are being loaded asynchronously
  final bool isLoading;

  const Autocomplete({
    super.key,
    required this.options,
    this.displayStringForOption,
    this.optionsFilter,
    this.optionBuilder,
    this.onSelected,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.enabled = true,
    this.required = false,
    this.errorText,
    this.helperText,
    this.leadingIcon,
    this.trailingIcon,
    this.displayMode = AutocompleteDisplayMode.dropdown,
    this.maxOptionsToShow = 5,
    this.minCharsForSuggestions = 1,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.showAllOptionsOnFocus = false,
    this.emptyBuilder,
    this.loadingBuilder,
    this.isLoading = false,
  });

  /// Factory for simple string autocomplete
  static Autocomplete<String> string({
    Key? key,
    required List<String> options,
    List<String> Function(List<String> options, String query)? optionsFilter,
    ValueChanged<String>? onSelected,
    String? initialValue,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? placeholder,
    bool enabled = true,
    bool required = false,
    String? errorText,
    String? helperText,
    Widget? leadingIcon,
    Widget? trailingIcon,
    AutocompleteDisplayMode displayMode = AutocompleteDisplayMode.dropdown,
    int maxOptionsToShow = 5,
    int minCharsForSuggestions = 1,
    Duration debounceDuration = const Duration(milliseconds: 300),
    bool showAllOptionsOnFocus = false,
    Widget? emptyBuilder,
    Widget? loadingBuilder,
    bool isLoading = false,
  }) {
    return Autocomplete<String>(
      key: key,
      options: options,
      displayStringForOption: (option) => option,
      optionsFilter: optionsFilter,
      onSelected: onSelected,
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      placeholder: placeholder,
      enabled: enabled,
      required: required,
      errorText: errorText,
      helperText: helperText,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      displayMode: displayMode,
      maxOptionsToShow: maxOptionsToShow,
      minCharsForSuggestions: minCharsForSuggestions,
      debounceDuration: debounceDuration,
      showAllOptionsOnFocus: showAllOptionsOnFocus,
      emptyBuilder: emptyBuilder,
      loadingBuilder: loadingBuilder,
      isLoading: isLoading,
    );
  }

  @override
  State<Autocomplete<T>> createState() => _AutocompleteState<T>();
}

class _AutocompleteState<T extends Object> extends State<Autocomplete<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  List<T> _filteredOptions = [];
  int _highlightedIndex = -1;
  bool _showOptions = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.initialValue != null) {
      _controller.text = _displayStringForOption(widget.initialValue!);
    }

    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant Autocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.options != widget.options) {
      _updateFilteredOptions();
    }
  }

  @override
  void dispose() {
    _hideOptions();
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);

    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  String _displayStringForOption(T option) {
    return widget.displayStringForOption?.call(option) ?? option.toString();
  }

  List<T> _filterOptions(String query) {
    if (widget.optionsFilter != null) {
      return widget.optionsFilter!(widget.options, query);
    }

    if (query.isEmpty) {
      return widget.showAllOptionsOnFocus ? widget.options : [];
    }

    return widget.options.where((option) {
      final optionString = _displayStringForOption(option).toLowerCase();
      return optionString.contains(query.toLowerCase());
    }).toList();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      if (widget.showAllOptionsOnFocus || _controller.text.isNotEmpty) {
        _updateFilteredOptions();
        _showOptionsOverlay();
      }
    } else {
      _hideOptions();
    }
  }

  void _onTextChanged() {
    final query = _controller.text;

    if (query.length >= widget.minCharsForSuggestions ||
        (widget.showAllOptionsOnFocus && query.isEmpty)) {
      _updateFilteredOptions();
      _showOptionsOverlay();
    } else {
      _hideOptions();
    }

  }

  void _updateFilteredOptions() {
    setState(() {
      _filteredOptions = _filterOptions(_controller.text);
      _highlightedIndex = _filteredOptions.isNotEmpty ? 0 : -1;
    });
  }

  void _showOptionsOverlay() {
    if (!mounted || !widget.enabled) return;

    _hideOptions();

    if (_filteredOptions.isEmpty && !widget.isLoading) return;

    setState(() {
      _showOptions = true;
    });

    if (widget.displayMode == AutocompleteDisplayMode.dropdown) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOptions() {
    setState(() {
      _showOptions = false;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: context.borderRadius(all: TokenRadiusSize.md),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: context.borderRadius(all: TokenRadiusSize.md),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: _buildOptionsList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsList() {
    if (widget.isLoading) {
      return widget.loadingBuilder ??
        Container(
          height: 60,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
    }

    if (_filteredOptions.isEmpty) {
      return widget.emptyBuilder ??
        Container(
          height: 60,
          alignment: Alignment.center,
          child: Text(
            'No options found',
            style: TokenAdapters.textStyleFromTokens(
              tokenStyle: TokenTextStyle.bodyMedium,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        );
    }

    final optionsToShow = _filteredOptions.take(widget.maxOptionsToShow).toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: optionsToShow.length,
      itemBuilder: (context, index) {
        final option = optionsToShow[index];
        final isHighlighted = index == _highlightedIndex;

        if (widget.optionBuilder != null) {
          return widget.optionBuilder!(
            context,
            option,
            isHighlighted,
            () => _selectOption(option),
          );
        }

        return _buildDefaultOption(option, isHighlighted, index);
      },
    );
  }

  Widget _buildDefaultOption(T option, bool isHighlighted, int index) {
    return Material(
      color: isHighlighted
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
        : Colors.transparent,
      child: InkWell(
        onTap: () => _selectOption(option),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.md,
            vertical: context.spacing.sm,
          ),
          child: Text(
            _displayStringForOption(option),
            style: TokenAdapters.textStyleFromTokens(
              tokenStyle: TokenTextStyle.bodyMedium,
              color: isHighlighted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  void _selectOption(T option) {
    _controller.text = _displayStringForOption(option);
    _hideOptions();
    widget.onSelected?.call(option);

    // Trigger haptic feedback
    HapticFeedback.selectionClick();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (!_showOptions || _filteredOptions.isEmpty) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        setState(() {
          _highlightedIndex = (_highlightedIndex + 1) % _filteredOptions.length;
        });
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowUp:
        setState(() {
          _highlightedIndex = _highlightedIndex > 0
              ? _highlightedIndex - 1
              : _filteredOptions.length - 1;
        });
        return KeyEventResult.handled;

      case LogicalKeyboardKey.enter:
        if (_highlightedIndex >= 0 && _highlightedIndex < _filteredOptions.length) {
          _selectOption(_filteredOptions[_highlightedIndex]);
          return KeyEventResult.handled;
        }
        break;

      case LogicalKeyboardKey.escape:
        _hideOptions();
        return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget textField = CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        key: _fieldKey,
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          errorText: widget.errorText,
          helperText: widget.helperText,
          prefixIcon: widget.leadingIcon,
          suffixIcon: widget.trailingIcon,
          border: OutlineInputBorder(
            borderRadius: context.borderRadius(all: TokenRadiusSize.md),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: context.borderRadius(all: TokenRadiusSize.md),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.4),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: context.borderRadius(all: TokenRadiusSize.md),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: context.borderRadius(all: TokenRadiusSize.md),
            borderSide: BorderSide(
              color: colorScheme.error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: context.borderRadius(all: TokenRadiusSize.md),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.spacing.md,
            vertical: context.spacing.sm,
          ),
        ),
      ),
    );

    // Add keyboard handling
    textField = KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKeyEvent,
      child: textField,
    );

    // Add semantics
    textField = Semantics(
      textField: true,
      enabled: widget.enabled,
      child: textField,
    );

    // Show inline options if display mode is inline
    if (widget.displayMode == AutocompleteDisplayMode.inline && _showOptions) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          textField,
          SizedBox(height: context.spacing.xs),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: context.borderRadius(all: TokenRadiusSize.md),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: _buildOptionsList(),
          ),
        ],
      );
    }

    return textField;
  }
}