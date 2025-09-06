import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'radio_option.dart';

enum RadioDirection { vertical, horizontal }

class MinimalRadioGroup<T> extends StatefulWidget {
  final List<RadioOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? description;
  final bool required;
  final String? error;
  final RadioDirection direction;
  final double? spacing;
  final bool disabled;

  const MinimalRadioGroup({
    Key? key,
    required this.options,
    this.value,
    this.onChanged,
    this.label,
    this.description,
    this.required = false,
    this.error,
    this.direction = RadioDirection.vertical,
    this.spacing,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<MinimalRadioGroup<T>> createState() => _MinimalRadioGroupState<T>();
}

class _MinimalRadioGroupState<T> extends State<MinimalRadioGroup<T>> {
  late FocusScopeNode _focusScope;

  @override
  void initState() {
    super.initState();
    _focusScope = FocusScopeNode();
  }

  @override
  void dispose() {
    _focusScope.dispose();
    super.dispose();
  }

  void _onKey(FocusNode node, RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;
    final keys = <LogicalKeyboardKey>{
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
    };
    if (!keys.contains(event.logicalKey)) return;

    final currentIndex = widget.options.indexWhere(
      (o) => o.value == widget.value,
    );
    if (currentIndex == -1 && widget.options.isNotEmpty) return;
    int next = currentIndex;
    final isHorizontal = widget.direction == RadioDirection.horizontal;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        (!isHorizontal && event.logicalKey == LogicalKeyboardKey.arrowRight)) {
      next = (currentIndex + 1) % widget.options.length;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        (!isHorizontal && event.logicalKey == LogicalKeyboardKey.arrowLeft)) {
      next = (currentIndex - 1) % widget.options.length;
      if (next < 0) next += widget.options.length;
    } else if (isHorizontal &&
        event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      next = (currentIndex - 1) % widget.options.length;
      if (next < 0) next += widget.options.length;
    } else if (isHorizontal &&
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      next = (currentIndex + 1) % widget.options.length;
    }

    final nextOption = widget.options[next];
    if (nextOption.disabled || widget.disabled) return;

    widget.onChanged?.call(nextOption.value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal = widget.direction == RadioDirection.horizontal;
    final spacing = widget.spacing ?? 8.0;

    final children = widget.options.map((opt) {
      final disabled = widget.disabled || opt.disabled;
      return InkWell(
        onTap: disabled
            ? null
            : () {
                widget.onChanged?.call(opt.value);
              },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<T>(
                value: opt.value,
                groupValue: widget.value,
                onChanged: disabled ? null : widget.onChanged,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opt.label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (opt.description != null) SizedBox(height: 4),
                    if (opt.description != null)
                      Text(
                        opt.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return FocusScope(
      node: _focusScope,
      onKey: (node, event) {
        _onKey(node, event);
        return KeyEventResult.handled;
      },
      child: Semantics(
        container: true,
        label: widget.label,
        explicitChildNodes: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Row(
                children: [
                  Text(
                    widget.label!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (widget.required) SizedBox(width: 6),
                  if (widget.required)
                    Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
            if (widget.description != null) SizedBox(height: 4),
            if (widget.description != null)
              Text(
                widget.description!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            SizedBox(height: 8),
            isHorizontal
                ? Row(
                    children: _withSpacing(
                      children,
                      spacing,
                      isHorizontal: true,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _withSpacing(
                      children,
                      spacing,
                      isHorizontal: false,
                    ),
                  ),
            if (widget.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _withSpacing(
    List<Widget> children,
    double spacing, {
    required bool isHorizontal,
  }) {
    if (children.isEmpty) return children;
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i != children.length - 1) {
        spaced.add(
          isHorizontal ? SizedBox(width: spacing) : SizedBox(height: spacing),
        );
      }
    }
    return spaced;
  }
}
