import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';

/// Defines the different types of alerts available.
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

/// Defines the different visual variants of alerts.
enum AlertVariant {
  /// Filled background with contrasting text
  filled,

  /// Outlined border with background matching the surface
  outlined,

  /// Light background with matching text color
  ghost,
}

/// Extension methods for [AlertType] to get associated icons and colors.
extension AlertTypeExtension on AlertType {
  /// Returns the icon data for this alert type.
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

  /// Returns the semantic label for this alert type for accessibility.
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

  /// Gets the background color for this alert type based on the variant.
  Color getBackgroundColor(
    BuildContext context,
    AlertVariant variant,
    UiTokens tokens,
  ) {
    final colorSwatch = _getColorSwatch(tokens);

    switch (variant) {
      case AlertVariant.filled:
        return colorSwatch[500]!;
      case AlertVariant.outlined:
        return Colors.transparent;
      case AlertVariant.ghost:
        return colorSwatch[50]!;
    }
  }

  /// Gets the border color for this alert type.
  Color getBorderColor(
    BuildContext context,
    AlertVariant variant,
    UiTokens tokens,
  ) {
    if (variant != AlertVariant.outlined) {
      return Colors.transparent;
    }

    return _getColorSwatch(tokens)[500]!;
  }

  /// Gets the text color for this alert type based on the variant.
  Color getTextColor(
    BuildContext context,
    AlertVariant variant,
    UiTokens tokens,
  ) {
    final colorSwatch = _getColorSwatch(tokens);

    switch (variant) {
      case AlertVariant.filled:
        return getOnColor(tokens);
      case AlertVariant.outlined:
      case AlertVariant.ghost:
        return colorSwatch[600]!;
    }
  }

  /// Gets the icon color for this alert type based on the variant.
  Color getIconColor(
    BuildContext context,
    AlertVariant variant,
    UiTokens tokens,
  ) {
    return getTextColor(context, variant, tokens);
  }

  /// Gets the appropriate color swatch for this alert type.
  ColorSwatch _getColorSwatch(UiTokens tokens) {
    switch (this) {
      case AlertType.success:
        return tokens.colorTokens.success;
      case AlertType.warning:
        return tokens.colorTokens.warning;
      case AlertType.error:
        return tokens.colorTokens.error;
      case AlertType.info:
        return tokens.colorTokens.info;
    }
  }

  /// Gets the "on" color (for text on filled backgrounds) for this alert type.
  Color getOnColor(UiTokens tokens) {
    switch (this) {
      case AlertType.success:
        return Colors.white;
      case AlertType.warning:
        return Colors.black87;
      case AlertType.error:
        return Colors.white;
      case AlertType.info:
        return Colors.white;
    }
  }
}
