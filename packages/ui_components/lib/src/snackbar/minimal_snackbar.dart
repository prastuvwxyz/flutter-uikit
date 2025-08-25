import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Design tokens (replace with your actual token imports)
import '../../tokens/color_tokens.dart';
import '../../tokens/typography_tokens.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/radius_tokens.dart';
import '../../tokens/elevation_tokens.dart';

enum SnackbarType { success, warning, error, info }

enum SnackbarPosition { bottom, top }

class SnackbarAction {
  final String label;
  final VoidCallback onPressed;
  SnackbarAction({required this.label, required this.onPressed});
}

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
