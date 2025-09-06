import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

/// A minimal toggle button that represents a binary selected/unselected state.
class MinimalToggleButton extends StatefulWidget {
  const MinimalToggleButton({
    super.key,
    required this.onPressed,
    required this.isSelected,
    this.child,
    this.icon,
    this.label,
    this.style,
    this.isEnabled = true,
    this.isLoading = false,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
  });

  final ValueChanged<bool>? onPressed;
  final bool isSelected;
  final Widget? child;
  final Widget? icon;
  final Widget? label;
  final ToggleButtonStyle? style;
  final bool isEnabled;
  final bool isLoading;
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<MinimalToggleButton> createState() => _MinimalToggleButtonState();
}

class ToggleButtonStyle {
  const ToggleButtonStyle({
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.foregroundColor,
    this.selectedForegroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.elevation,
    this.selectedElevation,
    this.padding,
    this.borderRadius,
    this.borderWidth,
  });

  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? foregroundColor;
  final Color? selectedForegroundColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final double? elevation;
  final double? selectedElevation;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? borderWidth;
}

class _MinimalToggleButtonState extends State<MinimalToggleButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isFocused = false;

  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isDisabled =>
      !widget.isEnabled || widget.isLoading || widget.onPressed == null;

  void _handleTap() {
    if (_isDisabled) return;
    _controller.forward().then((_) => _controller.reverse());
    widget.onPressed?.call(!widget.isSelected);
  }

  Color _getBackground(UiTokens tokens) {
    final defaultBg =
        widget.style?.backgroundColor ?? tokens.colorTokens.neutral.shade50;
    final selectedBg =
        widget.style?.selectedBackgroundColor ??
        tokens.colorTokens.primary.shade500;
    if (_isDisabled) return defaultBg.withOpacity(0.12);
    if (widget.isSelected) return selectedBg;
    if (_isFocused) return defaultBg.withOpacity(0.95);
    if (_isHovered) return defaultBg.withOpacity(0.98);
    return defaultBg;
  }

  Color _getForeground(UiTokens tokens) {
    final defaultFg =
        widget.style?.foregroundColor ?? tokens.colorTokens.neutral.shade900;
    final selectedFg = widget.style?.selectedForegroundColor ?? Colors.white;
    if (_isDisabled) return defaultFg.withOpacity(0.38);
    return widget.isSelected ? selectedFg : defaultFg;
  }

  BorderRadius _borderRadius(UiTokens tokens) =>
      widget.style?.borderRadius ??
      BorderRadius.circular(tokens.radiusTokens.md);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<UiTokens>() ?? UiTokens.standard();

    final background = _getBackground(tokens);
    final foreground = _getForeground(tokens);

    final content =
        widget.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              IconTheme(
                data: IconThemeData(color: foreground, size: 20),
                child: widget.icon!,
              ),
              if (widget.label != null) const SizedBox(width: 8),
            ],
            if (widget.label != null)
              DefaultTextStyle(
                style: TextStyle(color: foreground),
                child: widget.label!,
              ),
          ],
        );

    Widget child = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Transform.scale(
          scale: _scale.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isDisabled ? null : _handleTap,
              borderRadius: _borderRadius(tokens),
              splashColor: foreground.withOpacity(0.12),
              highlightColor: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: _borderRadius(tokens),
                  border: Border.all(
                    color: widget.isSelected
                        ? (widget.style?.selectedBorderColor ??
                              tokens.colorTokens.primary.shade500)
                        : (widget.style?.borderColor ??
                              tokens.colorTokens.neutral.shade300),
                    width: widget.style?.borderWidth ?? 1.0,
                  ),
                ),
                padding:
                    widget.style?.padding ??
                    EdgeInsets.symmetric(
                      horizontal: tokens.spacingTokens.md,
                      vertical: tokens.spacingTokens.sm / 2,
                    ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              foreground,
                            ),
                          ),
                        )
                      : DefaultTextStyle(
                          style: TextStyle(color: foreground),
                          child: content,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );

    child = Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (f) => setState(() => _isFocused = f),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          button: true,
          enabled: !_isDisabled,
          selected: widget.isSelected,
          label: widget.tooltip,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: tokens.spacingTokens.xxxxl,
              minHeight: tokens.spacingTokens.xxxxl,
            ),
            child: child,
          ),
        ),
      ),
    );

    return child;
  }
}
