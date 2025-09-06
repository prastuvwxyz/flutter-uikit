import 'dart:async';

import 'package:flutter/material.dart';

typedef DisplayStringForOption<T> = String Function(T option);

/// A minimal, generic autocomplete widget that supports local filtering and
/// debounced async search via [onSearch]. It intentionally keeps behavior
/// predictable and small so it can be used inside the ui_components package.
class MinimalAutocomplete<T extends Object> extends StatefulWidget {
  final List<T> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<String>? onSearch;
  final DisplayStringForOption<T>? displayStringForOption;
  final AutocompleteFieldViewBuilder? fieldViewBuilder;
  final AutocompleteOptionsBuilder<T>? optionsBuilder;
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool loading;
  final int minSearchLength;
  final Duration debounceTime;

  const MinimalAutocomplete({
    super.key,
    this.options = const [],
    this.value,
    this.onChanged,
    this.onSearch,
    this.displayStringForOption,
    this.fieldViewBuilder,
    this.optionsBuilder,
    this.optionsViewBuilder,
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.loading = false,
    this.minSearchLength = 1,
    this.debounceTime = const Duration(milliseconds: 300),
  });

  @override
  State<MinimalAutocomplete<T>> createState() => _MinimalAutocompleteState<T>();
}

class _MinimalAutocompleteState<T extends Object>
    extends State<MinimalAutocomplete<T>> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null
          ? (widget.displayStringForOption?.call(widget.value as T) ??
                widget.value.toString())
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant MinimalAutocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value != null
          ? (widget.displayStringForOption?.call(widget.value as T) ??
                widget.value.toString())
          : '';
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchDebounced(String value) {
    if (widget.onSearch == null) return;
    if (value.length < widget.minSearchLength) return;
    _debounce?.cancel();
    _debounce = Timer(widget.debounceTime, () {
      if (mounted) widget.onSearch!(value);
    });
  }

  Iterable<T> _defaultOptionsBuilder(TextEditingValue textEditingValue) {
    final input = textEditingValue.text;
    // nothing

    if (input.isEmpty) return widget.options;

    final lower = input.toLowerCase();
    return widget.options.where((o) {
      final s = widget.displayStringForOption?.call(o) ?? o.toString();
      return s.toLowerCase().contains(lower);
    });
  }

  @override
  Widget build(BuildContext context) {
    final display = widget.displayStringForOption ?? (T o) => o.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
        ],
        RawAutocomplete<T>(
          textEditingController: _controller,
          focusNode: FocusNode(),
          optionsBuilder: (TextEditingValue textEditingValue) {
            // Call onSearch (debounced) for consumers who want async lookups.
            _onSearchDebounced(textEditingValue.text);

            if (widget.optionsBuilder != null) {
              try {
                return widget.optionsBuilder!(textEditingValue);
              } catch (_) {
                // fallback
              }
            }

            return _defaultOptionsBuilder(textEditingValue);
          },
          displayStringForOption: (T option) => display(option),
          fieldViewBuilder:
              widget.fieldViewBuilder ??
              (
                BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: widget.enabled,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    errorText: widget.errorText,
                    helperText: widget.helperText,
                    suffix: widget.loading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                  ),
                  onSubmitted: (_) => onFieldSubmitted(),
                );
              },
          optionsViewBuilder:
              widget.optionsViewBuilder ??
              (
                BuildContext context,
                AutocompleteOnSelected<T> onSelected,
                Iterable<T> options,
              ) {
                final list = options.toList();
                return Material(
                  elevation: 4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                      maxWidth: 360,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final option = list[index];
                        return InkWell(
                          onTap: () {
                            onSelected(option);
                            widget.onChanged?.call(option);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Text(display(option)),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
          onSelected: (T selection) {
            widget.onChanged?.call(selection);
          },
        ),
      ],
    );
  }
}
