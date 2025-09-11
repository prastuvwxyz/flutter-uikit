import 'dart:async';

import 'package:flutter/material.dart';

// ...existing code...

enum NotificationType { info, success, warning, error }

enum BannerPosition { top, bottom }

class MinimalNotificationBanner extends StatefulWidget {
  final String message;
  final String? title;
  final NotificationType type;
  final IconData? icon;
  final bool showIcon;
  final bool isDismissible;
  final VoidCallback? onDismiss;
  final List<Widget> actions;
  final BannerPosition position;
  final bool autoHide;
  final Duration autoHideDuration;
  final Duration animationDuration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const MinimalNotificationBanner({
    Key? key,
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
  }) : super(key: key);

  @override
  State<MinimalNotificationBanner> createState() =>
      _MinimalNotificationBannerState();
}

class _MinimalNotificationBannerState extends State<MinimalNotificationBanner>
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
  void didUpdateWidget(covariant MinimalNotificationBanner oldWidget) {
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

  Color _backgroundColor(BuildContext context) {
    switch (widget.type) {
      case NotificationType.success:
        return Colors.green.shade600;
      case NotificationType.warning:
        return Colors.orange.shade700;
      case NotificationType.error:
        return Colors.red.shade700;
      case NotificationType.info:
        return Theme.of(context).colorScheme.primary.withOpacity(0.9);
    }
  }

  IconData _defaultIcon() {
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
    final bg = _backgroundColor(context);
    final textColor = Colors.white;
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.showIcon) ...[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(
              widget.icon ?? _defaultIcon(),
              color: textColor,
              size: 20,
            ),
          ),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != null) ...[
                Text(
                  widget.title!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(widget.message, style: TextStyle(color: textColor)),
            ],
          ),
        ),
        ...widget.actions,
        if (widget.isDismissible)
          IconButton(
            icon: Icon(Icons.close, color: textColor),
            onPressed: () {
              _hide();
            },
            tooltip: 'Dismiss',
            splashRadius: 20,
          ),
      ],
    );

    final aligned = Align(
      alignment: widget.position == BannerPosition.top
          ? Alignment.topCenter
          : Alignment.bottomCenter,
      child: SafeArea(
        minimum: widget.margin ?? EdgeInsets.zero,
        child: Padding(
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Material(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            child: Semantics(
              container: true,
              liveRegion: true,
              label: widget.title ?? widget.message,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );

    final slideOffset = widget.position == BannerPosition.top
        ? Tween<Offset>(begin: Offset(0, -1), end: Offset.zero)
        : Tween<Offset>(begin: Offset(0, 1), end: Offset.zero);

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    return SizeTransition(
      sizeFactor: curved,
      axisAlignment: widget.position == BannerPosition.top ? -1.0 : 1.0,
      child: SlideTransition(
        position: slideOffset.animate(curved),
        child: aligned,
      ),
    );
  }
}
