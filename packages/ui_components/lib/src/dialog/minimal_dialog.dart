import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'dialog_types.dart';

/// A modal dialog component for confirmations, forms, and custom content
/// with proper focus management and accessibility.
///
/// [MinimalDialog] provides a consistent, accessible dialog experience across
/// platforms with support for various sizes, scrollable content, and proper
/// keyboard navigation.
///
/// Example:
/// ```dart
/// MinimalDialog(
///   title: 'Confirm Action',
///   content: Text('Are you sure you want to proceed?'),
///   actions: [
///     TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
///     ElevatedButton(onPressed: () {}, child: Text('Confirm')),
///   ],
/// )
/// ```
class MinimalDialog extends StatefulWidget {
  /// The title of the dialog shown in the header.
  final String? title;

  /// The main content widget of the dialog.
  final Widget? content;

  /// List of action widgets, typically buttons, shown at the bottom of the dialog.
  final List<Widget>? actions;

  /// Optional icon widget displayed in the header next to the title.
  final Widget? icon;

  /// The size of the dialog (sm, md, lg, xl, or fullscreen).
  final DialogSize size;

  /// Whether the dialog can be dismissed by tapping outside.
  final bool dismissible;

  /// Whether the content area should be scrollable.
  final bool scrollable;

  /// The alignment of the dialog on the screen.
  final Alignment alignment;

  /// Optional background color override for the dialog surface.
  final Color? backgroundColor;

  /// Callback when the dialog is dismissed.
  final VoidCallback? onDismiss;

  /// Creates a [MinimalDialog].
  ///
  /// The [size] defaults to [DialogSize.md], [dismissible] defaults to true,
  /// [scrollable] defaults to false, and [alignment] defaults to [Alignment.center].
  const MinimalDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.icon,
    this.size = DialogSize.md,
    this.dismissible = true,
    this.scrollable = false,
    this.alignment = Alignment.center,
    this.backgroundColor,
    this.onDismiss,
  });

  /// Shows a [MinimalDialog] as a modal.
  ///
  /// This is a convenience method to display the dialog using [showDialog].
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? content,
    List<Widget>? actions,
    Widget? icon,
    DialogSize size = DialogSize.md,
    bool dismissible = true,
    bool scrollable = false,
    Alignment alignment = Alignment.center,
    Color? backgroundColor,
    VoidCallback? onDismiss,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      barrierColor: Colors.black54, // Standard scrim color
      routeSettings: routeSettings,
      builder: (BuildContext context) {
        return MinimalDialog(
          title: title,
          content: content,
          actions: actions,
          icon: icon,
          size: size,
          dismissible: dismissible,
          scrollable: scrollable,
          alignment: alignment,
          backgroundColor: backgroundColor,
          onDismiss: onDismiss,
        );
      },
    );
  }

  @override
  State<MinimalDialog> createState() => _MinimalDialogState();
}

class _MinimalDialogState extends State<MinimalDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  final FocusScopeNode _dialogFocusScope = FocusScopeNode();
  final GlobalKey _initialFocusKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Start opening animation
    _animationController.forward();

    // Announce dialog to screen readers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SemanticsService.announce(
        widget.title ?? 'Dialog opened',
        TextDirection.ltr,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dialogFocusScope.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    if (!widget.dismissible) return;

    _animationController.reverse().then((_) {
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
      Navigator.of(context).pop();
    });
  }

  Widget _buildTitle(BuildContext context, UiTokens tokens) {
    if (widget.title == null && widget.icon == null)
      return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        left: tokens.spacingTokens.lg,
        right: tokens.spacingTokens.lg,
        top: tokens.spacingTokens.lg,
        bottom: widget.content != null ? tokens.spacingTokens.md : 0,
      ),
      child: Row(
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            SizedBox(width: tokens.spacingTokens.md),
          ],
          if (widget.title != null)
            Expanded(
              child: Text(
                widget.title!,
                style: tokens.typographyTokens.headlineSmall,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, UiTokens tokens) {
    if (widget.content == null) return const SizedBox.shrink();

    final contentWidget = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacingTokens.lg,
        vertical: widget.title == null ? tokens.spacingTokens.lg : 0,
      ),
      child: DefaultTextStyle(
        style: tokens.typographyTokens.bodyMedium,
        child: widget.content!,
      ),
    );

    if (widget.scrollable) {
      return Flexible(child: SingleChildScrollView(child: contentWidget));
    }

    return contentWidget;
  }

  Widget _buildActions(BuildContext context, UiTokens tokens) {
    if (widget.actions == null || widget.actions!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(tokens.spacingTokens.lg),
      child: ButtonBar(
        alignment: MainAxisAlignment.end,
        buttonPadding: EdgeInsets.symmetric(
          horizontal: tokens.spacingTokens.md,
        ),
        children: widget.actions!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final mediaQuery = MediaQuery.of(context);
    final isFullscreen = widget.size == DialogSize.fullscreen;
    final dialogWidth = isFullscreen
        ? mediaQuery.size.width
        : widget.size.width;
    final dialogHeight = isFullscreen ? mediaQuery.size.height : null;

    // Handle keyboard shortcuts (Escape to close)
    return FocusScope(
      node: _dialogFocusScope,
      autofocus: true,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape &&
              widget.dismissible) {
            _handleDismiss();
          }
        },
        child: GestureDetector(
          onTap: () {}, // Prevent clicks from passing through
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: 0.95 + (_scaleAnimation.value * 0.05),
                  child: child,
                ),
              );
            },
            child: Dialog(
              alignment: widget.alignment,
              insetPadding: isFullscreen
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: tokens.spacingTokens.xl),
              backgroundColor: widget.backgroundColor ?? Colors.white,
              elevation: tokens.elevationTokens.level3,
              shape: isFullscreen
                  ? null
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        tokens.radiusTokens.lg,
                      ),
                      side: BorderSide(color: Colors.grey[300]!, width: 1.0),
                    ),
              child: SizedBox(
                width: dialogWidth,
                height: dialogHeight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: dialogHeight ?? mediaQuery.size.height * 0.85,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Focus(
                        key: _initialFocusKey,
                        autofocus: true,
                        child: _buildTitle(context, tokens),
                      ),
                      _buildContent(context, tokens),
                      _buildActions(context, tokens),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
