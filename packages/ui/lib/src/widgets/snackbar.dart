import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../internal/token_adapters.dart';

/// Type of snackbar based on severity
enum SnackbarType {
  /// Default informational snackbar
  info,
  /// Success snackbar (green)
  success,
  /// Warning snackbar (orange)
  warning,
  /// Error snackbar (red)
  error,
}

/// Position of the snackbar
enum SnackbarPosition {
  /// Bottom of the screen (default)
  bottom,
  /// Top of the screen
  top,
}

/// Animation type for snackbar appearance
enum SnackbarAnimation {
  /// Slide from bottom (default)
  slideUp,
  /// Slide from top
  slideDown,
  /// Fade in
  fade,
  /// Scale in
  scale,
}

/// Action button configuration for snackbar
class SnackbarAction {
  /// Text for the action button
  final String label;

  /// Callback when action is pressed
  final VoidCallback onPressed;

  /// Color for the action button
  final Color? textColor;

  /// Whether the action should dismiss the snackbar
  final bool dismissOnPress;

  const SnackbarAction({
    required this.label,
    required this.onPressed,
    this.textColor,
    this.dismissOnPress = true,
  });
}

/// A customizable snackbar component with different types and animations
class CustomSnackbar extends StatefulWidget {
  /// Message text to display
  final String message;

  /// Type/severity of the snackbar
  final SnackbarType type;

  /// Position on screen
  final SnackbarPosition position;

  /// Animation type
  final SnackbarAnimation animation;

  /// Duration to show the snackbar
  final Duration duration;

  /// Whether the snackbar can be dismissed by swiping
  final bool dismissible;

  /// Whether to show a close button
  final bool showCloseButton;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom text color
  final Color? textColor;

  /// Optional action button
  final SnackbarAction? action;

  /// Optional leading icon
  final Widget? icon;

  /// Whether to auto-dismiss
  final bool autoDismiss;

  /// Callback when dismissed
  final VoidCallback? onDismissed;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Margin around the snackbar
  final EdgeInsets? margin;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Custom elevation
  final double? elevation;

  const CustomSnackbar({
    super.key,
    required this.message,
    this.type = SnackbarType.info,
    this.position = SnackbarPosition.bottom,
    this.animation = SnackbarAnimation.slideUp,
    this.duration = const Duration(seconds: 4),
    this.dismissible = true,
    this.showCloseButton = true,
    this.backgroundColor,
    this.textColor,
    this.action,
    this.icon,
    this.autoDismiss = true,
    this.onDismissed,
    this.semanticLabel,
    this.margin,
    this.borderRadius,
    this.elevation,
  });

  /// Factory for success snackbar
  factory CustomSnackbar.success({
    Key? key,
    required String message,
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAnimation animation = SnackbarAnimation.slideUp,
    Duration duration = const Duration(seconds: 4),
    bool dismissible = true,
    bool showCloseButton = true,
    SnackbarAction? action,
    bool autoDismiss = true,
    VoidCallback? onDismissed,
    String? semanticLabel,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    double? elevation,
  }) {
    return CustomSnackbar(
      key: key,
      message: message,
      type: SnackbarType.success,
      position: position,
      animation: animation,
      duration: duration,
      dismissible: dismissible,
      showCloseButton: showCloseButton,
      action: action,
      icon: const Icon(Icons.check_circle_outline, size: 20),
      autoDismiss: autoDismiss,
      onDismissed: onDismissed,
      semanticLabel: semanticLabel ?? 'Success message',
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
    );
  }

  /// Factory for error snackbar
  factory CustomSnackbar.error({
    Key? key,
    required String message,
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAnimation animation = SnackbarAnimation.slideUp,
    Duration duration = const Duration(seconds: 6),
    bool dismissible = true,
    bool showCloseButton = true,
    SnackbarAction? action,
    bool autoDismiss = true,
    VoidCallback? onDismissed,
    String? semanticLabel,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    double? elevation,
  }) {
    return CustomSnackbar(
      key: key,
      message: message,
      type: SnackbarType.error,
      position: position,
      animation: animation,
      duration: duration,
      dismissible: dismissible,
      showCloseButton: showCloseButton,
      action: action,
      icon: const Icon(Icons.error_outline, size: 20),
      autoDismiss: autoDismiss,
      onDismissed: onDismissed,
      semanticLabel: semanticLabel ?? 'Error message',
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
    );
  }

  /// Factory for warning snackbar
  factory CustomSnackbar.warning({
    Key? key,
    required String message,
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAnimation animation = SnackbarAnimation.slideUp,
    Duration duration = const Duration(seconds: 5),
    bool dismissible = true,
    bool showCloseButton = true,
    SnackbarAction? action,
    bool autoDismiss = true,
    VoidCallback? onDismissed,
    String? semanticLabel,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    double? elevation,
  }) {
    return CustomSnackbar(
      key: key,
      message: message,
      type: SnackbarType.warning,
      position: position,
      animation: animation,
      duration: duration,
      dismissible: dismissible,
      showCloseButton: showCloseButton,
      action: action,
      icon: const Icon(Icons.warning_amber_outlined, size: 20),
      autoDismiss: autoDismiss,
      onDismissed: onDismissed,
      semanticLabel: semanticLabel ?? 'Warning message',
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
    );
  }

  /// Factory for info snackbar
  factory CustomSnackbar.info({
    Key? key,
    required String message,
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAnimation animation = SnackbarAnimation.slideUp,
    Duration duration = const Duration(seconds: 4),
    bool dismissible = true,
    bool showCloseButton = true,
    SnackbarAction? action,
    bool autoDismiss = true,
    VoidCallback? onDismissed,
    String? semanticLabel,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    double? elevation,
  }) {
    return CustomSnackbar(
      key: key,
      message: message,
      type: SnackbarType.info,
      position: position,
      animation: animation,
      duration: duration,
      dismissible: dismissible,
      showCloseButton: showCloseButton,
      action: action,
      icon: const Icon(Icons.info_outline, size: 20),
      autoDismiss: autoDismiss,
      onDismissed: onDismissed,
      semanticLabel: semanticLabel ?? 'Information message',
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
    );
  }

  /// Show snackbar using ScaffoldMessenger
  static void show({
    required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 4),
    SnackbarAction? action,
    Widget? icon,
    Color? backgroundColor,
    Color? textColor,
    bool showCloseButton = true,
    String? semanticLabel,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBackgroundColor = backgroundColor ?? _getTypeColor(type, colorScheme);
    final effectiveTextColor = textColor ?? _getTextColor(type, colorScheme);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(color: effectiveTextColor),
                child: icon,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: effectiveTextColor),
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  if (action.dismissOnPress) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }
                  action.onPressed();
                },
                child: Text(
                  action.label,
                  style: TextStyle(
                    color: action.textColor ?? effectiveTextColor,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: effectiveBackgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        showCloseIcon: showCloseButton,
        closeIconColor: effectiveTextColor,
      ),
    );
  }

  /// Get color based on type
  static Color _getTypeColor(SnackbarType type, ColorScheme colorScheme) {
    switch (type) {
      case SnackbarType.success:
        return Colors.green.shade600;
      case SnackbarType.error:
        return colorScheme.error;
      case SnackbarType.warning:
        return Colors.orange.shade600;
      case SnackbarType.info:
        return colorScheme.inverseSurface;
    }
  }

  /// Get text color based on type
  static Color _getTextColor(SnackbarType type, ColorScheme colorScheme) {
    switch (type) {
      case SnackbarType.success:
        return Colors.white;
      case SnackbarType.error:
        return colorScheme.onError;
      case SnackbarType.warning:
        return Colors.white;
      case SnackbarType.info:
        return colorScheme.onInverseSurface;
    }
  }

  @override
  State<CustomSnackbar> createState() => _CustomSnackbarState();
}

class _CustomSnackbarState extends State<CustomSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    switch (widget.animation) {
      case SnackbarAnimation.slideUp:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
        ));
        break;
      case SnackbarAnimation.slideDown:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
        ));
        break;
      case SnackbarAnimation.fade:
      case SnackbarAnimation.scale:
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(_animationController);
        break;
    }

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
    );

    _animationController.forward();

    if (widget.autoDismiss) {
      _dismissTimer = Timer(widget.duration, _dismiss);
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      widget.onDismissed?.call();
    });
  }

  void _handleDismiss() {
    HapticFeedback.lightImpact();
    _dismiss();
  }

  /// Get background color based on type
  Color _getBackgroundColor(BuildContext context) {
    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }

    final colorScheme = Theme.of(context).colorScheme;
    return CustomSnackbar._getTypeColor(widget.type, colorScheme);
  }

  /// Get text color based on type
  Color _getTextColor(BuildContext context) {
    if (widget.textColor != null) {
      return widget.textColor!;
    }

    final colorScheme = Theme.of(context).colorScheme;
    return CustomSnackbar._getTextColor(widget.type, colorScheme);
  }

  /// Build close button
  Widget? _buildCloseButton(Color textColor) {
    if (!widget.showCloseButton) return null;

    return IconButton(
      icon: Icon(Icons.close, size: 20, color: textColor),
      onPressed: _handleDismiss,
      tooltip: 'Dismiss',
      splashRadius: 20,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
    );
  }

  /// Build action button
  Widget? _buildAction(Color textColor) {
    if (widget.action == null) return null;

    return TextButton(
      onPressed: () {
        if (widget.action!.dismissOnPress) {
          _handleDismiss();
        }
        widget.action!.onPressed();
      },
      child: Text(
        widget.action!.label,
        style: TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.labelMedium,
          color: widget.action!.textColor ?? textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Build snackbar content
  Widget _buildContent() {
    final backgroundColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);

    Widget content = Container(
      margin: widget.margin ?? EdgeInsets.all(
        widget.position == SnackbarPosition.bottom ? 16.0 : 16.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: widget.elevation ?? 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        child: Row(
          children: [
            if (widget.icon != null) ...[
              IconTheme(
                data: IconThemeData(color: textColor),
                child: widget.icon!,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                widget.message,
                style: TokenAdapters.textStyleFromTokens(
                  tokenStyle: TokenTextStyle.bodyMedium,
                  color: textColor,
                ),
              ),
            ),
            if (widget.action != null || widget.showCloseButton) ...[
              const SizedBox(width: 8),
              if (_buildAction(textColor) != null)
                _buildAction(textColor)!,
              if (_buildCloseButton(textColor) != null)
                _buildCloseButton(textColor)!,
            ],
          ],
        ),
      ),
    );

    // Add dismissible behavior
    if (widget.dismissible) {
      content = Dismissible(
        key: UniqueKey(),
        direction: widget.position == SnackbarPosition.bottom
            ? DismissDirection.down
            : DismissDirection.up,
        onDismissed: (_) => _handleDismiss(),
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    Widget snackbar = _buildContent();

    // Apply animations
    switch (widget.animation) {
      case SnackbarAnimation.slideUp:
      case SnackbarAnimation.slideDown:
        snackbar = SlideTransition(
          position: _slideAnimation,
          child: snackbar,
        );
        break;
      case SnackbarAnimation.fade:
        snackbar = FadeTransition(
          opacity: _animation,
          child: snackbar,
        );
        break;
      case SnackbarAnimation.scale:
        snackbar = ScaleTransition(
          scale: _animation,
          child: snackbar,
        );
        break;
    }

    // Position the snackbar
    snackbar = Positioned(
      left: 0,
      right: 0,
      bottom: widget.position == SnackbarPosition.bottom ? 0 : null,
      top: widget.position == SnackbarPosition.top ? 0 : null,
      child: SafeArea(
        child: snackbar,
      ),
    );

    // Add semantics
    snackbar = Semantics(
      liveRegion: true,
      label: widget.semanticLabel ?? widget.message,
      child: snackbar,
    );

    return Material(
      type: MaterialType.transparency,
      child: snackbar,
    );
  }
}

/// Utility class for managing snackbar queues and global display
class SnackbarManager {
  static SnackbarManager? _instance;
  static SnackbarManager get instance => _instance ??= SnackbarManager._();

  SnackbarManager._();

  final List<CustomSnackbar> _queue = [];
  CustomSnackbar? _current;
  OverlayEntry? _overlayEntry;

  /// Show a snackbar using overlay
  Future<void> show({
    required BuildContext context,
    required CustomSnackbar snackbar,
  }) async {
    _queue.add(snackbar);
    _processQueue(context);
  }

  /// Process the queue
  void _processQueue(BuildContext context) {
    if (_current == null && _queue.isNotEmpty) {
      _current = _queue.removeAt(0);
      _showOverlay(context);
    }
  }

  /// Show overlay
  void _showOverlay(BuildContext context) {
    if (_current == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _current!,
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Auto-dismiss
    if (_current!.autoDismiss) {
      Timer(_current!.duration, () {
        dismiss();
      });
    }
  }

  /// Dismiss current snackbar
  void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _current = null;

    // Process next in queue
    if (_queue.isNotEmpty) {
      // Get context from the next snackbar if needed
      // For now, we'll require context to be passed
    }
  }

  /// Clear all snackbars
  void clear() {
    _queue.clear();
    dismiss();
  }
}