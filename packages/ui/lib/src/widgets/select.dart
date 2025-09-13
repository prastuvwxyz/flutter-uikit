import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../internal/token_adapters.dart';
import '../internal/a11y.dart';

/// Model class representing an option in a select dropdown
class SelectOption<T> {
  /// The label text displayed to the user
  final String label;

  /// The value associated with this option
  final T value;

  /// Optional description text
  final String? description;

  /// Optional leading icon or widget
  final Widget? leading;

  /// Optional trailing widget
  final Widget? trailing;

  /// Whether this option is disabled
  final bool disabled;

  /// Optional data for customizing the option appearance
  final Map<String, dynamic>? data;

  const SelectOption({
    required this.label,
    required this.value,
    this.description,
    this.leading,
    this.trailing,
    this.disabled = false,
    this.data,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectOption<T> &&
        other.value == value &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(label, value);
}

/// Size variants for select components
enum SelectSize {
  /// Small select (32px height)
  sm,
  /// Medium select (40px height, default)
  md,
  /// Large select (48px height)
  lg,
}

/// A customizable dropdown selection component with search, multi-select, and async data loading support
class Select<T> extends StatefulWidget {
  /// List of available options to display in the dropdown
  final List<SelectOption<T>> options;

  /// Currently selected value(s)
  final dynamic value;

  /// Callback when selection changes
  final ValueChanged<dynamic>? onChanged;

  /// Whether multiple values can be selected
  final bool multiple;

  /// Whether search functionality is enabled
  final bool searchable;

  /// Placeholder text when no value is selected
  final String placeholder;

  /// Label text displayed above the field
  final String? label;

  /// Helper text displayed below the field
  final String? helperText;

  /// Error message, when non-null shows error state
  final String? error;

  /// Whether the component is interactive
  final bool disabled;

  /// Whether the field is required
  final bool required;

  /// Shows loading indicator for async data
  final bool loading;

  /// Size variant of the select
  final SelectSize size;

  /// Custom height for the dropdown
  final double? dropdownHeight;

  /// Callback when search text changes, for async filtering
  final ValueChanged<String>? onSearch;

  /// Callback when dropdown opens
  final VoidCallback? onOpen;

  /// Callback when dropdown closes
  final VoidCallback? onClose;

  /// Whether to auto-focus the component
  final bool autofocus;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Custom decoration for the field
  final InputDecoration? decoration;

  /// Whether to show the clear button
  final bool showClearButton;

  const Select({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.multiple = false,
    this.searchable = false,
    this.placeholder = 'Select an option',
    this.label,
    this.helperText,
    this.error,
    this.disabled = false,
    this.required = false,
    this.loading = false,
    this.size = SelectSize.md,
    this.dropdownHeight,
    this.onSearch,
    this.onOpen,
    this.onClose,
    this.autofocus = false,
    this.semanticLabel,
    this.decoration,
    this.showClearButton = true,
  });

  /// Factory for single selection dropdown
  factory Select.single({
    Key? key,
    required List<SelectOption<T>> options,
    T? value,
    ValueChanged<T?>? onChanged,
    bool searchable = false,
    String placeholder = 'Select an option',
    String? label,
    String? helperText,
    String? error,
    bool disabled = false,
    bool required = false,
    bool loading = false,
    SelectSize size = SelectSize.md,
    double? dropdownHeight,
    ValueChanged<String>? onSearch,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    bool autofocus = false,
    String? semanticLabel,
    InputDecoration? decoration,
    bool showClearButton = true,
  }) {
    return Select<T>(
      key: key,
      options: options,
      value: value,
      onChanged: onChanged != null ? (value) => onChanged(value as T?) : null,
      multiple: false,
      searchable: searchable,
      placeholder: placeholder,
      label: label,
      helperText: helperText,
      error: error,
      disabled: disabled,
      required: required,
      loading: loading,
      size: size,
      dropdownHeight: dropdownHeight,
      onSearch: onSearch,
      onOpen: onOpen,
      onClose: onClose,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      decoration: decoration,
      showClearButton: showClearButton,
    );
  }

  /// Factory for multi-selection dropdown
  factory Select.multiple({
    Key? key,
    required List<SelectOption<T>> options,
    List<T>? value,
    ValueChanged<List<T>?>? onChanged,
    bool searchable = true,
    String placeholder = 'Select options',
    String? label,
    String? helperText,
    String? error,
    bool disabled = false,
    bool required = false,
    bool loading = false,
    SelectSize size = SelectSize.md,
    double? dropdownHeight,
    ValueChanged<String>? onSearch,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    bool autofocus = false,
    String? semanticLabel,
    InputDecoration? decoration,
    bool showClearButton = true,
  }) {
    return Select<T>(
      key: key,
      options: options,
      value: value,
      onChanged: onChanged != null ? (value) => onChanged(value as List<T>?) : null,
      multiple: true,
      searchable: searchable,
      placeholder: placeholder,
      label: label,
      helperText: helperText,
      error: error,
      disabled: disabled,
      required: required,
      loading: loading,
      size: size,
      dropdownHeight: dropdownHeight,
      onSearch: onSearch,
      onOpen: onOpen,
      onClose: onClose,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      decoration: decoration,
      showClearButton: showClearButton,
    );
  }

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isOpen = false;
  bool _isSearching = false;
  int _highlightedIndex = -1;
  List<SelectOption<T>> _filteredOptions = [];
  List<T> _selectedValues = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
    );

    _initializeValues();
    _filteredOptions = widget.options;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant Select<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _initializeValues();
    }

    if (oldWidget.options != widget.options) {
      _filteredOptions = widget.options;
      if (_isSearching && _searchController.text.isNotEmpty) {
        _filterOptions(_searchController.text);
      }
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeValues() {
    if (widget.value == null) {
      _selectedValues = [];
      return;
    }

    if (widget.multiple) {
      if (widget.value is List) {
        _selectedValues = List<T>.from(widget.value);
      } else {
        _selectedValues = [widget.value as T];
      }
    } else {
      _selectedValues = [widget.value as T];
    }
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _isOpen) {
      _closeDropdown();
    }
  }

  /// Get the height for the select field based on size
  double get _fieldHeight {
    switch (widget.size) {
      case SelectSize.sm:
        return 32.0;
      case SelectSize.md:
        return 40.0;
      case SelectSize.lg:
        return 48.0;
    }
  }

  /// Open the dropdown overlay
  void _openDropdown() {
    if (widget.disabled || _isOpen) return;

    setState(() {
      _isOpen = true;
      _highlightedIndex = -1;
    });

    _animationController.forward();
    _createOverlay();
    widget.onOpen?.call();
  }

  /// Close the dropdown overlay
  void _closeDropdown() {
    if (!_isOpen) return;

    _removeOverlay();
    _animationController.reverse();

    setState(() {
      _isOpen = false;
      _isSearching = false;
      _highlightedIndex = -1;
    });

    // Reset search if we were searching
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      _filteredOptions = widget.options;
    }

    widget.onClose?.call();
  }

  /// Toggle dropdown open/close state
  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  /// Filter options based on search text
  void _filterOptions(String searchText) {
    if (widget.onSearch != null) {
      widget.onSearch!(searchText);
      return;
    }

    setState(() {
      if (searchText.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options
            .where((option) => !option.disabled &&
                option.label.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      }
      _highlightedIndex = _filteredOptions.isNotEmpty ? 0 : -1;
      _updateOverlay();
    });
  }

  /// Select an option
  void _selectOption(SelectOption<T> option) {
    if (option.disabled) return;

    if (widget.multiple) {
      final isSelected = _selectedValues.contains(option.value);
      setState(() {
        if (isSelected) {
          _selectedValues.remove(option.value);
        } else {
          _selectedValues.add(option.value);
        }
      });

      widget.onChanged?.call(_selectedValues);

      // Keep dropdown open for multi-select, clear search
      if (widget.searchable) {
        _searchController.clear();
        _filteredOptions = widget.options;
        _updateOverlay();
        FocusScope.of(context).requestFocus(_focusNode);
      }
    } else {
      setState(() {
        _selectedValues = [option.value];
      });

      widget.onChanged?.call(option.value);
      _closeDropdown();
    }

    HapticFeedback.selectionClick();
  }

  /// Remove a selected value
  void _removeSelectedValue(T value) {
    setState(() {
      _selectedValues.remove(value);
    });

    if (widget.multiple) {
      widget.onChanged?.call(_selectedValues);
    } else {
      widget.onChanged?.call(null);
    }
  }

  /// Clear all selected values
  void _clearSelection() {
    setState(() {
      _selectedValues.clear();
    });

    if (widget.multiple) {
      widget.onChanged?.call(_selectedValues);
    } else {
      widget.onChanged?.call(null);
    }
  }

  /// Handle keyboard navigation
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (!_isOpen) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.space:
        case LogicalKeyboardKey.enter:
        case LogicalKeyboardKey.arrowDown:
          _openDropdown();
          return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    if (_filteredOptions.isEmpty) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        setState(() {
          _highlightedIndex = (_highlightedIndex + 1).clamp(0, _filteredOptions.length - 1);
          _scrollToHighlighted();
        });
        _updateOverlay();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowUp:
        setState(() {
          _highlightedIndex = (_highlightedIndex - 1).clamp(0, _filteredOptions.length - 1);
          _scrollToHighlighted();
        });
        _updateOverlay();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        if (_highlightedIndex >= 0 && _highlightedIndex < _filteredOptions.length) {
          _selectOption(_filteredOptions[_highlightedIndex]);
        }
        return KeyEventResult.handled;

      case LogicalKeyboardKey.escape:
        _closeDropdown();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.tab:
        _closeDropdown();
        return KeyEventResult.ignored; // Allow tab to continue navigation
    }

    return KeyEventResult.ignored;
  }

  /// Scroll to highlighted option
  void _scrollToHighlighted() {
    if (_highlightedIndex < 0 || !_scrollController.hasClients) return;

    const itemHeight = 48.0;
    final scrollPosition = _highlightedIndex * itemHeight;
    final viewportHeight = _scrollController.position.viewportDimension;

    if (scrollPosition < _scrollController.offset ||
        scrollPosition > _scrollController.offset + viewportHeight - itemHeight) {
      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Create overlay for dropdown
  void _createOverlay() {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildDropdownOverlay(size),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Remove overlay
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Update overlay
  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  /// Build dropdown overlay
  Widget _buildDropdownOverlay(Size fieldSize) {
    return Stack(
      children: [
        // Tap barrier
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeDropdown,
            child: Container(color: Colors.transparent),
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, fieldSize.height + context.spacing.xs),
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
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(
                8.0,
              ),
              color: Theme.of(context).colorScheme.surface,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: widget.dropdownHeight ?? 300,
                  minWidth: fieldSize.width,
                  maxWidth: fieldSize.width,
                ),
                child: _filteredOptions.isEmpty
                    ? _buildEmptyState()
                    : _buildOptionsList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(context.spacing.md),
      alignment: Alignment.center,
      child: Text(
        widget.loading ? 'Loading...' : 'No options available',
        style: TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.bodySmall,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Build options list
  Widget _buildOptionsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
      shrinkWrap: true,
      itemCount: _filteredOptions.length,
      itemBuilder: (context, index) {
        final option = _filteredOptions[index];
        final isSelected = _selectedValues.contains(option.value);
        final isHighlighted = index == _highlightedIndex;

        return _buildOptionItem(option, isSelected, isHighlighted);
      },
    );
  }

  /// Build individual option item
  Widget _buildOptionItem(
    SelectOption<T> option,
    bool isSelected,
    bool isHighlighted,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: option.disabled ? null : () => _selectOption(option),
      onHover: option.disabled ? null : (_) {
        setState(() {
          _highlightedIndex = _filteredOptions.indexOf(option);
        });
        _updateOverlay();
      },
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.md,
          vertical: context.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isHighlighted
              ? colorScheme.surfaceContainerHighest
              : Colors.transparent,
        ),
        child: Row(
          children: [
            if (option.leading != null) ...[
              option.leading!,
              SizedBox(width: context.spacing.sm),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: TokenAdapters.textStyleFromTokens(
                      tokenStyle: TokenTextStyle.bodyMedium,
                      color: option.disabled
                          ? colorScheme.onSurface.withValues(alpha: 0.38)
                          : colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (option.description != null) ...[
                    SizedBox(height: context.spacing.xs),
                    Text(
                      option.description!,
                      style: TokenAdapters.textStyleFromTokens(
                        tokenStyle: TokenTextStyle.bodySmall,
                        color: option.disabled
                            ? colorScheme.onSurfaceVariant.withValues(alpha: 0.38)
                            : colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (option.trailing != null) ...[
              SizedBox(width: context.spacing.sm),
              option.trailing!,
            ] else if (isSelected) ...[
              SizedBox(width: context.spacing.sm),
              Icon(
                Icons.check,
                size: 18,
                color: colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build search field when searchable and open
  Widget _buildSearchField() {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _searchController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.spacing.md,
          vertical: context.spacing.sm,
        ),
        hintText: 'Search...',
        hintStyle: TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.bodyMedium,
          color: colorScheme.onSurfaceVariant,
        ),
        suffixIcon: widget.loading
            ? Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.all(context.spacing.sm),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
            : Icon(
                Icons.search,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
      ),
      style: TokenAdapters.textStyleFromTokens(
        tokenStyle: TokenTextStyle.bodyMedium,
        color: colorScheme.onSurface,
      ),
      onChanged: (value) {
        setState(() {
          _isSearching = true;
        });
        _filterOptions(value);
      },
    );
  }

  /// Build selection field content
  Widget _buildSelectionField() {
    return Container(
      height: _fieldHeight,
      padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
      child: Row(
        children: [
          Expanded(
            child: _selectedValues.isEmpty
                ? _buildPlaceholder()
                : widget.multiple
                    ? _buildMultiSelectionChips()
                    : _buildSingleSelection(),
          ),
          if (_selectedValues.isNotEmpty && widget.showClearButton && !widget.disabled)
            _buildClearButton(),
          _buildTrailingIcon(),
        ],
      ),
    );
  }

  /// Build placeholder text
  Widget _buildPlaceholder() {
    return Text(
      widget.placeholder,
      style: TokenAdapters.textStyleFromTokens(
        tokenStyle: TokenTextStyle.bodyMedium,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build single selection display
  Widget _buildSingleSelection() {
    final selectedOption = widget.options.firstWhere(
      (option) => option.value == _selectedValues.first,
      orElse: () => SelectOption<T>(
        label: _selectedValues.first.toString(),
        value: _selectedValues.first,
      ),
    );

    return Row(
      children: [
        if (selectedOption.leading != null) ...[
          selectedOption.leading!,
          SizedBox(width: context.spacing.sm),
        ],
        Expanded(
          child: Text(
            selectedOption.label,
            style: TokenAdapters.textStyleFromTokens(
              tokenStyle: TokenTextStyle.bodyMedium,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Build multi-selection chips
  Widget _buildMultiSelectionChips() {
    return Wrap(
      spacing: context.spacing.xs,
      runSpacing: context.spacing.xs,
      children: _selectedValues.map((value) {
        final option = widget.options.firstWhere(
          (opt) => opt.value == value,
          orElse: () => SelectOption<T>(label: value.toString(), value: value),
        );

        return _buildSelectionChip(option);
      }).toList(),
    );
  }

  /// Build selection chip
  Widget _buildSelectionChip(SelectOption<T> option) {
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      label: Text(
        option.label,
        style: TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.labelSmall,
          color: colorScheme.onSurface,
        ),
      ),
      backgroundColor: colorScheme.surfaceContainerHighest,
      deleteIcon: Icon(
        Icons.close,
        size: 14,
        color: colorScheme.onSurfaceVariant,
      ),
      onDeleted: widget.disabled ? null : () => _removeSelectedValue(option.value),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  /// Build clear button
  Widget _buildClearButton() {
    return IconButton(
      icon: Icon(
        Icons.clear,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onPressed: _clearSelection,
      splashRadius: 12,
      constraints: const BoxConstraints(
        minWidth: 24,
        minHeight: 24,
      ),
      padding: EdgeInsets.zero,
    );
  }

  /// Build trailing icon
  Widget _buildTrailingIcon() {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.loading && !_isOpen) {
      return Container(
        width: 20,
        height: 20,
        margin: EdgeInsets.only(left: context.spacing.sm),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colorScheme.primary,
        ),
      );
    }

    return IconButton(
      icon: Icon(
        _isOpen ? Icons.expand_less : Icons.expand_more,
        size: 20,
        color: widget.disabled
            ? colorScheme.onSurface.withValues(alpha: 0.38)
            : colorScheme.onSurfaceVariant,
      ),
      onPressed: widget.disabled ? null : _toggleDropdown,
      splashRadius: 16,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
    );
  }

  /// Build label
  Widget? _buildLabel(BuildContext context) {
    if (widget.label == null) return null;

    return Row(
      children: [
        Text(
          widget.label!,
          style: TokenAdapters.textStyleFromTokens(
            tokenStyle: TokenTextStyle.labelMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (widget.required) ...[
          SizedBox(width: context.spacing.xs),
          Text(
            '*',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  /// Build error/helper text
  Widget? _buildHelperText(BuildContext context) {
    final text = widget.error ?? widget.helperText;
    if (text == null) return null;

    final isError = widget.error != null;

    return Text(
      text,
      style: TokenAdapters.textStyleFromTokens(
        tokenStyle: TokenTextStyle.bodySmall,
        color: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = widget.error != null;

    Widget selectField = CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.disabled ? null : _toggleDropdown,
        child: A11yFocusableWidget(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          semanticLabel: widget.semanticLabel ?? widget.label,
          onKey: (node, event) => _handleKeyEvent(event),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? colorScheme.error
                    : _isOpen
                        ? colorScheme.primary
                        : colorScheme.outline,
                width: hasError || _isOpen ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(
                8.0,
              ),
              color: widget.disabled
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.surface,
            ),
            child: widget.searchable && _isOpen
                ? _buildSearchField()
                : _buildSelectionField(),
          ),
        ),
      ),
    );

    // Add semantics
    selectField = Semantics(
      enabled: !widget.disabled,
      button: true,
      expanded: _isOpen,
      label: widget.semanticLabel ?? widget.label ?? 'Select dropdown',
      value: _selectedValues.isNotEmpty
          ? widget.multiple
              ? '${_selectedValues.length} items selected'
              : widget.options
                  .firstWhere(
                    (opt) => opt.value == _selectedValues.first,
                    orElse: () => SelectOption<T>(
                      label: _selectedValues.first.toString(),
                      value: _selectedValues.first,
                    ),
                  )
                  .label
          : null,
      onTap: widget.disabled ? null : _toggleDropdown,
      child: selectField,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_buildLabel(context) != null) ...[
          _buildLabel(context)!,
          SizedBox(height: context.spacing.sm),
        ],
        selectField,
        if (_buildHelperText(context) != null) ...[
          SizedBox(height: context.spacing.sm),
          _buildHelperText(context)!,
        ],
      ],
    );
  }
}