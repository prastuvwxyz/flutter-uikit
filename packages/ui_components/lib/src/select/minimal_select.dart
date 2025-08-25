import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'select_option.dart';
import 'token_extensions.dart';

/// A dropdown selection component with search, multi-select, and async data loading support.
///
/// This component follows the design specifications outlined in PRD:§2.1,
/// PRD:§4.2, and PRD:§6.2.
class MinimalSelect<T> extends StatefulWidget {
  /// List of available options to display in the dropdown
  final List<SelectOption<T>>? options;

  /// Currently selected value(s)
  final dynamic value;

  /// Callback when selection changes
  final ValueChanged<dynamic>? onChanged;

  /// Whether multiple values can be selected
  final bool multiple;

  /// Whether search functionality is enabled
  final bool searchable;

  /// Placeholder text when no value is selected
  final String? placeholder;

  /// Label text displayed above the field
  final String? label;

  /// Helper text displayed below the field
  final String? helperText;

  /// Error message, when non-null shows error state
  final String? errorText;

  /// Whether the component is interactive
  final bool enabled;

  /// Whether the field is required
  final bool required;

  /// Shows loading indicator for async data
  final bool loading;

  /// Callback when search text changes, for async filtering
  final ValueChanged<String>? onSearch;

  /// Callback when dropdown opens
  final VoidCallback? onOpen;

  /// Callback when dropdown closes
  final VoidCallback? onClose;

  /// Creates a MinimalSelect component
  const MinimalSelect({
    super.key,
    this.options,
    this.value,
    this.onChanged,
    this.multiple = false,
    this.searchable = false,
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.required = false,
    this.loading = false,
    this.onSearch,
    this.onOpen,
    this.onClose,
  });

  @override
  State<MinimalSelect<T>> createState() => _MinimalSelectState<T>();
}

class _MinimalSelectState<T> extends State<MinimalSelect<T>> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  bool _isOpen = false;
  bool _isSearching = false;
  int _highlightedIndex = -1;
  List<SelectOption<T>> _filteredOptions = [];
  List<T> _selectedValues = [];
  final ScrollController _scrollController = ScrollController();

  // For positioning and sizing the dropdown
  OverlayEntry? _overlayEntry;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _filteredOptions = widget.options ?? [];

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(MinimalSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _initializeValues();
    }
    if (oldWidget.options != widget.options) {
      _filteredOptions = widget.options ?? [];
      if (_isSearching && _searchController.text.isNotEmpty) {
        _filterOptions(_searchController.text);
      }
    }
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

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;

    setState(() {
      _isOpen = true;
      _highlightedIndex = -1;
    });

    _createOverlay();
    widget.onOpen?.call();
  }

  void _closeDropdown() {
    if (!_isOpen) return;

    _removeOverlay();

    setState(() {
      _isOpen = false;
      _isSearching = false;
      _highlightedIndex = -1;
    });

    // Reset search if we were searching
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      _filteredOptions = widget.options ?? [];
    }

    widget.onClose?.call();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _filterOptions(String searchText) {
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce!.cancel();
    }

    // Call async search callback if provided
    if (widget.onSearch != null) {
      _searchDebounce = Timer(const Duration(milliseconds: 300), () {
        widget.onSearch!.call(searchText);
      });
      return;
    }

    // Otherwise do local filtering
    setState(() {
      if (searchText.isEmpty) {
        _filteredOptions = widget.options ?? [];
      } else {
        _filteredOptions = (widget.options ?? [])
            .where(
              (option) =>
                  option.label.toLowerCase().contains(searchText.toLowerCase()),
            )
            .toList();
      }
      _highlightedIndex = _filteredOptions.isNotEmpty ? 0 : -1;
      _updateOverlay();
    });
  }

  void _selectOption(SelectOption<T> option) {
    if (widget.multiple) {
      final isSelected = _selectedValues.contains(option.value);
      setState(() {
        if (isSelected) {
          _selectedValues.remove(option.value);
        } else {
          _selectedValues.add(option.value);
        }
      });

      if (widget.onChanged != null) {
        widget.onChanged!(_selectedValues);
      }

      // Don't close the dropdown for multi-select
      if (widget.searchable) {
        _searchController.clear();
        _filteredOptions = widget.options ?? [];
        _updateOverlay();
        FocusScope.of(context).requestFocus(_focusNode);
      }
    } else {
      setState(() {
        _selectedValues = [option.value];
      });

      if (widget.onChanged != null) {
        widget.onChanged!(option.value);
      }

      _closeDropdown();
    }
  }

  void _removeSelectedValue(T value) {
    setState(() {
      _selectedValues.remove(value);
    });

    if (widget.onChanged != null) {
      if (widget.multiple) {
        widget.onChanged!(_selectedValues);
      } else {
        widget.onChanged!(null);
      }
    }
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (!_isOpen || _filteredOptions.isEmpty) return;

    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowDown:
          setState(() {
            _highlightedIndex = math.min(
              _highlightedIndex + 1,
              _filteredOptions.length - 1,
            );
            _scrollToHighlighted();
          });
          _updateOverlay();
          break;

        case LogicalKeyboardKey.arrowUp:
          setState(() {
            _highlightedIndex = math.max(_highlightedIndex - 1, 0);
            _scrollToHighlighted();
          });
          _updateOverlay();
          break;

        case LogicalKeyboardKey.enter:
        case LogicalKeyboardKey.space:
          if (_highlightedIndex >= 0 &&
              _highlightedIndex < _filteredOptions.length) {
            _selectOption(_filteredOptions[_highlightedIndex]);
          }
          break;

        case LogicalKeyboardKey.escape:
          _closeDropdown();
          break;

        case LogicalKeyboardKey.tab:
          _closeDropdown();
          break;

        default:
          break;
      }
    }
  }

  void _scrollToHighlighted() {
    if (_highlightedIndex < 0 || _scrollController.positions.isEmpty) return;

    const itemHeight = 48.0;
    final scrollPosition = _highlightedIndex * itemHeight;

    if (scrollPosition < _scrollController.offset ||
        scrollPosition >
            _scrollController.offset +
                _scrollController.position.viewportDimension -
                itemHeight) {
      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  void _createOverlay() {
    // Remove existing overlay if any
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildDropdownOverlay(size),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  Widget _buildDropdownOverlay(Size fieldSize) {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    return Stack(
      children: [
        // Invisible overlay for capturing taps outside dropdown
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
          offset: Offset(0, fieldSize.height + 4),
          child: Material(
            elevation: tokens.elevationTokens.level2,
            borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
            color: colors.surface,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 300,
                minWidth: fieldSize.width,
                maxWidth: fieldSize.width,
              ),
              child: _filteredOptions.isEmpty
                  ? _buildEmptyState()
                  : _buildOptionsList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    return Container(
      padding: EdgeInsets.all(tokens.spacingTokens.md),
      alignment: Alignment.center,
      child: Text(
        widget.loading ? 'Loading...' : 'No options available',
        style: tokens.typographyTokens.bodyMedium.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildOptionsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
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

  Widget _buildOptionItem(
    SelectOption<T> option,
    bool isSelected,
    bool isHighlighted,
  ) {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    return InkWell(
      onTap: () => _selectOption(option),
      onHover: (_) {
        setState(() {
          _highlightedIndex = _filteredOptions.indexOf(option);
        });
        _updateOverlay();
      },
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacingTokens.md,
          vertical: tokens.spacingTokens.sm,
        ),
        decoration: BoxDecoration(
          color: isHighlighted
              ? colors.surfaceContainerHighest
              : colors.surface,
        ),
        child: Row(
          children: [
            if (option.leading != null) ...[
              option.leading!,
              SizedBox(width: tokens.spacingTokens.sm),
            ],
            Expanded(
              child: Text(
                option.label,
                style: tokens.typographyTokens.bodyMedium.copyWith(
                  color: colors.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected) Icon(Icons.check, size: 18, color: colors.primary),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: tokens.typographyTokens.labelSmall.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              if (widget.required)
                Text(
                  ' *',
                  style: tokens.typographyTokens.labelSmall.copyWith(
                    color: colors.error,
                  ),
                ),
            ],
          ),
          SizedBox(height: tokens.spacingTokens.sm),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: widget.enabled ? _toggleDropdown : null,
            child: Focus(
              focusNode: _focusNode,
              onKeyEvent: (_, event) {
                if (event is KeyDownEvent) {
                  _handleKeyPress(event as RawKeyEvent);
                }
                return KeyEventResult.ignored;
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: hasError
                        ? colors.error
                        : _isOpen
                        ? colors.primary
                        : colors.outline,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
                  color: widget.enabled
                      ? colors.surface
                      : colors.surfaceContainerHighest,
                ),
                child: widget.searchable && _isOpen
                    ? _buildSearchField()
                    : _buildSelectionField(),
              ),
            ),
          ),
        ),
        if (hasError || widget.helperText != null) ...[
          SizedBox(height: tokens.spacingTokens.sm / 2),
          Text(
            hasError ? widget.errorText! : widget.helperText!,
            style: tokens.typographyTokens.labelSmall.copyWith(
              color: hasError ? colors.error : colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchField() {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    return TextField(
      controller: _searchController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.spacingTokens.md,
          vertical: tokens.spacingTokens.sm,
        ),
        hintText: 'Search...',
        hintStyle: tokens.typographyTokens.bodyMedium.copyWith(
          color: colors.onSurfaceVariant,
        ),
        suffixIcon: widget.loading
            ? SizedBox(
                width: 24,
                height: 24,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.primary,
                  ),
                ),
              )
            : Icon(Icons.search, size: 20, color: colors.onSurfaceVariant),
      ),
      style: tokens.typographyTokens.bodyMedium.copyWith(
        color: colors.onSurface,
      ),
      onChanged: (value) {
        setState(() {
          _isSearching = true;
        });
        _filterOptions(value);
      },
    );
  }

  Widget _buildSelectionField() {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacingTokens.md,
                vertical: tokens.spacingTokens.sm,
              ),
              child: _selectedValues.isEmpty
                  ? _buildPlaceholder()
                  : widget.multiple
                  ? _buildMultiSelectionChips()
                  : _buildSingleSelection(),
            ),
          ),
          _buildTrailingIcon(),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    return Text(
      widget.placeholder ?? 'Select an option',
      style: tokens.typographyTokens.bodyMedium.copyWith(
        color: colors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildSingleSelection() {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    // Find the option that matches the selected value
    final selectedOption = (widget.options ?? []).firstWhere(
      (option) => option.value == _selectedValues.first,
      orElse: () => SelectOption<T>(
        label: _selectedValues.first.toString(),
        value: _selectedValues.first,
      ),
    );

    return Text(
      selectedOption.label,
      style: tokens.typographyTokens.bodyMedium.copyWith(
        color: colors.onSurface,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMultiSelectionChips() {
    final tokens = context.tokens;

    return Wrap(
      spacing: tokens.spacingTokens.sm,
      runSpacing: tokens.spacingTokens.sm / 2,
      children: _selectedValues.map((value) {
        // Find the option that matches this value
        final option = (widget.options ?? []).firstWhere(
          (opt) => opt.value == value,
          orElse: () => SelectOption<T>(label: value.toString(), value: value),
        );

        return _buildSelectionChip(option);
      }).toList(),
    );
  }

  Widget _buildSelectionChip(SelectOption<T> option) {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    return Chip(
      label: Text(
        option.label,
        style: tokens.typographyTokens.labelSmall.copyWith(
          color: colors.onSurface,
        ),
      ),
      backgroundColor: colors.surfaceContainerHighest,
      deleteIcon: Icon(Icons.close, size: 16, color: colors.onSurfaceVariant),
      onDeleted: widget.enabled
          ? () => _removeSelectedValue(option.value)
          : null,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildTrailingIcon() {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    if (widget.loading) {
      return Padding(
        padding: EdgeInsets.only(right: tokens.spacingTokens.md),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colors.primary,
          ),
        ),
      );
    }

    return IconButton(
      icon: Icon(
        _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        size: 20,
        color: widget.enabled ? colors.onSurfaceVariant : colors.outline,
      ),
      onPressed: widget.enabled ? _toggleDropdown : null,
      splashRadius: 20,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }
}
