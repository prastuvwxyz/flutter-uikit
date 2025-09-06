import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../select/token_extensions.dart';

/// MinimalSearchBar - a lightweight search input with suggestions, recent searches and clear.
class MinimalSearchBar extends StatefulWidget {
  final String value;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onSuggestionSelected;
  final List<String>? suggestions;
  final List<String>? recentSearches;
  final String? placeholder;
  final bool showSuggestions;
  final bool showRecentSearches;
  final bool showClearButton;
  final Duration debounceTime;
  final int minQueryLength;
  final int maxSuggestions;
  final bool enabled;

  const MinimalSearchBar({
    super.key,
    this.value = '',
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionSelected,
    this.suggestions,
    this.recentSearches,
    this.placeholder,
    this.showSuggestions = true,
    this.showRecentSearches = true,
    this.showClearButton = true,
    this.debounceTime = const Duration(milliseconds: 300),
    this.minQueryLength = 1,
    this.maxSuggestions = 5,
    this.enabled = true,
  });

  @override
  State<MinimalSearchBar> createState() => _MinimalSearchBarState();
}

class _MinimalSearchBarState extends State<MinimalSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _keyboardFocusNode = FocusNode();
  Timer? _debounce;
  List<String> _filtered = [];
  int _highlighted = -1;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(MinimalSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
    _filterSuggestions(_controller.text);
  }

  void _handleFocus() {
    setState(() {});
  }

  void _onTextChanged(String v) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(widget.debounceTime, () {
      widget.onChanged?.call(v);
      _filterSuggestions(v);
    });
    setState(() {});
  }

  void _filterSuggestions(String query) {
    final lower = query.toLowerCase();
    if (!widget.showSuggestions || query.length < widget.minQueryLength) {
      setState(() => _filtered = []);
      return;
    }

    final src = widget.suggestions ?? [];
    final results = src.where((s) => s.toLowerCase().contains(lower)).toList();
    setState(() => _filtered = results.take(widget.maxSuggestions).toList());
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    _filterSuggestions('');
  }

  void _onSubmitted(String v) {
    widget.onSubmitted?.call(v);
    _focusNode.unfocus();
  }

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (_filtered.isEmpty) return;
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _highlighted = (_highlighted + 1) % _filtered.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _highlighted = (_highlighted - 1) < 0
              ? _filtered.length - 1
              : _highlighted - 1;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_highlighted >= 0 && _highlighted < _filtered.length) {
          final sel = _filtered[_highlighted];
          _controller.text = sel;
          widget.onSuggestionSelected?.call(sel);
          widget.onChanged?.call(sel);
          _filterSuggestions(sel);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        _focusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = MinimalColors.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RawKeyboardListener(
          focusNode: _keyboardFocusNode,
          onKey: _onKey,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
              border: Border.all(
                color: _focusNode.hasFocus ? colors.primary : colors.outline,
                width: 1,
              ),
              color: widget.enabled
                  ? colors.surface
                  : colors.surfaceContainerHighest,
            ),
            padding: EdgeInsets.symmetric(horizontal: tokens.spacingTokens.md),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.placeholder ?? 'Search...',
                      hintStyle: tokens.typographyTokens.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    style: tokens.typographyTokens.bodyMedium.copyWith(
                      color: colors.onSurface,
                    ),
                    onChanged: _onTextChanged,
                    onSubmitted: _onSubmitted,
                  ),
                ),
                if (widget.showClearButton && _controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                    onPressed: widget.enabled ? _clear : null,
                    splashRadius: 18,
                  ),
              ],
            ),
          ),
        ),
        if (_focusNode.hasFocus &&
            (widget.showSuggestions && _filtered.isNotEmpty))
          Container(
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final item = _filtered[index];
                  final highlighted = index == _highlighted;
                  return InkWell(
                    onTap: () {
                      _controller.text = item;
                      widget.onSuggestionSelected?.call(item);
                      widget.onChanged?.call(item);
                      _filterSuggestions(item);
                      _focusNode.unfocus();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.spacingTokens.md,
                        vertical: tokens.spacingTokens.sm,
                      ),
                      color: highlighted
                          ? colors.surfaceContainerHighest
                          : colors.surface,
                      child: Text(
                        item,
                        style: tokens.typographyTokens.bodyMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        else if (_focusNode.hasFocus &&
            widget.showRecentSearches &&
            (widget.recentSearches ?? []).isNotEmpty &&
            _controller.text.isEmpty)
          Container(
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (widget.recentSearches ?? []).map((r) {
                return InkWell(
                  onTap: () {
                    _controller.text = r;
                    widget.onSuggestionSelected?.call(r);
                    widget.onChanged?.call(r);
                    _focusNode.unfocus();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spacingTokens.md,
                      vertical: tokens.spacingTokens.sm,
                    ),
                    child: Text(
                      r,
                      style: tokens.typographyTokens.bodyMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
