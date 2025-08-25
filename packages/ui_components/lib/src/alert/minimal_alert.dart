import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'alert_types.dart';

/// Status alerts for success, error, warning, and info messages with dismissible action and icon support.
///
/// The [MinimalAlert] component provides a way to display important messages to users
/// with visual indicators for different status types. It supports actions, dismissal,
/// and different visual variants.
///
/// Example:
/// ```dart
/// MinimalAlert(
///   type: AlertType.success,
///   title: 'Success',
///   message: 'Your changes have been saved.',
///   onClose: () => print('Alert closed'),
/// )
/// ```
class MinimalAlert extends StatefulWidget {
  /// The type of alert to display (success, warning, error, info).
  final AlertType type;

  /// Optional heading text for the alert.
  final String? title;

  /// The main content message of the alert.
  final String message;

  /// Optional custom icon to override the default type-based icon.
  final Widget? icon;

  /// Whether to show the type-based icon.
  final bool showIcon;

  /// Optional callback when the alert is closed.
  final VoidCallback? onClose;

  /// Optional list of action widgets to display at the bottom of the alert.
  final List<Widget>? actions;

  /// Whether the alert can be dismissed with a close button.
  final bool closable;

  /// The visual style of the alert (filled, outlined, or ghost).
  final AlertVariant variant;

  /// Creates a [MinimalAlert].
  ///
  /// The [message] parameter is required and displays the alert content.
  /// The [type] parameter defaults to [AlertType.info].
  const MinimalAlert({
    Key? key,
    this.type = AlertType.info,
    this.title,
    required this.message,
    this.icon,
    this.showIcon = true,
    this.onClose,
    this.actions,
    this.closable = true,
    this.variant = AlertVariant.filled,
  }) : super(key: key);

  @override
  State<MinimalAlert> createState() => _MinimalAlertState();
}

class _MinimalAlertState extends State<MinimalAlert> {
  bool _isClosing = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Automatically focus the alert for keyboard accessibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Handles closing the alert
  void _handleClose() {
    if (!mounted) return;

    // If already closing, do nothing
    if (_isClosing) return;

    setState(() {
      _isClosing = true;
    });

    // Delay callback until animation completes
    Timer(const Duration(milliseconds: 200), () {
      if (widget.onClose != null && mounted) {
        widget.onClose!();
      }
    });
  }

  /// Handles key events for accessibility
  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape && widget.closable) {
        _handleClose();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final direction = Directionality.of(context);
    final isRTL = direction == TextDirection.rtl;

    // Get appropriate colors based on alert type and variant
    final backgroundColor = widget.type.getBackgroundColor(
      context,
      widget.variant,
      tokens,
    );
    final borderColor = widget.type.getBorderColor(
      context,
      widget.variant,
      tokens,
    );
    final textColor = widget.type.getTextColor(context, widget.variant, tokens);
    final iconColor = widget.type.getIconColor(context, widget.variant, tokens);

    // Use token-based typography and spacing
    final titleStyle = tokens.typographyTokens.labelMedium.copyWith(
      color: textColor,
      fontWeight: FontWeight.bold,
    );
    final messageStyle = tokens.typographyTokens.bodySmall.copyWith(
      color: textColor,
    );

    // Get the appropriate icon widget
    Widget? iconWidget;
    if (widget.showIcon) {
      if (widget.icon != null) {
        iconWidget = IconTheme(
          data: IconThemeData(color: iconColor, size: 20),
          child: widget.icon!,
        );
      } else {
        iconWidget = Icon(
          widget.type.icon,
          color: iconColor,
          size: 20,
          semanticLabel: widget.type.semanticLabel,
        );
      }
    }

    // Build close button if alert is closable
    Widget? closeButton;
    if (widget.closable) {
      closeButton = IconButton(
        icon: Icon(Icons.close, size: 18),
        color: textColor,
        padding: EdgeInsets.all(tokens.spacingTokens.xs),
        constraints: BoxConstraints.tightFor(
          width: tokens.spacingTokens.lg + tokens.spacingTokens.xs,
          height: tokens.spacingTokens.lg + tokens.spacingTokens.xs,
        ),
        splashRadius: 20,
        tooltip: 'Close',
        onPressed: _handleClose,
      );
    }

    return Focus(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      autofocus: true,
      child: Semantics(
        container: true,
        liveRegion: true,
        label: widget.type.semanticLabel,
        child: AnimatedOpacity(
          opacity: _isClosing ? 0.0 : 1.0,
          duration: tokens.motionTokens.sm,
          curve: tokens.motionTokens.standard,
          child: AnimatedContainer(
            duration: tokens.motionTokens.sm,
            curve: tokens.motionTokens.standard,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
              border: widget.variant == AlertVariant.outlined
                  ? Border.all(color: borderColor, width: 1)
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.all(tokens.spacingTokens.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (iconWidget != null && !isRTL) ...[
                        iconWidget,
                        SizedBox(width: tokens.spacingTokens.sm),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.title != null) ...[
                              Text(widget.title!, style: titleStyle),
                              SizedBox(height: tokens.spacingTokens.xs),
                            ],
                            Text(widget.message, style: messageStyle),
                          ],
                        ),
                      ),
                      if (iconWidget != null && isRTL) ...[
                        SizedBox(width: tokens.spacingTokens.sm),
                        iconWidget,
                      ],
                      if (closeButton != null) closeButton,
                    ],
                  ),
                  // Add action buttons if provided
                  if (widget.actions != null && widget.actions!.isNotEmpty) ...[
                    SizedBox(height: tokens.spacingTokens.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: widget.actions!
                          .map(
                            (action) => Padding(
                              padding: EdgeInsets.only(
                                left: tokens.spacingTokens.xs,
                              ),
                              child: action,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
