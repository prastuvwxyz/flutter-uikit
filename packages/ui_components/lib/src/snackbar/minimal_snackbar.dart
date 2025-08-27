import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// SnackbarType enum
enum SnackbarType { success, warning, error, info }

// SnackbarAction class
class SnackbarAction {
  final String label;
  final VoidCallback onPressed;
  const SnackbarAction({required this.label, required this.onPressed});
}

// SnackbarPosition enum
enum SnackbarPosition { bottom, top }

class MinimalSnackbar extends StatefulWidget {
  final String? message;
  final SnackbarType type;
  final SnackbarAction? action;
  final Duration duration;
  final bool persistent;
  final bool showCloseButton;
  final SnackbarPosition position;
  final bool floating;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  const MinimalSnackbar({
    Key? key,
    this.message,
    this.type = SnackbarType.info,
    this.action,
    this.duration = const Duration(seconds: 4),
    this.persistent = false,
    this.showCloseButton = false,
    this.position = SnackbarPosition.bottom,
    this.floating = true,
    this.onAction,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<MinimalSnackbar> createState() => _MinimalSnackbarState();
}

class _MinimalSnackbarState extends State<MinimalSnackbar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _visible = true);
      _controller.forward();
      if (!widget.persistent) {
        Future.delayed(widget.duration, _dismiss);
      }
    });
  }

  void _dismiss() {
  Color _backgroundColor() {
    switch (widget.type) {
      case SnackbarType.success:
        return Colors.green;
      case SnackbarType.warning:
        return Colors.orange;
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.info:
        return Colors.blueGrey;
    }
  }

  Color _backgroundColor() {
    switch (widget.type) {
      case SnackbarType.success:
        return Colors.green;
      case SnackbarType.warning:
        return Colors.orange;
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.info:
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final borderRadius = BorderRadius.circular(12); // token: ui.radius.md
    final elevation = 6.0; // token: ui.elevation.md
    final padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12); // token: ui.spacing.md

    Widget content = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Text(
            widget.message ?? '',
            style: theme.textTheme.bodySmall, // token: ui.text.body.sm
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.action != null)
          TextButton(
            onPressed: () {
              widget.action!.onPressed();
              widget.onAction?.call();
              _dismiss();
            },
            child: Text(widget.action!.label, style: theme.textTheme.labelMedium), // token: ui.text.label.md
          ),
        if (widget.showCloseButton)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _dismiss,
            tooltip: 'Dismiss',
          ),
      ],
    );

    Widget snackbar = FadeTransition(
      opacity: _animation,
      child: Material(
        return Align(
          alignment: widget.position == SnackbarPosition.bottom
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          child: SafeArea(
            child: Padding(
              padding: widget.floating
                  ? const EdgeInsets.all(16)
                  : EdgeInsets.zero,
              child: snackbar,
            ),
          ),
        );
      }
    }
    this.message,
    this.type = SnackbarType.info,
    this.action,
    this.duration = const Duration(seconds: 4),
    this.persistent = false,
    this.showCloseButton = false,
    this.position = SnackbarPosition.bottom,
    this.floating = true,
    this.onAction,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<MinimalSnackbar> createState() => _MinimalSnackbarState();
}

class _MinimalSnackbarState extends State<MinimalSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _visible = true);
      _controller.forward();
      if (!widget.persistent) {
        Future.delayed(widget.duration, _dismiss);
      }
    });
  }

  void _dismiss() {
    if (!_visible) return;
    setState(() => _visible = false);
    _controller.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _backgroundColor() {
    switch (widget.type) {
      case SnackbarType.success:
        return ColorTokens.success;
      case SnackbarType.warning:
        return ColorTokens.warning;
      case SnackbarType.error:
        return ColorTokens.error;
      case SnackbarType.info:
        return ColorTokens.surface;
    }
  }

  Color _textColor() {
    switch (widget.type) {
      case SnackbarType.success:
      case SnackbarType.warning:
      case SnackbarType.error:
        return ColorTokens.onSurface;
      case SnackbarType.info:
        return ColorTokens.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final snackbar = FadeTransition(
      opacity: _animation,
      child: Material(
        elevation: ElevationTokens.md,
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        color: _backgroundColor(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: SpacingTokens.md,
            horizontal: SpacingTokens.lg,
          ),
          child: Row(
            mainAxisSize: widget.floating ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  widget.message ?? '',
                  style: TypographyTokens.bodySm.copyWith(color: _textColor()),
                  textDirection: Directionality.of(context),
                ),
              ),
              if (widget.action != null)
                TextButton(
                  onPressed: () {
                    widget.action!.onPressed();
                    widget.onAction?.call();
                  },
                  child: Text(
                    widget.action!.label,
                    style: TypographyTokens.labelMd,
                  ),
                ),
              if (widget.showCloseButton)
                IconButton(
                  icon: Icon(Icons.close, color: _textColor()),
                  onPressed: _dismiss,
                  tooltip: 'Close',
                ),
            ],
          ),
        ),
      ),
    );

    return Align(
      alignment: widget.position == SnackbarPosition.bottom
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(SpacingTokens.md),
          child: snackbar,
        ),
      ),
    );
  }
}
