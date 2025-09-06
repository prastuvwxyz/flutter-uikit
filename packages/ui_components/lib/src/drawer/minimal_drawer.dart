import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_tokens/ui_tokens.dart';

/// A slide-out navigation panel component for primary navigation.
///
/// The drawer slides in from the side of the screen and provides
/// a space for navigation controls, settings, or supplementary content.
/// It supports RTL layouts, accessibility features, and configurable styling.
class MinimalDrawer extends StatefulWidget {
  /// The content to display inside the drawer.
  final Widget child;

  /// The width of the drawer. Defaults to 304.0.
  final double? width;

  /// The drawer's background color. If null, uses the surface color from the theme.
  final Color? backgroundColor;

  /// The z-coordinate at which to place the drawer. This controls the size of the shadow.
  final double? elevation;

  /// The shape of the drawer. If null, uses a rectangular border with rounded right corners.
  final ShapeBorder? shape;

  /// The semantic label for the drawer used by screen readers.
  final String? semanticLabel;

  /// The clipping behavior for the drawer content.
  final Clip clipBehavior;

  /// Creates a MinimalDrawer.
  ///
  /// The [child] argument is required and represents the content of the drawer.
  const MinimalDrawer({
    Key? key,
    required this.child,
    this.width,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.semanticLabel,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  @override
  MinimalDrawerState createState() => MinimalDrawerState();
}

class MinimalDrawerState extends State<MinimalDrawer>
    with SingleTickerProviderStateMixin {
  /// The animation controller for the drawer.
  late AnimationController controller;
  late Animation<double> _animation;
  FocusScopeNode? _focusScopeNode;
  FocusAttachment? _focusAttachment;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.addStatusListener(_handleStatusChange);

    _focusScopeNode = FocusScopeNode();
    _focusAttachment = _focusScopeNode?.attach(context);
  }

  @override
  void dispose() {
    controller.removeStatusListener(_handleStatusChange);
    controller.dispose();
    // detach focus attachment before disposing the scope
    _focusAttachment?.detach();
    _focusScopeNode?.dispose();
    super.dispose();
  }

  void _handleStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _focusScopeNode?.requestFocus();
    }
  }

  /// Opens the drawer with animation.
  void open() {
    controller.forward();
  }

  /// Closes the drawer with animation.
  void close() {
    controller.reverse();
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final UiTokens tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();

    // Use design tokens for styling
    final effectiveWidth = widget.width ?? 304.0;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? tokens.colorTokens.neutral[50];
    final effectiveElevation =
        widget.elevation ?? tokens.elevationTokens.level3;

    final effectiveShape =
        widget.shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
        );

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyPress,
      child: Stack(
        children: [
          // Scrim/backdrop - animate opacity with the controller
          GestureDetector(
            onTap: close,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => _animation.value > 0
                  ? Opacity(opacity: _animation.value, child: child)
                  : const SizedBox.shrink(),
              child: Container(color: Colors.black54),
            ),
          ),
          // Drawer
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final isRtl = Directionality.of(context) == TextDirection.rtl;
              final slideValue = _animation.value;
              return Transform.translate(
                offset: Offset(
                  isRtl
                      ? (slideValue - 1.0) * effectiveWidth
                      : (slideValue - 1.0) * effectiveWidth,
                  0.0,
                ),
                child: child,
              );
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: effectiveWidth,
                height: double.infinity,
                child: Material(
                  color: effectiveBackgroundColor,
                  elevation: effectiveElevation,
                  shape: effectiveShape,
                  clipBehavior: widget.clipBehavior,
                  child: SafeArea(
                    child: FocusScope(
                      node: _focusScopeNode!,
                      child: Semantics(
                        container: true,
                        label: widget.semanticLabel ?? 'Navigation drawer',
                        onDismiss: close,
                        child: Padding(
                          padding: EdgeInsets.all(tokens.spacingTokens.lg),
                          child: widget.child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
