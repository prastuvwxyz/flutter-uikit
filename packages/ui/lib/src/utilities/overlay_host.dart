import 'dart:async';
import 'package:flutter/material.dart';
import '../internal/a11y.dart';
import '../internal/token_adapters.dart';

/// Types of overlays that can be managed
enum OverlayType {
  dialog,
  modal,
  popup,
  snackbar,
  tooltip,
  drawer,
  bottomSheet,
  notification,
}

/// Priority levels for overlay stacking
enum OverlayPriority {
  low(100),
  normal(200),
  high(300),
  critical(400);

  const OverlayPriority(this.level);
  final int level;
}

/// Configuration for overlay animations
class OverlayAnimationConfig {
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;
  final Curve reverseCurve;

  const OverlayAnimationConfig({
    this.duration = const Duration(milliseconds: 250),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
  });

  static const OverlayAnimationConfig fast = OverlayAnimationConfig(
    duration: Duration(milliseconds: 150),
    reverseDuration: Duration(milliseconds: 100),
  );

  static const OverlayAnimationConfig slow = OverlayAnimationConfig(
    duration: Duration(milliseconds: 400),
    reverseDuration: Duration(milliseconds: 300),
  );
}

/// Configuration for an overlay entry
class OverlayConfig {
  final String id;
  final OverlayType type;
  final OverlayPriority priority;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool maintainState;
  final bool opaque;
  final OverlayAnimationConfig animation;
  final VoidCallback? onDismiss;

  const OverlayConfig({
    required this.id,
    required this.type,
    this.priority = OverlayPriority.normal,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = false,
    this.opaque = false,
    this.animation = const OverlayAnimationConfig(),
    this.onDismiss,
  });
}

/// Widget builder function for overlay content
typedef OverlayBuilder = Widget Function(BuildContext context, OverlayController controller);

/// Controller for managing individual overlay state
class OverlayController {
  final String id;
  final OverlayConfig config;
  final Completer<void> _dismissCompleter = Completer<void>();

  AnimationController? _animationController;
  Animation<double>? _animation;
  OverlayEntry? _overlayEntry;
  bool _isDismissed = false;

  OverlayController({
    required this.id,
    required this.config,
  });

  /// Future that completes when overlay is dismissed
  Future<void> get dismissed => _dismissCompleter.future;

  /// Whether the overlay is currently dismissed
  bool get isDismissed => _isDismissed;

  /// Animation value (0.0 = hidden, 1.0 = fully visible)
  double get animationValue => _animation?.value ?? 0.0;

  /// Animation object for custom animations
  Animation<double>? get animation => _animation;

  /// Animation controller for advanced usage
  AnimationController? get animationController => _animationController;

  /// Dismiss the overlay
  void dismiss([Object? result]) {
    if (_isDismissed) return;

    _isDismissed = true;
    config.onDismiss?.call();

    if (!_dismissCompleter.isCompleted) {
      _dismissCompleter.complete(result);
    }

    OverlayHost.instance._dismissOverlay(id);
  }

  /// Update the overlay content
  void update() {
    _overlayEntry?.markNeedsBuild();
  }

  /// Initialize animation controller
  void _initAnimation(TickerProvider vsync) {
    _animationController = AnimationController(
      duration: config.animation.duration,
      reverseDuration: config.animation.reverseDuration,
      vsync: vsync,
    );

    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: config.animation.curve,
      reverseCurve: config.animation.reverseCurve,
    );
  }

  /// Dispose resources
  void _dispose() {
    _animationController?.dispose();
    _animationController = null;
    _animation = null;
  }
}

/// Host widget for managing overlays in the widget tree
class OverlayHost extends StatefulWidget {
  final Widget child;

  const OverlayHost({
    super.key,
    required this.child,
  });

  static OverlayHostState? _instance;
  static OverlayHostState get instance {
    assert(_instance != null, 'OverlayHost must be present in the widget tree');
    return _instance!;
  }

  /// Show an overlay with the given configuration
  static Future<T?> show<T>({
    required String id,
    required OverlayBuilder builder,
    required OverlayConfig config,
  }) {
    return instance._showOverlay<T>(id: id, builder: builder, config: config);
  }

  /// Dismiss an overlay by ID
  static void dismiss(String id) {
    instance._dismissOverlay(id);
  }

  /// Dismiss all overlays
  static void dismissAll() {
    instance._dismissAllOverlays();
  }

  /// Check if an overlay is currently shown
  static bool isShown(String id) {
    return instance._isOverlayShown(id);
  }

  /// Get list of currently active overlay IDs
  static List<String> getActiveOverlays() {
    return instance._getActiveOverlayIds();
  }

  @override
  State<OverlayHost> createState() => OverlayHostState();
}

/// State class for OverlayHost
class OverlayHostState extends State<OverlayHost> with TickerProviderStateMixin {
  final Map<String, OverlayController> _controllers = {};
  final Map<String, OverlayBuilder> _builders = {};

  @override
  void initState() {
    super.initState();
    OverlayHost._instance = this;
  }

  @override
  void dispose() {
    // Clean up all controllers
    for (final controller in _controllers.values) {
      controller._dispose();
    }
    _controllers.clear();
    _builders.clear();

    if (OverlayHost._instance == this) {
      OverlayHost._instance = null;
    }
    super.dispose();
  }

  /// Show an overlay
  Future<T?> _showOverlay<T>({
    required String id,
    required OverlayBuilder builder,
    required OverlayConfig config,
  }) async {
    // Dismiss existing overlay with same ID
    _dismissOverlay(id);

    // Create controller
    final controller = OverlayController(id: id, config: config);
    controller._initAnimation(this);

    _controllers[id] = controller;
    _builders[id] = builder;

    // Create overlay entry
    final overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlay(context, controller),
      maintainState: config.maintainState,
      opaque: config.opaque,
    );

    controller._overlayEntry = overlayEntry;

    // Insert overlay
    final overlay = Overlay.of(context);
    overlay.insert(overlayEntry);

    // Start animation
    await controller._animationController?.forward();

    // Wait for dismissal and return result
    try {
      final result = await controller.dismissed;
      return result as T?;
    } finally {
      _cleanup(id);
    }
  }

  /// Dismiss an overlay
  void _dismissOverlay(String id) {
    final controller = _controllers[id];
    if (controller == null || controller.isDismissed) return;

    controller.dismiss();
  }

  /// Dismiss all overlays
  void _dismissAllOverlays() {
    final ids = List<String>.from(_controllers.keys);
    for (final id in ids) {
      _dismissOverlay(id);
    }
  }

  /// Check if overlay is shown
  bool _isOverlayShown(String id) {
    return _controllers.containsKey(id) && !_controllers[id]!.isDismissed;
  }

  /// Get active overlay IDs
  List<String> _getActiveOverlayIds() {
    return _controllers.entries
        .where((entry) => !entry.value.isDismissed)
        .map((entry) => entry.key)
        .toList();
  }


  /// Build overlay widget
  Widget _buildOverlay(BuildContext context, OverlayController controller) {
    final builder = _builders[controller.id];
    if (builder == null) return const SizedBox.shrink();

    Widget overlay = builder(context, controller);

    // Add animation wrapper
    if (controller._animation != null) {
      overlay = AnimatedBuilder(
        animation: controller._animation!,
        builder: (context, child) => _buildAnimatedOverlay(context, child!, controller),
        child: overlay,
      );
    }

    // Add barrier if needed
    if (controller.config.barrierColor != null || controller.config.barrierDismissible) {
      overlay = _buildWithBarrier(overlay, controller);
    }

    // Add semantic information
    overlay = A11yUtils.createSemanticContainer(
      label: controller.config.barrierLabel ?? '${controller.config.type.name} overlay',
      liveRegion: controller.config.type == OverlayType.notification,
      child: overlay,
    );

    // Handle escape key for dismissible overlays
    if (controller.config.barrierDismissible) {
      overlay = Focus(
        autofocus: true,
        onKeyEvent: (node, event) => A11yUtils.handleEscapeKey(
          event: event,
          onEscape: () => controller.dismiss(),
        ),
        child: overlay,
      );
    }

    return overlay;
  }

  /// Build animated overlay wrapper
  Widget _buildAnimatedOverlay(BuildContext context, Widget child, OverlayController controller) {
    final animation = controller._animation!;

    switch (controller.config.type) {
      case OverlayType.dialog:
      case OverlayType.modal:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case OverlayType.snackbar:
      case OverlayType.notification:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case OverlayType.bottomSheet:
      case OverlayType.drawer:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case OverlayType.popup:
      case OverlayType.tooltip:
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
            child: child,
          ),
        );
    }
  }

  /// Build overlay with barrier
  Widget _buildWithBarrier(Widget overlay, OverlayController controller) {
    return Stack(
      children: [
        // Barrier
        if (controller.config.barrierColor != null)
          AnimatedBuilder(
            animation: controller._animation!,
            builder: (context, child) => Container(
              color: controller.config.barrierColor!.withValues(
                alpha: controller.config.barrierColor!.a * controller.animationValue,
              ),
            ),
          ),

        // Dismissible barrier
        if (controller.config.barrierDismissible)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => controller.dismiss(),
              child: const SizedBox.expand(),
            ),
          ),

        // Overlay content
        overlay,
      ],
    );
  }

  /// Cleanup overlay resources
  Future<void> _cleanup(String id) async {
    final controller = _controllers[id];
    if (controller == null) return;

    // Animate out
    await controller._animationController?.reverse();

    // Remove from overlay
    controller._overlayEntry?.remove();

    // Dispose controller
    controller._dispose();

    // Remove from maps
    _controllers.remove(id);
    _builders.remove(id);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension methods for easy overlay access
extension OverlayHostExtensions on BuildContext {
  /// Show a dialog overlay
  Future<T?> showDialog<T>({
    required String id,
    required OverlayBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    OverlayPriority priority = OverlayPriority.high,
    VoidCallback? onDismiss,
  }) {
    return OverlayHost.show<T>(
      id: id,
      builder: builder,
      config: OverlayConfig(
        id: id,
        type: OverlayType.dialog,
        priority: priority,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor ?? Colors.black54,
        barrierLabel: barrierLabel,
        onDismiss: onDismiss,
      ),
    );
  }

  /// Show a snackbar overlay
  Future<T?> showSnackbar<T>({
    required String id,
    required OverlayBuilder builder,
    Duration? autoHideDuration,
    OverlayPriority priority = OverlayPriority.normal,
    VoidCallback? onDismiss,
  }) {
    final future = OverlayHost.show<T>(
      id: id,
      builder: builder,
      config: OverlayConfig(
        id: id,
        type: OverlayType.snackbar,
        priority: priority,
        barrierDismissible: false,
        animation: OverlayAnimationConfig.fast,
        onDismiss: onDismiss,
      ),
    );

    // Auto-hide after duration
    if (autoHideDuration != null) {
      Timer(autoHideDuration, () => OverlayHost.dismiss(id));
    }

    return future;
  }

  /// Show a tooltip overlay
  Future<T?> showTooltip<T>({
    required String id,
    required OverlayBuilder builder,
    Duration? autoHideDuration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    final future = OverlayHost.show<T>(
      id: id,
      builder: builder,
      config: OverlayConfig(
        id: id,
        type: OverlayType.tooltip,
        priority: OverlayPriority.low,
        barrierDismissible: true,
        animation: OverlayAnimationConfig.fast,
        onDismiss: onDismiss,
      ),
    );

    // Auto-hide after duration
    if (autoHideDuration != null) {
      Timer(autoHideDuration, () => OverlayHost.dismiss(id));
    }

    return future;
  }

  /// Show a bottom sheet overlay
  Future<T?> showBottomSheet<T>({
    required String id,
    required OverlayBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    OverlayPriority priority = OverlayPriority.high,
    VoidCallback? onDismiss,
  }) {
    return OverlayHost.show<T>(
      id: id,
      builder: builder,
      config: OverlayConfig(
        id: id,
        type: OverlayType.bottomSheet,
        priority: priority,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor ?? Colors.black54,
        onDismiss: onDismiss,
      ),
    );
  }
}

/// Utility methods for common overlay operations
class OverlayUtils {
  OverlayUtils._();

  /// Show a simple confirmation dialog
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool destructive = false,
  }) async {
    final result = await context.showDialog<bool>(
      id: 'confirm_dialog_${DateTime.now().millisecondsSinceEpoch}',
      builder: (context, controller) => _buildConfirmDialog(
        context,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        destructive: destructive,
        onConfirm: () => controller.dismiss(true),
        onCancel: () => controller.dismiss(false),
      ),
    );

    return result ?? false;
  }

  /// Show a simple info snackbar
  static void showSnackbar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    OverlayType type = OverlayType.snackbar,
  }) {
    context.showSnackbar(
      id: 'snackbar_${DateTime.now().millisecondsSinceEpoch}',
      autoHideDuration: duration,
      builder: (context, controller) => _buildSimpleSnackbar(context, message, controller),
    );
  }

  static Widget _buildConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    required bool destructive,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return Center(
      child: Container(
        margin: context.padding(all: TokenSize.md),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Material(
          borderRadius: context.borderRadius(all: TokenRadiusSize.md),
          child: Padding(
            padding: context.padding(all: TokenSize.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TokenAdapters.textStyleFromTokens(
                    tokenStyle: TokenTextStyle.titleLarge,
                  ),
                ),
                SizedBox(height: context.spacing.sm),
                Text(
                  message,
                  style: TokenAdapters.textStyleFromTokens(
                    tokenStyle: TokenTextStyle.bodyMedium,
                  ),
                ),
                SizedBox(height: context.spacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onCancel,
                      child: Text(cancelText),
                    ),
                    SizedBox(width: context.spacing.sm),
                    ElevatedButton(
                      onPressed: onConfirm,
                      style: destructive
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.error,
                              foregroundColor: Theme.of(context).colorScheme.onError,
                            )
                          : null,
                      child: Text(confirmText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildSimpleSnackbar(
    BuildContext context,
    String message,
    OverlayController controller,
  ) {
    return Positioned(
      top: MediaQuery.of(context).viewPadding.top + 16,
      left: 16,
      right: 16,
      child: Material(
        borderRadius: context.borderRadius(all: TokenRadiusSize.sm),
        color: Theme.of(context).colorScheme.inverseSurface,
        child: Padding(
          padding: context.padding(all: TokenSize.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TokenAdapters.textStyleFromTokens(
                    tokenStyle: TokenTextStyle.bodyMedium,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => controller.dismiss(),
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}