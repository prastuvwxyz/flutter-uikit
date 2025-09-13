import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ButtonGroupSelectionMode { none, single, multiple }

class ButtonGroup extends StatefulWidget {
  const ButtonGroup({
    super.key,
    required this.children,
    this.direction = Axis.horizontal,
    this.alignment = MainAxisAlignment.start,
    this.spacing = 0.0,
    this.selectionMode = ButtonGroupSelectionMode.none,
    this.selectedIndices = const <int>{},
    this.onSelectionChanged,
    this.isDisabled = false,
    this.borderRadius,
    this.elevation = 0.0,
  });

  final List<Widget> children;
  final Axis direction;
  final MainAxisAlignment alignment;
  final double spacing;
  final ButtonGroupSelectionMode selectionMode;
  final Set<int> selectedIndices;
  final ValueChanged<Set<int>>? onSelectionChanged;
  final bool isDisabled;
  final BorderRadius? borderRadius;
  final double elevation;

  @override
  State<ButtonGroup> createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<int>.from(widget.selectedIndices);
  }

  @override
  void didUpdateWidget(covariant ButtonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setEquals(oldWidget.selectedIndices, widget.selectedIndices)) {
      _selected = Set<int>.from(widget.selectedIndices);
    }
  }

  void _handleButtonPressed(int index) {
    if (widget.isDisabled || widget.onSelectionChanged == null) return;

    final newSelection = Set<int>.from(_selected);

    switch (widget.selectionMode) {
      case ButtonGroupSelectionMode.none:
        // no-op
        break;
      case ButtonGroupSelectionMode.single:
        if (newSelection.contains(index)) {
          newSelection.clear();
        } else {
          newSelection
            ..clear()
            ..add(index);
        }
        break;
      case ButtonGroupSelectionMode.multiple:
        if (newSelection.contains(index)) {
          newSelection.remove(index);
        } else {
          newSelection.add(index);
        }
        break;
    }

    setState(() {
      _selected = newSelection;
    });

    widget.onSelectionChanged?.call(newSelection);
  }

  BorderRadius _getBorderRadius(bool isFirst, bool isLast) {
    final radius = widget.borderRadius ?? BorderRadius.circular(8.0);

    if (widget.spacing > 0) return radius;

    if (widget.direction == Axis.horizontal) {
      if (isFirst && isLast) return radius;
      if (isFirst)
        return BorderRadius.only(
          topLeft: radius.topLeft,
          bottomLeft: radius.bottomLeft,
        );
      if (isLast)
        return BorderRadius.only(
          topRight: radius.topRight,
          bottomRight: radius.bottomRight,
        );
      return BorderRadius.zero;
    } else {
      if (isFirst && isLast) return radius;
      if (isFirst)
        return BorderRadius.only(
          topLeft: radius.topLeft,
          topRight: radius.topRight,
        );
      if (isLast)
        return BorderRadius.only(
          bottomLeft: radius.bottomLeft,
          bottomRight: radius.bottomRight,
        );
      return BorderRadius.zero;
    }
  }

  List<Widget> _buildGroupedButtons() {
    final grouped = <Widget>[];

    for (var i = 0; i < widget.children.length; i++) {
      final isFirst = i == 0;
      final isLast = i == widget.children.length - 1;
      final child = widget.children[i];

      grouped.add(
        _buildGroupedButton(
          child,
          index: i,
          isFirst: isFirst,
          isLast: isLast,
        ),
      );

      if (widget.spacing > 0 && !isLast) {
        grouped.add(
          SizedBox(
            width: widget.direction == Axis.horizontal ? widget.spacing : 0,
            height: widget.direction == Axis.vertical ? widget.spacing : 0,
          ),
        );
      }
    }

    return grouped;
  }

  Widget _buildGroupedButton(
    Widget child, {
    required int index,
    required bool isFirst,
    required bool isLast,
  }) {
    final isSelected = _selected.contains(index);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget button;
    if (child is ElevatedButton) {
      button = ElevatedButton(
        onPressed: widget.isDisabled
          ? null
          : () => _handleButtonPressed(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.surface,
          foregroundColor: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(isFirst, isLast),
          ),
        ),
        child: child.child ?? Container(),
      );
    } else if (child is TextButton) {
      button = TextButton(
        onPressed: widget.isDisabled
          ? null
          : () => _handleButtonPressed(index),
        style: TextButton.styleFrom(
          backgroundColor: isSelected
            ? colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
          foregroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(isFirst, isLast),
          ),
        ),
        child: child.child ?? Container(),
      );
    } else if (child is OutlinedButton) {
      button = OutlinedButton(
        onPressed: widget.isDisabled
          ? null
          : () => _handleButtonPressed(index),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected
            ? colorScheme.primary
            : Colors.transparent,
          foregroundColor: isSelected
            ? colorScheme.onPrimary
            : colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(isFirst, isLast),
          ),
        ),
        child: child.child ?? Container(),
      );
    } else {
      // Wrap arbitrary widget with InkWell
      button = InkWell(
        onTap: widget.isDisabled
          ? null
          : () => _handleButtonPressed(index),
        borderRadius: _getBorderRadius(isFirst, isLast),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
            borderRadius: _getBorderRadius(isFirst, isLast),
            border: Border.all(
              color: colorScheme.outline,
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: child,
        ),
      );
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      inMutuallyExclusiveGroup:
          widget.selectionMode == ButtonGroupSelectionMode.single,
      selected: isSelected,
      button: true,
      enabled: !widget.isDisabled,
      child: FocusScope(canRequestFocus: true, child: button),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.direction == Axis.horizontal
        ? Row(
            mainAxisAlignment: widget.alignment,
            mainAxisSize: MainAxisSize.min,
            children: _buildGroupedButtons(),
          )
        : Column(
            mainAxisAlignment: widget.alignment,
            mainAxisSize: MainAxisSize.min,
            children: _buildGroupedButtons(),
          );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Button group',
      child: Material(
        elevation: widget.elevation,
        color: Colors.transparent,
        child: content,
      ),
    );
  }
}