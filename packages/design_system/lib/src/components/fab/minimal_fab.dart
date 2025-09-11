import 'package:flutter/material.dart';

enum MinimalFABSize { mini, regular, large }

class MinimalFloatingActionButton extends StatefulWidget {
  const MinimalFloatingActionButton({
    super.key,
    required this.onPressed,
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.elevation = 6.0,
    this.focusElevation = 8.0,
    this.hoverElevation = 8.0,
    this.highlightElevation = 12.0,
    this.size = MinimalFABSize.regular,
    this.shape,
    this.isExtended = false,
    this.label,
    this.icon,
    this.heroTag,
    this.isLoading = false,
    this.mini = false,
  });

  final VoidCallback? onPressed;
  final Widget? child;
  final String? tooltip;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double elevation;
  final double focusElevation;
  final double hoverElevation;
  final double highlightElevation;
  final MinimalFABSize size;
  final ShapeBorder? shape;
  final bool isExtended;
  final Widget? label;
  final Widget? icon;
  final Object? heroTag;
  final bool isLoading;
  final bool mini;

  @override
  State<MinimalFloatingActionButton> createState() =>
      _MinimalFloatingActionButtonState();
}

class _MinimalFloatingActionButtonState
    extends State<MinimalFloatingActionButton>
    with SingleTickerProviderStateMixin {
  double _getSizeForType(MinimalFABSize size) {
    switch (size) {
      case MinimalFABSize.mini:
        return 40.0;
      case MinimalFABSize.regular:
        return 56.0;
      case MinimalFABSize.large:
        return 96.0;
    }
  }

  Widget _buildChild(BuildContext context) {
    final fg =
        widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary;
    if (widget.isLoading) {
      return SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    }
    if (widget.child != null) return widget.child!;
    if (widget.icon != null) return widget.icon!;
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.mini ? 40.0 : _getSizeForType(widget.size);
    final bg = widget.backgroundColor ?? Theme.of(context).colorScheme.primary;
    final fg =
        widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary;

    final button = Material(
      color: widget.onPressed == null ? Theme.of(context).disabledColor : bg,
      elevation: widget.elevation,
      shape: widget.shape ?? const CircleBorder(),
      child: InkWell(
        onTap: widget.onPressed == null || widget.isLoading
            ? null
            : widget.onPressed,
        customBorder: widget.shape ?? const CircleBorder(),
        child: Container(
          width: widget.isExtended ? null : size,
          height: size,
          padding: widget.isExtended
              ? const EdgeInsets.symmetric(horizontal: 16.0)
              : EdgeInsets.zero,
          constraints: widget.isExtended
              ? const BoxConstraints(minWidth: 80.0, minHeight: 48.0)
              : null,
          alignment: Alignment.center,
          child: widget.isExtended
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      IconTheme.merge(
                        data: IconThemeData(color: fg),
                        child: widget.icon!,
                      ),
                      const SizedBox(width: 8.0),
                    ],
                    if (widget.label != null)
                      DefaultTextStyle(
                        style: TextStyle(color: fg),
                        child: widget.label!,
                      ),
                    if (widget.icon == null && widget.label == null)
                      _buildChild(context),
                  ],
                )
              : IconTheme.merge(
                  data: IconThemeData(color: fg),
                  child: _buildChild(context),
                ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: widget.onPressed != null && !widget.isLoading,
      label: widget.tooltip ?? 'Floating action button',
      child: Focus(
        child: SizedBox(
          width: widget.isExtended ? null : size,
          child: widget.heroTag != null
              ? Hero(tag: widget.heroTag!, child: button)
              : button,
        ),
      ),
    );
  }
}
