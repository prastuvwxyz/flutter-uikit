import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// MinimalSwitch: simple, accessible switch with label, description, sizes and theming.
class MinimalSwitch extends StatefulWidget {
  const MinimalSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.label,
    this.description,
    this.size = SwitchSize.md,
    this.labelPosition = SwitchLabelPosition.right,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;
  final SwitchSize size;
  final SwitchLabelPosition labelPosition;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;

  @override
  State<MinimalSwitch> createState() => _MinimalSwitchState();
}

enum SwitchSize { sm, md, lg }

enum SwitchLabelPosition { left, right, top, bottom }

class _MinimalSwitchState extends State<MinimalSwitch>
    with SingleTickerProviderStateMixin {
  late bool _value;
  late AnimationController _animController;
  late Animation<double> _thumbAnimation;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: _value ? 1.0 : 0.0,
    );
    _thumbAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant MinimalSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
      if (_value) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    if (widget.onChanged == null) return;
    final newValue = !_value;
    widget.onChanged?.call(newValue);
    setState(() => _value = newValue);
    if (_value) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  double _widthForSize() {
    switch (widget.size) {
      case SwitchSize.sm:
        return 36;
      case SwitchSize.md:
        return 44;
      case SwitchSize.lg:
        return 56;
    }
  }

  double _heightForSize() {
    switch (widget.size) {
      case SwitchSize.sm:
        return 20;
      case SwitchSize.md:
        return 28;
      case SwitchSize.lg:
        return 32;
    }
  }

  double _thumbSizeForSize() {
    switch (widget.size) {
      case SwitchSize.sm:
        return 14;
      case SwitchSize.md:
        return 20;
      case SwitchSize.lg:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool disabled = widget.onChanged == null;

    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    final inactiveColor =
        widget.inactiveColor ?? theme.colorScheme.surfaceVariant;
    final thumbColor = widget.thumbColor ?? theme.colorScheme.onPrimary;

    final width = _widthForSize();
    final height = _heightForSize();
    final thumbSize = _thumbSizeForSize();

    final switchWidget = Semantics(
      toggled: _value,
      enabled: !disabled,
      container: true,
      button: false,
      // Use role "switch" for screen readers
      label: widget.label,
      child: FocusableActionDetector(
        enabled: !disabled,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              _toggle();
              return null;
            },
          ),
        },
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
        },
        focusNode: _focusNode,
        child: GestureDetector(
          onTap: disabled ? null : _toggle,
          child: AnimatedBuilder(
            animation: _thumbAnimation,
            builder: (context, child) {
              final t = _thumbAnimation.value;
              final bgColor = Color.lerp(inactiveColor, activeColor, t)!;
              final dx = (width - thumbSize - 4) * t;

              return Container(
                width: width,
                height: height,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: disabled
                      ? theme.disabledColor.withOpacity(0.12)
                      : bgColor,
                  borderRadius: BorderRadius.circular(height / 2),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.12),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      left: 2 + dx,
                      child: Container(
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          color: disabled ? theme.disabledColor : thumbColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    Widget labeled;
    final labelWidget = widget.label != null
        ? Text(widget.label!, style: theme.textTheme.bodyMedium)
        : const SizedBox.shrink();

    final descriptionWidget = widget.description != null
        ? Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              widget.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          )
        : const SizedBox.shrink();

    switch (widget.labelPosition) {
      case SwitchLabelPosition.left:
        labeled = Row(
          mainAxisSize: MainAxisSize.min,
          children: [labelWidget, const SizedBox(width: 8), switchWidget],
        );
        break;
      case SwitchLabelPosition.right:
        labeled = Row(
          mainAxisSize: MainAxisSize.min,
          children: [switchWidget, const SizedBox(width: 8), labelWidget],
        );
        break;
      case SwitchLabelPosition.top:
        labeled = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelWidget,
            descriptionWidget,
            const SizedBox(height: 6),
            switchWidget,
          ],
        );
        break;
      case SwitchLabelPosition.bottom:
        labeled = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            switchWidget,
            const SizedBox(height: 6),
            labelWidget,
            descriptionWidget,
          ],
        );
        break;
    }

    return MergeSemantics(
      child: InkWell(
        onTap: widget.label != null && !disabled
            ? () {
                _toggle();
              }
            : null,
        child: labeled,
      ),
    );
  }
}
