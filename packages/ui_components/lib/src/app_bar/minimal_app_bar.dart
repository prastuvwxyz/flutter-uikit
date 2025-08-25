import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_tokens/ui_tokens.dart';

/// A responsive application bar component with configurable appearance and behavior.
///
/// The [MinimalAppBar] provides a platform-adaptive header for applications
/// with support for navigation, title, actions, and responsive behavior across platforms.
/// It follows Material Design and Cupertino style guidelines based on the target platform.
class MinimalAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// The widget displayed in the center/left of the app bar.
  final Widget? title;

  /// A widget to display before the title.
  /// Typically a [BackButton] or a [IconButton] with a menu icon.
  /// If null and [automaticallyImplyLeading] is true, a platform-appropriate
  /// back button is shown when appropriate.
  final Widget? leading;

  /// List of widgets to display in a row after the title.
  /// Typically these are [IconButton]s representing common operations.
  final List<Widget>? actions;

  /// Background color of the app bar.
  /// If null, uses the theme's app bar theme color.
  final Color? backgroundColor;

  /// The color used for the app bar's text and icons.
  /// If null, uses the theme's app bar theme foreground color.
  final Color? foregroundColor;

  /// The elevation of the app bar shadow.
  /// If null, the default elevation is used.
  final double? elevation;

  /// Whether the title should be centered.
  /// Defaults to true on iOS and false on Android when null.
  final bool? centerTitle;

  /// The spacing around the title content on the horizontal axis.
  /// If null, uses default spacing.
  final double? titleSpacing;

  /// The height of the app bar's toolbar section.
  /// Defaults to 56.0.
  final double toolbarHeight;

  /// A widget to display at the bottom of the app bar.
  /// Typically a [TabBar] or progress indicator.
  final PreferredSizeWidget? bottom;

  /// A widget displayed behind the toolbar and the bottom widget.
  /// Typically used for implementing collapsible/expandable app bars.
  final Widget? flexibleSpace;

  /// Callback when the leading widget is pressed.
  /// If null and automatic back button is used, Navigator.pop is called.
  final VoidCallback? onLeadingPressed;

  /// Whether to automatically add a back button if available.
  /// If leading is null and this is true, the app bar will check if there
  /// is a previous route and show a back button if there is.
  final bool automaticallyImplyLeading;

  /// Creates a [MinimalAppBar] component.
  ///
  /// The [toolbarHeight] argument defaults to 56.0.
  /// The [automaticallyImplyLeading] argument defaults to true.
  const MinimalAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle,
    this.titleSpacing,
    this.toolbarHeight = 56.0,
    this.bottom,
    this.flexibleSpace,
    this.onLeadingPressed,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  State<MinimalAppBar> createState() => _MinimalAppBarState();

  @override
  Size get preferredSize {
    return Size.fromHeight(
      toolbarHeight + (bottom?.preferredSize.height ?? 0.0),
    );
  }
}

class _MinimalAppBarState extends State<MinimalAppBar> {
  bool _scrolledUnder = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<UiTokens>() ?? UiTokens.standard();
    final colorScheme = theme.colorScheme;
    final appBarTheme = theme.appBarTheme;
    final isLight = theme.brightness == Brightness.light;

    // Determine if we should automatically show a back button
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final bool showLeadingButton = widget.automaticallyImplyLeading && canPop;

    // Determine actual foreground and background colors
    final backgroundColor =
        widget.backgroundColor ??
        appBarTheme.backgroundColor ??
        (isLight ? colorScheme.surface : colorScheme.surface);

    final foregroundColor =
        widget.foregroundColor ??
        appBarTheme.foregroundColor ??
        (isLight ? colorScheme.onSurface : colorScheme.onSurface);

    // Handle platform-specific behavior
    final platformIOS =
        Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    // Center title based on platform if not explicitly specified
    final bool effectiveCenterTitle = widget.centerTitle ?? platformIOS;

    // Effective elevation with scroll adjustment
    final double effectiveElevation = _scrolledUnder
        ? (widget.elevation ??
              appBarTheme.elevation ??
              tokens.elevationTokens.level1)
        : (widget.elevation ?? appBarTheme.elevation ?? 0.0);

    // Build the leading widget
    Widget? leadingWidget;
    if (widget.leading != null) {
      leadingWidget = widget.leading;
    } else if (showLeadingButton) {
      // Show back or close button
      leadingWidget = useCloseButton
          ? IconButton(
              icon: const Icon(Icons.close),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed:
                  widget.onLeadingPressed ??
                  () => Navigator.of(context).maybePop(),
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed:
                  widget.onLeadingPressed ??
                  () => Navigator.of(context).maybePop(),
            );
    }

    // Build the app bar
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final scrolledUnder =
            notification.depth == 0 &&
            notification is ScrollUpdateNotification &&
            notification.metrics.pixels > 0;

        if (_scrolledUnder != scrolledUnder) {
          setState(() {
            _scrolledUnder = scrolledUnder;
          });
        }
        return false;
      },
      child: AppBar(
        key: widget.key,
        leading: leadingWidget,
        automaticallyImplyLeading: false, // We handle this ourselves
        title: widget.title,
        actions: widget.actions,
        flexibleSpace: widget.flexibleSpace,
        bottom: widget.bottom,
        elevation: effectiveElevation,
        scrolledUnderElevation: tokens.elevationTokens.level1,
        titleSpacing: widget.titleSpacing,
        centerTitle: effectiveCenterTitle,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
          statusBarBrightness: isLight ? Brightness.light : Brightness.dark,
        ),
        toolbarHeight: widget.toolbarHeight,
        leadingWidth: widget.leading != null
            ? null
            : (platformIOS ? 56.0 : null),
        titleTextStyle: tokens.typographyTokens.headlineSmall,
        shape: _scrolledUnder
            ? null
            : const Border(
                bottom: BorderSide(color: Colors.transparent, width: 0.0),
              ),
      ),
    );
  }
}
