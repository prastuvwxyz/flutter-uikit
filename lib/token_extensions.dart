import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'package:ui_components/ui_components.dart';

/// Extension on BuildContext to easily access UiTokens
extension TokenContextExtension on BuildContext {
  /// Get the UiTokens from the current theme
  UiTokens get tokens =>
      Theme.of(this).extension<UiTokens>() ?? UiTokens.standard();
}

/// Helper class for accessing color tokens
class MinimalColors {
  final BuildContext _context;

  /// Create MinimalColors with context
  MinimalColors._(this._context);

  /// Access MinimalColors from a BuildContext
  static MinimalColors of(BuildContext context) => MinimalColors._(context);

  /// Primary color
  Color get primary => _context.tokens.colorTokens.primary.shade500;

  /// Secondary color
  Color get secondary => _context.tokens.colorTokens.secondary.shade500;

  /// Tertiary color
  Color get tertiary => _context.tokens.colorTokens.tertiary.shade500;

  /// Error color
  Color get error => _context.tokens.colorTokens.error[500]!;

  /// Surface color
  Color get surface => Colors.white;

  /// On surface color
  Color get onSurface => Colors.black87;

  /// On surface variant color
  Color get onSurfaceVariant => Colors.black54;

  /// Surface container highest
  Color get surfaceContainerHighest => Colors.grey[200]!;

  /// Outline color
  Color get outline => Colors.grey[400]!;
}

/// Helper class for accessing spacing tokens
class MinimalSpacing {
  /// Extra small spacing (4px)
  static const double xs = 4;

  /// Small spacing (8px)
  static const double sm = 8;

  /// Medium spacing (16px)
  static const double md = 16;

  /// Large spacing (24px)
  static const double lg = 24;

  /// Extra large spacing (32px)
  static const double xl = 32;

  /// Extra small vertical spacing
  static const Widget xsVertical = SizedBox(height: xs);

  /// Small vertical spacing
  static const Widget smVertical = SizedBox(height: sm);

  /// Medium vertical spacing
  static const Widget mdVertical = SizedBox(height: md);

  /// Large vertical spacing
  static const Widget lgVertical = SizedBox(height: lg);

  /// Extra large vertical spacing
  static const Widget xlVertical = SizedBox(height: xl);

  /// Extra small horizontal spacing
  static const Widget xsHorizontal = SizedBox(width: xs);

  /// Small horizontal spacing
  static const Widget smHorizontal = SizedBox(width: sm);

  /// Medium horizontal spacing
  static const Widget mdHorizontal = SizedBox(width: md);

  /// Large horizontal spacing
  static const Widget lgHorizontal = SizedBox(width: lg);

  /// Extra large horizontal spacing
  static const Widget xlHorizontal = SizedBox(width: xl);
}

/// Button size enum that matches the API used in main.dart
enum MinimalButtonSize {
  /// Small button size
  small,

  /// Medium button size (default)
  medium,

  /// Large button size
  large,
}

/// Extension to convert MinimalButtonSize to ButtonSize
extension MinimalButtonSizeExtension on MinimalButtonSize {
  /// Convert to ButtonSize
  ButtonSize toButtonSize() {
    switch (this) {
      case MinimalButtonSize.small:
        return ButtonSize.sm;
      case MinimalButtonSize.medium:
        return ButtonSize.md;
      case MinimalButtonSize.large:
        return ButtonSize.lg;
    }
  }
}

/// Extension methods for MinimalButton to provide a more fluent API
extension MinimalButtonExtension on MinimalButton {
  /// Creates a filled (primary) button
  static MinimalButton filled({
    required VoidCallback? onPressed,
    required Widget child,
    MinimalButtonSize size = MinimalButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? icon,
  }) {
    return MinimalButton(
      variant: ButtonVariant.primary,
      onPressed: onPressed,
      child: child,
      size: size.toButtonSize(),
      isLoading: isLoading,
      fullWidth: isFullWidth,
      leading: icon,
    );
  }

  /// Creates an outlined (secondary) button
  static MinimalButton outlined({
    required VoidCallback? onPressed,
    required Widget child,
    MinimalButtonSize size = MinimalButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return MinimalButton(
      variant: ButtonVariant.secondary,
      onPressed: onPressed,
      child: child,
      size: size.toButtonSize(),
      isLoading: isLoading,
      fullWidth: isFullWidth,
    );
  }

  /// Creates a text button (ghost)
  static MinimalButton text({
    required VoidCallback? onPressed,
    required Widget child,
    MinimalButtonSize size = MinimalButtonSize.medium,
    bool isLoading = false,
  }) {
    return MinimalButton(
      variant: ButtonVariant.ghost,
      onPressed: onPressed,
      child: child,
      size: size.toButtonSize(),
      isLoading: isLoading,
    );
  }

  /// Creates a ghost button
  static MinimalButton ghost({
    required VoidCallback? onPressed,
    required Widget child,
    MinimalButtonSize size = MinimalButtonSize.medium,
    bool isLoading = false,
  }) {
    return MinimalButton(
      variant: ButtonVariant.ghost,
      onPressed: onPressed,
      child: child,
      size: size.toButtonSize(),
      isLoading: isLoading,
    );
  }

  /// Creates a button with an icon
  static MinimalButton icon({
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    ButtonVariant variant = ButtonVariant.primary,
    MinimalButtonSize size = MinimalButtonSize.medium,
    bool isLoading = false,
  }) {
    return MinimalButton(
      variant: variant,
      onPressed: onPressed,
      child: label,
      leading: icon,
      size: size.toButtonSize(),
      isLoading: isLoading,
    );
  }
}

/// Extension for color utilities
extension ColorExtension on Color {
  /// Returns a copy of this Color with new values
  Color withValues({double? alpha, int? red, int? green, int? blue}) {
    return Color.fromARGB(
      (alpha != null ? (alpha * 255).round() : this.alpha),
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
    );
  }
}
