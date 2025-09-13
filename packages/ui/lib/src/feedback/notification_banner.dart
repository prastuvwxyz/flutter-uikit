import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tokens/tokens.dart' as tokens;

/// Types of notifications with different visual treatments
enum NotificationType {
  /// Informational message (blue)
  info,

  /// Success message (green)
  success,

  /// Warning message (orange)
  warning,

  /// Error message (red)
  error,
}

/// Position of the notification banner
enum BannerPosition {
  /// Display at the top of the screen
  top,

  /// Display at the bottom of the screen
  bottom,
}

/// A notification banner component for displaying temporary messages and alerts.
///
/// The NotificationBanner component provides a way to display informational,
/// success, warning, or error messages to users. It supports auto-hide functionality,
/// custom actions, positioning, and proper accessibility features.
///
/// Example:
/// ```dart
/// NotificationBanner(
///   type: NotificationType.success,
///   title: 'Success',
///   message: 'Your changes have been saved successfully.',
///   onDismiss: () => setState(() => showBanner = false),
///   autoHide: true,
/// )
/// ```
class NotificationBanner extends StatefulWidget {
  /// The main message text to display
  final String message;

  /// Optional title text above the message
  final String? title;

  /// The type of notification (determines color and icon)
  final NotificationType type;

  /// Optional custom icon to override the default type-based icon
  final IconData? icon;

  /// Whether to show the type-based icon
  final bool showIcon;

  /// Whether the banner can be dismissed with a close button
  final bool isDismissible;

  /// Callback when the banner is dismissed
  final VoidCallback? onDismiss;

  /// Optional list of action widgets to display
  final List<Widget> actions;

  /// Position of the banner (top or bottom)
  final BannerPosition position;

  /// Whether to auto-hide the banner after a duration
  final bool autoHide;

  /// Duration before auto-hiding
  final Duration autoHideDuration;

  /// Duration for show/hide animations
  final Duration animationDuration;

  /// Custom padding inside the banner
  final EdgeInsets? padding;

  /// Custom margin around the banner
  final EdgeInsets? margin;

  /// Creates a NotificationBanner.
  ///
  /// The [message] parameter is required and displays the banner content.
  /// The [type] parameter defaults to [NotificationType.info].
  const NotificationBanner({
    super.key,
    required this.message,
    this.title,
    this.type = NotificationType.info,
    this.icon,
    this.showIcon = true,
    this.isDismissible = true,
    this.onDismiss,
    this.actions = const [],
    this.position = BannerPosition.top,
    this.autoHide = false,
    this.autoHideDuration = const Duration(seconds: 5),
    this.animationDuration = const Duration(milliseconds: 300),
    this.padding,
    this.margin,
  });

  /// Creates an info notification banner
  factory NotificationBanner.info({
    required String message,
    String? title,
    VoidCallback? onDismiss,
    bool autoHide = false,
    List<Widget> actions = const [],
  }) =>
      NotificationBanner(
        message: message,
        title: title,
        type: NotificationType.info,
        onDismiss: onDismiss,
        autoHide: autoHide,
        actions: actions,
      );

  /// Creates a success notification banner
  factory NotificationBanner.success({
    required String message,
    String? title,
    VoidCallback? onDismiss,
    bool autoHide = true,
    List<Widget> actions = const [],
  }) =>
      NotificationBanner(
        message: message,
        title: title,
        type: NotificationType.success,
        onDismiss: onDismiss,
        autoHide: autoHide,
        actions: actions,
      );

  /// Creates a warning notification banner
  factory NotificationBanner.warning({
    required String message,
    String? title,
    VoidCallback? onDismiss,
    bool autoHide = false,
    List<Widget> actions = const [],
  }) =>
      NotificationBanner(
        message: message,
        title: title,
        type: NotificationType.warning,
        onDismiss: onDismiss,
        autoHide: autoHide,
        actions: actions,
      );

  /// Creates an error notification banner
  factory NotificationBanner.error({
    required String message,
    String? title,
    VoidCallback? onDismiss,
    bool autoHide = false,
    List<Widget> actions = const [],
  }) =>
      NotificationBanner(
        message: message,
        title: title,
        type: NotificationType.error,
        onDismiss: onDismiss,
        autoHide: autoHide,
        actions: actions,
      );

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _autoHideTimer;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: 1.0,
    );

    if (widget.autoHide) {
      _startAutoHideTimer();
    }
  }

  @override
  void didUpdateWidget(covariant NotificationBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoHide != oldWidget.autoHide ||
        widget.autoHideDuration != oldWidget.autoHideDuration) {
      _autoHideTimer?.cancel();
      if (widget.autoHide) _startAutoHideTimer();
    }
  }

  void _startAutoHideTimer() {
    _autoHideTimer = Timer(widget.autoHideDuration, () {
      _hide();
    });
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _hide() {
    if (!_visible) return;
    setState(() => _visible = false);
    _controller.reverse();
    widget.onDismiss?.call();
  }

  /// Get background color for the notification type
  Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.type) {
      case NotificationType.success:
        return const Color(0xFF10B981); // Green-500
      case NotificationType.warning:
        return const Color(0xFFF59E0B); // Yellow-500
      case NotificationType.error:
        return colorScheme.error;
      case NotificationType.info:
        return colorScheme.primary;
    }
  }

  /// Get the default icon for the notification type
  IconData _getDefaultIcon() {
    switch (widget.type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = tokens.Spacing.of(context);
    final radius = tokens.Radius.of(context);

    final backgroundColor = _getBackgroundColor(context);
    const textColor = Colors.white;

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.showIcon) ...[
          Icon(
            widget.icon ?? _getDefaultIcon(),
            color: textColor,
            size: 20,
          ),
          SizedBox(width: spacing.sm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != null) ...[
                Text(
                  widget.title!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing.xs),
              ],
              Text(
                widget.message,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ],
          ),
        ),
        if (widget.actions.isNotEmpty) ...[
          SizedBox(width: spacing.sm),
          ...widget.actions.map((action) => Padding(
                padding: EdgeInsets.only(left: spacing.xs),
                child: action,
              )),
        ],
        if (widget.isDismissible) ...[
          SizedBox(width: spacing.sm),
          IconButton(
            icon: Icon(Icons.close, color: textColor, size: 18),
            onPressed: _hide,
            tooltip: 'Dismiss',
            splashRadius: 20,
          ),
        ],
      ],
    );

    final aligned = Align(
      alignment: widget.position == BannerPosition.top
          ? Alignment.topCenter
          : Alignment.bottomCenter,
      child: SafeArea(
        minimum: widget.margin ?? EdgeInsets.zero,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius.md),
          elevation: 4,
          child: Semantics(
            container: true,
            liveRegion: true,
            label: '${widget.type.name} notification: ${widget.title ?? widget.message}',
            child: Container(
              width: double.infinity,
              padding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: spacing.md,
                    vertical: spacing.sm,
                  ),
              child: content,
            ),
          ),
        ),
      ),
    );

    final slideOffset = widget.position == BannerPosition.top
        ? Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        : Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero);

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    return SizeTransition(
      sizeFactor: curvedAnimation,
      axisAlignment: widget.position == BannerPosition.top ? -1.0 : 1.0,
      child: SlideTransition(
        position: slideOffset.animate(curvedAnimation),
        child: aligned,
      ),
    );
  }
}