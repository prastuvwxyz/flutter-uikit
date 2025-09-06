import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

import '../button/minimal_button.dart';

enum ButtonGroupSelectionMode { none, single, multiple }

class MinimalButtonGroup extends StatefulWidget {
  const MinimalButtonGroup({
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
  State<MinimalButtonGroup> createState() => _MinimalButtonGroupState();
}

class _MinimalButtonGroupState extends State<MinimalButtonGroup> {
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<int>.from(widget.selectedIndices);
  }

  @override
  void didUpdateWidget(covariant MinimalButtonGroup oldWidget) {
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

  List<Widget> _buildGroupedButtons(UiTokens tokens) {
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
          tokens: tokens,
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
    required UiTokens tokens,
  }) {
    final isSelected = _selected.contains(index);

    // Wrap provided child into a toggle that uses MinimalButton if possible
    Widget button;
    if (child is MinimalButton) {
      button = _MinimalToggleButton(
        child: child,
        isSelected: isSelected,
        isDisabled: widget.isDisabled || child.onPressed == null,
        onPressed: () => _handleButtonPressed(index),
        borderRadius: _getBorderRadius(isFirst, isLast),
      );
    } else {
      // If user passed arbitrary widget, wrap with InkWell
      button = _MinimalToggleButton(
        child: MinimalButton(onPressed: () {}, child: child),
        isSelected: isSelected,
        isDisabled: widget.isDisabled,
        onPressed: () => _handleButtonPressed(index),
        borderRadius: _getBorderRadius(isFirst, isLast),
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
    final theme = Theme.of(context);
    final tokens = theme.extension<UiTokens>() ?? UiTokens.standard();

    final content = widget.direction == Axis.horizontal
        ? Row(
            mainAxisAlignment: widget.alignment,
            mainAxisSize: MainAxisSize.min,
            children: _buildGroupedButtons(tokens),
          )
        : Column(
            mainAxisAlignment: widget.alignment,
            mainAxisSize: MainAxisSize.min,
            children: _buildGroupedButtons(tokens),
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

class _MinimalToggleButton extends StatelessWidget {
  const _MinimalToggleButton({
    required this.child,
    required this.onPressed,
    this.isSelected = false,
    this.isDisabled = false,
    this.borderRadius,
  });

  final MinimalButton child;
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isDisabled;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<UiTokens>() ?? UiTokens.standard();

    // Clone the child's properties but override selected/disabled visuals
    return ClipRRect(
      borderRadius:
          borderRadius ?? BorderRadius.circular(tokens.radiusTokens.md),
      child: MinimalButton(
        onPressed: isDisabled ? null : onPressed,
        child: child.child,
        leading: child.leading,
        trailing: child.trailing,
        variant: isSelected ? ButtonVariant.secondary : child.variant,
        size: child.size,
        isLoading: child.isLoading,
        fullWidth: child.fullWidth,
      ),
    );
  }
}
