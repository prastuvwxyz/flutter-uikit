import 'package:flutter/material.dart';

/// A customizable search bar widget with advanced features
class SearchBar extends StatefulWidget {
  /// Hint text to display when the search field is empty
  final String? hintText;

  /// Callback when the search query changes
  final Function(String query)? onChanged;

  /// Callback when search is submitted
  final Function(String query)? onSubmitted;

  /// Callback when a suggestion is selected
  final Function(String suggestion)? onSuggestionSelected;

  /// List of search suggestions
  final List<String> suggestions;

  /// Whether to show suggestions
  final bool showSuggestions;

  /// Whether to show the search history
  final bool showHistory;

  /// Search history items
  final List<String> history;

  /// Leading widget (typically a search icon)
  final Widget? leading;

  /// Trailing widgets (e.g., clear button, filters)
  final List<Widget> trailing;

  /// Text editing controller
  final TextEditingController? controller;

  /// Focus node
  final FocusNode? focusNode;

  /// Whether to auto focus
  final bool autofocus;

  /// Text style for the search input
  final TextStyle? textStyle;

  /// Decoration for the search bar
  final InputDecoration? decoration;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Elevation
  final double elevation;

  /// Padding around the search bar
  final EdgeInsets? padding;

  /// Maximum number of suggestions to show
  final int maxSuggestions;

  /// Debounce duration for search queries
  final Duration debounceDuration;

  /// Whether the search bar is enabled
  final bool enabled;

  const SearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionSelected,
    this.suggestions = const [],
    this.showSuggestions = true,
    this.showHistory = false,
    this.history = const [],
    this.leading,
    this.trailing = const [],
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.decoration,
    this.backgroundColor,
    this.borderRadius,
    this.elevation = 1.0,
    this.padding,
    this.maxSuggestions = 5,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.enabled = true,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _animation;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<String> _filteredSuggestions = [];
  List<String> _filteredHistory = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _hideOverlay();
    _animationController.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);

    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();

    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showSuggestionsOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _onTextChanged() {
    final query = _controller.text.toLowerCase();

    setState(() {
      _filteredSuggestions = widget.suggestions
          .where((suggestion) => suggestion.toLowerCase().contains(query))
          .take(widget.maxSuggestions)
          .toList();

      if (widget.showHistory) {
        _filteredHistory = widget.history
            .where((item) => item.toLowerCase().contains(query) && item != _controller.text)
            .take(3)
            .toList();
      }
    });

    if (_focusNode.hasFocus) {
      _updateOverlay();
    }

    widget.onChanged?.call(_controller.text);
  }

  void _showSuggestionsOverlay() {
    if (!widget.showSuggestions && !widget.showHistory) return;
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildSuggestionsOverlay(),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    _hideOverlay();
    widget.onSuggestionSelected?.call(suggestion);
  }

  Widget _buildSuggestionsOverlay() {
    return Positioned(
      width: context.size?.width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 8),
        child: Material(
          elevation: 4.0,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: _animation.value,
                  child: child,
                ),
              );
            },
            child: _buildSuggestionsList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    final allItems = <_SuggestionItem>[];

    if (widget.showHistory && _filteredHistory.isNotEmpty) {
      allItems.add(_SuggestionItem(
        text: 'Recent searches',
        isHeader: true,
      ));
      for (final item in _filteredHistory) {
        allItems.add(_SuggestionItem(
          text: item,
          icon: Icons.history,
          onTap: () => _selectSuggestion(item),
        ));
      }
    }

    if (widget.showSuggestions && _filteredSuggestions.isNotEmpty) {
      if (allItems.isNotEmpty) {
        allItems.add(_SuggestionItem(text: '', isDivider: true));
      }
      allItems.add(_SuggestionItem(
        text: 'Suggestions',
        isHeader: true,
      ));
      for (final suggestion in _filteredSuggestions) {
        allItems.add(_SuggestionItem(
          text: suggestion,
          icon: Icons.search,
          onTap: () => _selectSuggestion(suggestion),
        ));
      }
    }

    if (allItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        shrinkWrap: true,
        itemCount: allItems.length,
        itemBuilder: (context, index) {
          final item = allItems[index];

          if (item.isDivider) {
            return const Divider(height: 1);
          }

          if (item.isHeader) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
              child: Text(
                item.text,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListTile(
            dense: true,
            leading: item.icon != null ? Icon(item.icon, size: 20) : null,
            title: Text(item.text),
            onTap: item.onTap,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: widget.padding,
        child: Material(
          elevation: widget.elevation,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
          color: widget.backgroundColor ?? theme.colorScheme.surface,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            style: widget.textStyle,
            onSubmitted: widget.onSubmitted,
            decoration: (widget.decoration ?? InputDecoration(
              hintText: widget.hintText ?? 'Search...',
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            )).copyWith(
              prefixIcon: widget.leading ?? const Icon(Icons.search),
              suffixIcon: widget.trailing.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_controller.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              _focusNode.requestFocus();
                            },
                          ),
                        ...widget.trailing,
                      ],
                    )
                  : _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            _focusNode.requestFocus();
                          },
                        )
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper class for suggestion items
class _SuggestionItem {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isHeader;
  final bool isDivider;

  _SuggestionItem({
    required this.text,
    this.icon,
    this.onTap,
    this.isHeader = false,
    this.isDivider = false,
  });
}

/// A simplified search bar for basic use cases
class SimpleSearchBar extends StatefulWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final bool autofocus;
  final Widget? leading;
  final List<Widget> trailing;

  const SimpleSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.autofocus = false,
    this.leading,
    this.trailing = const [],
  });

  @override
  State<SimpleSearchBar> createState() => _SimpleSearchBarState();
}

class _SimpleSearchBarState extends State<SimpleSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      widget.onChanged?.call(_controller.text);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Search...',
        prefixIcon: widget.leading ?? const Icon(Icons.search),
        suffixIcon: widget.trailing.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _controller.clear(),
                    ),
                  ...widget.trailing,
                ],
              )
            : _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _controller.clear(),
                  )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

/// Pre-built search bar configurations
class SearchBarPresets {
  /// Basic search bar
  static SearchBar basic({
    String? hintText,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
  }) {
    return SearchBar(
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      showSuggestions: false,
      showHistory: false,
    );
  }

  /// Search bar with suggestions
  static SearchBar withSuggestions({
    String? hintText,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    Function(String)? onSuggestionSelected,
    List<String> suggestions = const [],
  }) {
    return SearchBar(
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onSuggestionSelected: onSuggestionSelected,
      suggestions: suggestions,
      showSuggestions: true,
      showHistory: false,
    );
  }

  /// Search bar with history
  static SearchBar withHistory({
    String? hintText,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    Function(String)? onSuggestionSelected,
    List<String> history = const [],
  }) {
    return SearchBar(
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onSuggestionSelected: onSuggestionSelected,
      history: history,
      showSuggestions: false,
      showHistory: true,
    );
  }

  /// Full-featured search bar
  static SearchBar advanced({
    String? hintText,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    Function(String)? onSuggestionSelected,
    List<String> suggestions = const [],
    List<String> history = const [],
  }) {
    return SearchBar(
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onSuggestionSelected: onSuggestionSelected,
      suggestions: suggestions,
      history: history,
      showSuggestions: true,
      showHistory: true,
    );
  }
}

/// Extension for easy search bar integration
extension SearchBarExtension on Widget {
  /// Wrap with a search bar header
  Widget withSearchBar({
    String? hintText,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    EdgeInsets? padding,
  }) {
    return Column(
      children: [
        Container(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: SimpleSearchBar(
            hintText: hintText,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
          ),
        ),
        Expanded(child: this),
      ],
    );
  }
}