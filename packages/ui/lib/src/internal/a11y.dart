import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// Accessibility utilities and helpers for the UI package.
///
/// This library provides helper functions and utilities to improve
/// accessibility across UI components, including semantic labels,
/// focus management, screen reader announcements, and keyboard navigation.

/// Helper class for accessibility utilities
class A11yUtils {
  A11yUtils._();

  /// Announce a message to screen readers
  ///
  /// This is useful for announcing state changes, form validation errors,
  /// or other important information that users should be aware of.
  static Future<void> announce(
    BuildContext context,
    String message, {
    TextDirection? textDirection,
    Assertiveness assertiveness = Assertiveness.polite,
  }) async {
    if (message.isEmpty) return;

    try {
      await SemanticsService.announce(
        message,
        textDirection ?? Directionality.of(context),
        assertiveness: assertiveness,
      );
    } catch (e) {
      // Ignore errors if semantics service is not available
      debugPrint('Failed to announce message: $message');
    }
  }

  /// Create a semantic label for interactive elements
  ///
  /// This helps create consistent and descriptive labels for buttons,
  /// form fields, and other interactive elements.
  static String createLabel({
    String? label,
    String? hint,
    String? value,
    bool isRequired = false,
    bool hasError = false,
    String? errorMessage,
  }) {
    final parts = <String>[];

    if (label != null && label.isNotEmpty) {
      parts.add(label);
    }

    if (isRequired) {
      parts.add('required');
    }

    if (value != null && value.isNotEmpty) {
      parts.add('current value: $value');
    }

    if (hasError && errorMessage != null && errorMessage.isNotEmpty) {
      parts.add('error: $errorMessage');
    } else if (hint != null && hint.isNotEmpty) {
      parts.add(hint);
    }

    return parts.join(', ');
  }

  /// Create semantic properties for form fields
  static SemanticsProperties createFormFieldSemantics({
    String? label,
    String? hint,
    String? value,
    bool isRequired = false,
    bool hasError = false,
    String? errorMessage,
    bool isObscured = false,
    bool isMultiline = false,
    bool isReadOnly = false,
  }) {
    return SemanticsProperties(
      label: createLabel(
        label: label,
        hint: hint,
        value: value,
        isRequired: isRequired,
        hasError: hasError,
        errorMessage: errorMessage,
      ),
      textField: true,
      obscured: isObscured,
      multiline: isMultiline,
      readOnly: isReadOnly,
      focused: false, // This should be managed by the widget
    );
  }

  /// Create semantic properties for buttons
  static SemanticsProperties createButtonSemantics({
    String? label,
    String? hint,
    bool isEnabled = true,
    bool isPressed = false,
    bool isLoading = false,
  }) {
    String effectiveLabel = label ?? '';

    if (isLoading) {
      effectiveLabel += (effectiveLabel.isEmpty ? '' : ', ') + 'loading';
    }

    if (hint != null && hint.isNotEmpty) {
      effectiveLabel += (effectiveLabel.isEmpty ? '' : ', ') + hint;
    }

    return SemanticsProperties(
      label: effectiveLabel,
      button: true,
      enabled: isEnabled,
      focused: isPressed,
    );
  }

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Check if reduce motion is enabled
  static bool isReduceMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get the appropriate duration for animations based on accessibility settings
  static Duration getAnimationDuration(
    BuildContext context,
    Duration normalDuration,
  ) {
    if (isReduceMotionEnabled(context)) {
      return Duration.zero;
    }
    return normalDuration;
  }

  /// Focus management utilities
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted && focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
    });
  }

  /// Dismiss focus if currently focused
  static void dismissFocus(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  /// Handle escape key for dismissible widgets
  static KeyEventResult handleEscapeKey({
    required KeyEvent event,
    required VoidCallback? onEscape,
  }) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape &&
        onEscape != null) {
      onEscape();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// Create focus traversal order
  static Widget createFocusTraversalOrder({
    required double order,
    required Widget child,
  }) {
    return FocusTraversalOrder(
      order: NumericFocusOrder(order),
      child: child,
    );
  }

  /// Create excludable focus for decorative elements
  static Widget excludeFromSemantics({
    required Widget child,
    bool excluding = true,
  }) {
    return ExcludeSemantics(
      excluding: excluding,
      child: child,
    );
  }

  /// Create semantic container for grouping related elements
  static Widget createSemanticContainer({
    required Widget child,
    String? label,
    String? hint,
    bool explicitChildNodes = false,
    bool liveRegion = false,
  }) {
    return Semantics(
      container: true,
      label: label,
      hint: hint,
      explicitChildNodes: explicitChildNodes,
      liveRegion: liveRegion,
      child: child,
    );
  }
}

/// Extension methods for easier accessibility support
extension A11yExtensions on BuildContext {
  /// Announce a message to screen readers
  Future<void> announce(
    String message, {
    Assertiveness assertiveness = Assertiveness.polite,
  }) {
    return A11yUtils.announce(this, message, assertiveness: assertiveness);
  }

  /// Check if screen reader is enabled
  bool get isScreenReaderEnabled => A11yUtils.isScreenReaderEnabled(this);

  /// Check if reduce motion is enabled
  bool get isReduceMotionEnabled => A11yUtils.isReduceMotionEnabled(this);

  /// Get animation duration with accessibility considerations
  Duration getA11yDuration(Duration normalDuration) {
    return A11yUtils.getAnimationDuration(this, normalDuration);
  }

  /// Dismiss current focus
  void dismissFocus() {
    A11yUtils.dismissFocus(this);
  }
}

/// Helper widget for managing focus and semantics
class A11yFocusableWidget extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// Focus node for the widget
  final FocusNode? focusNode;

  /// Whether the widget should auto-focus when created
  final bool autofocus;

  /// Callback for key events
  final FocusOnKeyEventCallback? onKey;

  /// Semantic label for the widget
  final String? semanticLabel;

  /// Semantic hint for the widget
  final String? semanticHint;

  /// Whether this is a semantic container
  final bool isContainer;

  /// Creates an A11yFocusableWidget
  const A11yFocusableWidget({
    super.key,
    required this.child,
    this.focusNode,
    this.autofocus = false,
    this.onKey,
    this.semanticLabel,
    this.semanticHint,
    this.isContainer = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    // Add focus management if needed
    if (focusNode != null || onKey != null || autofocus) {
      result = Focus(
        focusNode: focusNode,
        autofocus: autofocus,
        onKeyEvent: onKey,
        child: result,
      );
    }

    // Add semantic information if provided
    if (semanticLabel != null || semanticHint != null || isContainer) {
      result = Semantics(
        container: isContainer,
        label: semanticLabel,
        hint: semanticHint,
        child: result,
      );
    }

    return result;
  }
}

/// Helper widget for creating accessible form fields
class A11yFormField extends StatelessWidget {
  /// The form field widget
  final Widget child;

  /// Label for the field
  final String? label;

  /// Hint text for the field
  final String? hint;

  /// Current value of the field
  final String? value;

  /// Whether the field is required
  final bool isRequired;

  /// Whether the field has an error
  final bool hasError;

  /// Error message if any
  final String? errorMessage;

  /// Whether the field is obscured (password)
  final bool isObscured;

  /// Whether the field supports multiple lines
  final bool isMultiline;

  /// Whether the field is read-only
  final bool isReadOnly;

  /// Creates an A11yFormField
  const A11yFormField({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.value,
    this.isRequired = false,
    this.hasError = false,
    this.errorMessage,
    this.isObscured = false,
    this.isMultiline = false,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final semanticsProperties = A11yUtils.createFormFieldSemantics(
      label: label,
      hint: hint,
      value: value,
      isRequired: isRequired,
      hasError: hasError,
      errorMessage: errorMessage,
      isObscured: isObscured,
      isMultiline: isMultiline,
      isReadOnly: isReadOnly,
    );

    return Semantics.fromProperties(
      properties: semanticsProperties,
      child: child,
    );
  }
}

/// Accessibility focus management helper
class A11yFocusManager {
  static final Map<String, FocusNode> _focusNodes = {};

  /// Get or create a focus node with the given key
  static FocusNode getFocusNode(String key) {
    return _focusNodes.putIfAbsent(key, () => FocusNode());
  }

  /// Dispose a focus node and remove it from cache
  static void disposeFocusNode(String key) {
    final focusNode = _focusNodes.remove(key);
    focusNode?.dispose();
  }

  /// Dispose all cached focus nodes
  static void disposeAll() {
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    _focusNodes.clear();
  }

  /// Move focus to the next focusable element
  static void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Move focus to the previous focusable element
  static void focusPrevious(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }
}