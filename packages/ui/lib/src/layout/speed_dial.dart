import 'package:flutter/material.dart';

/// A floating action button with expandable options.
class SpeedDial extends StatefulWidget {
  const SpeedDial({
    super.key,
    required this.children,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  final List<SpeedDialChild> children;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Duration animationDuration;

  @override
  State<SpeedDial> createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...widget.children.map((child) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Transform.scale(
              scale: _controller.value,
              child: Opacity(
                opacity: _controller.value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: child,
                ),
              ),
            ),
          );
        }).toList(),
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          elevation: widget.elevation,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: widget.animationDuration,
            child: widget.child ?? const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

/// A child item for the SpeedDial.
class SpeedDialChild extends StatelessWidget {
  const SpeedDialChild({
    super.key,
    required this.child,
    required this.onTap,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Widget child;
  final VoidCallback onTap;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        FloatingActionButton.small(
          onPressed: onTap,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          child: child,
        ),
      ],
    );
  }
}