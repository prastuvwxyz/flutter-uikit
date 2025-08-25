import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

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
