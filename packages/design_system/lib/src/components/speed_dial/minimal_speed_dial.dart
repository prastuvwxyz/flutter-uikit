import 'package:flutter/material.dart';
import 'speed_dial_child.dart';
import 'speed_dial_direction.dart';

class MinimalSpeedDial extends StatefulWidget {
  const MinimalSpeedDial({
    super.key,
    this.children = const [],
    this.child,
    this.activeChild,
    this.icon,
    this.activeIcon,
    this.onOpen,
    this.onClose,
    this.direction = SpeedDialDirection.up,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.overlayColor,
    this.overlayOpacity = 0.8,
    this.spacing = 8.0,
    this.closeManually = true,
    this.useRotationAnimation = true,
  });

  final List<SpeedDialChild> children;
  final Widget? child;
  final Widget? activeChild;
  final IconData? icon;
  final IconData? activeIcon;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final SpeedDialDirection direction;
  final Duration animationDuration;
  final Curve animationCurve;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Color? overlayColor;
  final double overlayOpacity;
  final double spacing;
  final bool closeManually;
  final bool useRotationAnimation;

  @override
  State<MinimalSpeedDial> createState() => _MinimalSpeedDialState();
}

class _MinimalSpeedDialState extends State<MinimalSpeedDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _animation;

  bool get _isOpen =>
      _ctrl.status == AnimationStatus.forward ||
      _ctrl.status == AnimationStatus.completed;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(parent: _ctrl, curve: widget.animationCurve);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _ctrl.reverse();
      widget.onClose?.call();
    } else {
      _ctrl.forward();
      widget.onOpen?.call();
    }
    setState(() {});
  }

  void _close() {
    if (_isOpen) {
      _ctrl.reverse();
      widget.onClose?.call();
      setState(() {});
    }
  }

  Offset _childOffset(int index) {
    final distance = (index + 1) * (56.0 + widget.spacing);
    switch (widget.direction) {
      case SpeedDialDirection.up:
        return Offset(0, -distance);
      case SpeedDialDirection.down:
        return Offset(0, distance);
      case SpeedDialDirection.left:
        return Offset(-distance, 0);
      case SpeedDialDirection.right:
        return Offset(distance, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? Theme.of(context).colorScheme.primary;
    final fg =
        widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // overlay
        if (_isOpen)
          GestureDetector(
            onTap: widget.closeManually ? _close : null,
            child: Container(
              color: (widget.overlayColor ?? Colors.black).withOpacity(
                widget.overlayOpacity,
              ),
            ),
          ),
        // children
        ...List.generate(widget.children.length, (i) {
          final child = widget.children[i];
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              final offset = _childOffset(i) * _animation.value;
              return Positioned(
                right: 16.0 - offset.dx,
                bottom: 16.0 + offset.dy,
                child: Opacity(
                  opacity: _animation.value,
                  child: Material(
                    color: child.backgroundColor ?? bg,
                    elevation: widget.elevation,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        child.onTap?.call();
                        if (widget.closeManually) _close();
                      },
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          child.icon,
                          color: child.foregroundColor ?? fg,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).reversed,
        // main FAB
        Positioned(
          right: 16.0,
          bottom: 16.0,
          child: Semantics(
            button: true,
            child: Material(
              color: bg,
              elevation: widget.elevation,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _toggle,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, _) {
                      Widget content;
                      if (widget.useRotationAnimation) {
                        content = Transform.rotate(
                          angle: _animation.value * 0.5 * 3.14159,
                          child: Icon(
                            _isOpen
                                ? widget.activeIcon ?? Icons.close
                                : widget.icon ?? Icons.add,
                            color: fg,
                          ),
                        );
                      } else {
                        content = Icon(
                          _isOpen
                              ? widget.activeIcon ?? Icons.close
                              : widget.icon ?? Icons.add,
                          color: fg,
                        );
                      }
                      return content;
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
