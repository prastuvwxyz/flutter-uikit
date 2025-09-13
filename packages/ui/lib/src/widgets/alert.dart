import 'package:flutter/material.dart';
import '../internal/token_adapters.dart';
import '../internal/a11y.dart';

/// Types of alerts available
enum AlertType {
  /// Success alert (green, check icon)
  success,
  /// Warning alert (yellow, warning icon)
  warning,
  /// Error alert (red, error icon)
  error,
  /// Info alert (blue, info icon)
  info,
}

/// Visual variants for alerts
enum AlertVariant {
  /// Filled background with contrasting text
  filled,
  /// Outlined border with surface background
  outlined,
  /// Light background with matching text color
  ghost,
}

/// Extension methods for AlertType
extension AlertTypeExtension on AlertType {
  /// Icon for this alert type
  IconData get icon {
    switch (this) {
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.info:
        return Icons.info_outline;
    }
  }

  /// Semantic label for accessibility
  String get semanticLabel {
    switch (this) {
      case AlertType.success:
        return 'Success';
      case AlertType.warning:
        return 'Warning';
      case AlertType.error:
        return 'Error';
      case AlertType.info:
        return 'Information';
    }
  }

  /// Get background color based on type and variant
  Color getBackgroundColor(BuildContext context, AlertVariant variant) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (this) {
      case AlertType.success:
        switch (variant) {
          case AlertVariant.filled:
            return Colors.green.shade600;
          case AlertVariant.outlined:
            return Colors.transparent;
          case AlertVariant.ghost:
            return Colors.green.shade50;
        }
      case AlertType.warning:
        switch (variant) {
          case AlertVariant.filled:
            return Colors.orange.shade600;
          case AlertVariant.outlined:
            return Colors.transparent;
          case AlertVariant.ghost:
            return Colors.orange.shade50;
        }
      case AlertType.error:
        switch (variant) {
          case AlertVariant.filled:
            return colorScheme.error;
          case AlertVariant.outlined:
            return Colors.transparent;
          case AlertVariant.ghost:
            return colorScheme.errorContainer;
        }
      case AlertType.info:
        switch (variant) {
          case AlertVariant.filled:
            return colorScheme.primary;
          case AlertVariant.outlined:
            return Colors.transparent;
          case AlertVariant.ghost:
            return colorScheme.primaryContainer;
        }
    }
  }

  /// Get border color based on type and variant
  Color getBorderColor(BuildContext context, AlertVariant variant) {
    if (variant != AlertVariant.outlined) {
      return Colors.transparent;
    }

    final colorScheme = Theme.of(context).colorScheme;

    switch (this) {
      case AlertType.success:
        return Colors.green.shade600;
      case AlertType.warning:
        return Colors.orange.shade600;
      case AlertType.error:
        return colorScheme.error;
      case AlertType.info:
        return colorScheme.primary;
    }
  }

  /// Get text color based on type and variant
  Color getTextColor(BuildContext context, AlertVariant variant) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case AlertVariant.filled:
        switch (this) {
          case AlertType.success:
            return Colors.white;
          case AlertType.warning:
            return Colors.black87;
          case AlertType.error:
            return colorScheme.onError;
          case AlertType.info:
            return colorScheme.onPrimary;
        }
      case AlertVariant.outlined:
      case AlertVariant.ghost:
        switch (this) {
          case AlertType.success:
            return Colors.green.shade700;
          case AlertType.warning:
            return Colors.orange.shade700;
          case AlertType.error:
            return colorScheme.error;
          case AlertType.info:
            return colorScheme.primary;
        }
    }
  }
}

/// Alert component for displaying status messages
class Alert extends StatefulWidget {
  /// The type of alert to display
  final AlertType type;

  /// Optional title text
  final String? title;

  /// Main message content
  final String message;

  /// Custom icon (overrides type icon)
  final Widget? icon;

  /// Whether to show the type icon
  final bool showIcon;

  /// Callback when alert is closed
  final VoidCallback? onClose;

  /// Action buttons to display
  final List<Widget>? actions;

  /// Whether alert can be dismissed
  final bool closable;

  /// Visual style variant
  final AlertVariant variant;

  const Alert({
    super.key,
    this.type = AlertType.info,
    this.title,
    required this.message,
    this.icon,
    this.showIcon = true,
    this.onClose,
    this.actions,
    this.closable = true,
    this.variant = AlertVariant.filled,
  });

  /// Factory for success alerts
  factory Alert.success({
    Key? key,
    String? title,
    required String message,
    Widget? icon,
    bool showIcon = true,
    VoidCallback? onClose,
    List<Widget>? actions,
    bool closable = true,
    AlertVariant variant = AlertVariant.filled,
  }) {
    return Alert(
      key: key,
      type: AlertType.success,
      title: title,
      message: message,
      icon: icon,
      showIcon: showIcon,
      onClose: onClose,
      actions: actions,
      closable: closable,
      variant: variant,
    );
  }

  /// Factory for warning alerts
  factory Alert.warning({
    Key? key,
    String? title,
    required String message,
    Widget? icon,
    bool showIcon = true,
    VoidCallback? onClose,
    List<Widget>? actions,
    bool closable = true,
    AlertVariant variant = AlertVariant.filled,
  }) {
    return Alert(
      key: key,
      type: AlertType.warning,
      title: title,
      message: message,
      icon: icon,
      showIcon: showIcon,
      onClose: onClose,
      actions: actions,
      closable: closable,
      variant: variant,
    );
  }

  /// Factory for error alerts
  factory Alert.error({
    Key? key,
    String? title,
    required String message,
    Widget? icon,
    bool showIcon = true,
    VoidCallback? onClose,
    List<Widget>? actions,
    bool closable = true,
    AlertVariant variant = AlertVariant.filled,
  }) {
    return Alert(
      key: key,
      type: AlertType.error,
      title: title,
      message: message,
      icon: icon,
      showIcon: showIcon,
      onClose: onClose,
      actions: actions,
      closable: closable,
      variant: variant,
    );
  }

  /// Factory for info alerts
  factory Alert.info({
    Key? key,
    String? title,
    required String message,
    Widget? icon,
    bool showIcon = true,
    VoidCallback? onClose,
    List<Widget>? actions,
    bool closable = true,
    AlertVariant variant = AlertVariant.filled,
  }) {
    return Alert(
      key: key,
      type: AlertType.info,
      title: title,
      message: message,
      icon: icon,
      showIcon: showIcon,
      onClose: onClose,
      actions: actions,
      closable: closable,
      variant: variant,
    );
  }

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> with TickerProviderStateMixin {
  bool _isClosing = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: TokenAdapters.durationFromTokens(TokenDuration.normal),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
    );

    _focusNode = FocusNode();

    // Start animation
    _animationController.forward();

    // Auto-focus for accessibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNode != null) {
        A11yUtils.requestFocus(context, _focusNode!);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (_isClosing || !mounted) return;

    setState(() {
      _isClosing = true;
    });

    _animationController.reverse().then((_) {
      if (mounted && widget.onClose != null) {
        widget.onClose!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.type.getBackgroundColor(context, widget.variant);
    final borderColor = widget.type.getBorderColor(context, widget.variant);
    final textColor = widget.type.getTextColor(context, widget.variant);

    // Build icon widget
    Widget? iconWidget;
    if (widget.showIcon) {
      if (widget.icon != null) {
        iconWidget = IconTheme(
          data: IconThemeData(color: textColor, size: 20),
          child: widget.icon!,
        );
      } else {
        iconWidget = Icon(
          widget.type.icon,
          color: textColor,
          size: 20,
          semanticLabel: widget.type.semanticLabel,
        );
      }
    }

    // Build close button
    Widget? closeButton;
    if (widget.closable) {
      closeButton = IconButton(
        icon: const Icon(Icons.close),
        color: textColor,
        iconSize: 18,
        padding: context.padding(all: TokenSize.xs),
        constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        tooltip: 'Close',
        onPressed: _handleClose,
      );
    }

    return A11yFocusableWidget(
      focusNode: _focusNode,
      autofocus: true,
      semanticLabel: widget.type.semanticLabel,
      isContainer: true,
      onKey: (node, event) => A11yUtils.handleEscapeKey(
        event: event,
        onEscape: widget.closable ? _handleClose : null,
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(_animation),
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: context.borderRadius(all: TokenRadiusSize.md),
            border: widget.variant == AlertVariant.outlined
                ? Border.all(color: borderColor, width: 1)
                : null,
          ),
          child: Padding(
            padding: context.padding(all: TokenSize.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (iconWidget != null) ...[
                      iconWidget,
                      SizedBox(width: context.spacing.sm),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null) ...[
                            Text(
                              widget.title!,
                              style: TokenAdapters.textStyleFromTokens(
                                tokenStyle: TokenTextStyle.labelLarge,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: context.spacing.xs),
                          ],
                          Text(
                            widget.message,
                            style: TokenAdapters.textStyleFromTokens(
                              tokenStyle: TokenTextStyle.bodyMedium,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (closeButton != null) closeButton,
                  ],
                ),
                if (widget.actions != null && widget.actions!.isNotEmpty) ...[
                  SizedBox(height: context.spacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: widget.actions!
                        .map((action) => Padding(
                              padding: EdgeInsets.only(
                                left: context.spacing.xs,
                              ),
                              child: action,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}