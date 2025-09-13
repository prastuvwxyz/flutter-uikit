import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../internal/token_adapters.dart';
import '../internal/a11y.dart';

/// Defines available size options for Dialog
enum DialogSize {
  /// Small dialog (400px)
  sm,
  /// Medium dialog (560px) - default
  md,
  /// Large dialog (720px)
  lg,
  /// Extra large dialog (960px)
  xl,
  /// Full screen dialog
  fullscreen,
}

/// Extension to get width values for each dialog size
extension DialogSizeExtension on DialogSize {
  /// Returns the width in logical pixels for this dialog size
  double get width {
    switch (this) {
      case DialogSize.sm:
        return 400.0;
      case DialogSize.md:
        return 560.0;
      case DialogSize.lg:
        return 720.0;
      case DialogSize.xl:
        return 960.0;
      case DialogSize.fullscreen:
        return double.infinity;
    }
  }

  /// Returns if this dialog size is fullscreen
  bool get isFullscreen => this == DialogSize.fullscreen;
}

/// A modal dialog component for confirmations, forms, and custom content
/// with proper focus management and accessibility.
class CustomDialog extends StatefulWidget {
  /// The title of the dialog shown in the header
  final String? title;

  /// The main content widget of the dialog
  final Widget? content;

  /// List of action widgets, typically buttons, shown at the bottom
  final List<Widget>? actions;

  /// Optional icon widget displayed in the header next to the title
  final Widget? icon;

  /// The size of the dialog
  final DialogSize size;

  /// Whether the dialog can be dismissed by tapping outside
  final bool dismissible;

  /// Whether the content area should be scrollable
  final bool scrollable;

  /// The alignment of the dialog on the screen
  final Alignment alignment;

  /// Optional background color override for the dialog surface
  final Color? backgroundColor;

  /// Callback when the dialog is dismissed
  final VoidCallback? onDismiss;

  /// Whether to show a close button in the header
  final bool showCloseButton;

  const CustomDialog({
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
    this.showCloseButton = true,
  });

  /// Factory for confirmation dialog
  factory CustomDialog.confirmation({
    Key? key,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    Widget? icon,
    DialogSize size = DialogSize.sm,
    bool dismissible = true,
  }) {
    return CustomDialog(
      key: key,
      title: title,
      content: Text(message),
      icon: icon,
      size: size,
      dismissible: dismissible,
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Factory for alert dialog
  factory CustomDialog.alert({
    Key? key,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    Widget? icon,
    DialogSize size = DialogSize.sm,
  }) {
    return CustomDialog(
      key: key,
      title: title,
      content: Text(message),
      icon: icon,
      size: size,
      dismissible: false,
      actions: [
        ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Shows a CustomDialog as a modal
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
    bool showCloseButton = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      barrierColor: Colors.black.withValues(alpha: 0.54),
      routeSettings: routeSettings,
      builder: (BuildContext context) {
        return CustomDialog(
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
          showCloseButton: showCloseButton,
        );
      },
    );
  }

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  final FocusScopeNode _dialogFocusScope = FocusScopeNode();

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: TokenAdapters.durationFromTokens(TokenDuration.normal),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
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
      // Announce to screen readers using SemanticsService
      SystemSound.play(SystemSoundType.alert);
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
      if (mounted) {
        if (widget.onDismiss != null) {
          widget.onDismiss!();
        }
        Navigator.of(context).pop();
      }
    });
  }

  /// Build the dialog header with title and optional close button
  Widget _buildHeader(BuildContext context) {
    if (widget.title == null && widget.icon == null && !widget.showCloseButton) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: context.padding(
        horizontal: TokenSize.lg,
        top: TokenSize.lg,
        bottom: widget.content != null ? TokenSize.md : TokenSize.xs,
      ),
      decoration: BoxDecoration(
        border: widget.content != null || widget.actions != null
            ? Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          if (widget.icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              child: widget.icon!,
            ),
            SizedBox(width: context.spacing.md),
          ],
          if (widget.title != null)
            Expanded(
              child: Text(
                widget.title!,
                style: TokenAdapters.textStyleFromTokens(
                  tokenStyle: TokenTextStyle.headlineSmall,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (widget.showCloseButton)
            IconButton(
              onPressed: widget.dismissible ? _handleDismiss : null,
              icon: const Icon(Icons.close),
              iconSize: 20,
              padding: context.padding(all: TokenSize.xs),
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              tooltip: 'Close',
            ),
        ],
      ),
    );
  }

  /// Build the dialog content area
  Widget _buildContent(BuildContext context) {
    if (widget.content == null) return const SizedBox.shrink();

    final contentWidget = Padding(
      padding: context.padding(
        horizontal: TokenSize.lg,
        vertical: (widget.title == null && widget.icon == null) ? TokenSize.lg : TokenSize.md,
      ),
      child: DefaultTextStyle(
        style: TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.bodyMedium,
        ),
        child: widget.content!,
      ),
    );

    if (widget.scrollable) {
      return Flexible(
        child: SingleChildScrollView(
          child: contentWidget,
        ),
      );
    }

    return contentWidget;
  }

  /// Build the dialog actions area
  Widget _buildActions(BuildContext context) {
    if (widget.actions == null || widget.actions!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: context.padding(all: TokenSize.lg),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widget.actions!
            .map((action) => Padding(
                  padding: EdgeInsets.only(left: context.spacing.sm),
                  child: action,
                ))
            .toList(),
      ),
    );
  }

  /// Handle keyboard events
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.escape:
        if (widget.dismissible) {
          _handleDismiss();
          return KeyEventResult.handled;
        }
        break;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isFullscreen = widget.size.isFullscreen;
    final dialogWidth = isFullscreen ? mediaQuery.size.width : widget.size.width;
    final dialogHeight = isFullscreen ? mediaQuery.size.height : null;

    return A11yFocusableWidget(
      focusNode: _dialogFocusScope,
      autofocus: true,
      semanticLabel: widget.title,
      isContainer: true,
      onKey: (node, event) => _handleKeyEvent(event),
      child: GestureDetector(
        onTap: widget.dismissible ? _handleDismiss : null,
        behavior: HitTestBehavior.opaque,
        child: GestureDetector(
          onTap: () {}, // Prevent clicks from passing through to barrier
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(_scaleAnimation),
                  child: child,
                ),
              );
            },
            child: Material(
              type: MaterialType.card,
              color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
              elevation: 24, // High elevation for modal dialog
              shape: isFullscreen
                  ? null
                  : RoundedRectangleBorder(
                      borderRadius: context.borderRadius(all: TokenRadiusSize.lg),
                    ),
              child: Container(
                width: dialogWidth,
                height: dialogHeight,
                constraints: BoxConstraints(
                  maxWidth: isFullscreen ? double.infinity : widget.size.width,
                  maxHeight: dialogHeight ?? mediaQuery.size.height * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context),
                    _buildContent(context),
                    _buildActions(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Utility class for common dialog patterns
class DialogUtils {
  /// Show a confirmation dialog
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Widget? icon,
    DialogSize size = DialogSize.sm,
  }) async {
    return await CustomDialog.show<bool>(
      context: context,
      title: title,
      content: Text(message),
      icon: icon,
      size: size,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Show an alert dialog
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    Widget? icon,
    DialogSize size = DialogSize.sm,
  }) async {
    await CustomDialog.show(
      context: context,
      title: title,
      content: Text(message),
      icon: icon,
      size: size,
      dismissible: false,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Show a loading dialog
  static Future<void> showLoading({
    required BuildContext context,
    String message = 'Loading...',
  }) async {
    await CustomDialog.show(
      context: context,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(width: context.spacing.md),
          Text(message),
        ],
      ),
      size: DialogSize.sm,
      dismissible: false,
      showCloseButton: false,
    );
  }
}