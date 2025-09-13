import 'package:flutter/material.dart';
import '../internal/token_adapters.dart';
import '../internal/a11y.dart';

/// Types of badges available
enum BadgeType {
  /// Primary badge
  primary,
  /// Secondary badge
  secondary,
  /// Success badge (green)
  success,
  /// Warning badge (yellow)
  warning,
  /// Error badge (red)
  error
}

/// Size variants for badges
enum BadgeSize {
  /// Small badge
  sm,
  /// Medium badge (default)
  md,
  /// Large badge
  lg
}

/// Position of badge relative to child
enum BadgePosition {
  /// Top right corner
  topRight,
  /// Top left corner
  topLeft,
  /// Bottom right corner
  bottomRight,
  /// Bottom left corner
  bottomLeft
}

/// Visual variants for badges
enum BadgeVariant {
  /// Filled background
  filled,
  /// Outlined border
  outlined,
  /// Small dot indicator
  dot
}

/// Extension methods for BadgeType
extension BadgeTypeExtension on BadgeType {
  /// Gets the color for this badge type
  Color getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (this) {
      case BadgeType.primary:
        return colorScheme.primary;
      case BadgeType.secondary:
        return colorScheme.secondary;
      case BadgeType.success:
        return Colors.green.shade600;
      case BadgeType.warning:
        return Colors.orange.shade600;
      case BadgeType.error:
        return colorScheme.error;
    }
  }

  /// Gets the "on" color for this badge type
  Color getOnColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (this) {
      case BadgeType.primary:
        return colorScheme.onPrimary;
      case BadgeType.secondary:
        return colorScheme.onSecondary;
      case BadgeType.success:
        return Colors.white;
      case BadgeType.warning:
        return Colors.black87;
      case BadgeType.error:
        return colorScheme.onError;
    }
  }
}

/// A small status indicator badge that can overlay other widgets
class Badge extends StatelessWidget {
  /// Child widget to overlay the badge on
  final Widget? child;

  /// Text label to display in the badge
  final String? label;

  /// Numeric count to display in the badge
  final int? count;

  /// Type/color of the badge
  final BadgeType type;

  /// Size of the badge
  final BadgeSize size;

  /// Position of the badge relative to child
  final BadgePosition position;

  /// Visual variant of the badge
  final BadgeVariant variant;

  /// Whether to show zero count badges
  final bool showZero;

  /// Maximum count before showing "+"
  final int maxCount;

  /// Offset from the default position
  final Offset? offset;

  /// Whether the badge is clickable
  final VoidCallback? onTap;

  /// Tooltip for the badge
  final String? tooltip;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Creates a [Badge] widget
  const Badge({
    super.key,
    this.child,
    this.label,
    this.count,
    this.type = BadgeType.primary,
    this.size = BadgeSize.md,
    this.position = BadgePosition.topRight,
    this.variant = BadgeVariant.filled,
    this.showZero = false,
    this.maxCount = 99,
    this.offset,
    this.onTap,
    this.tooltip,
    this.semanticLabel,
  });

  /// Factory for creating a count badge
  factory Badge.count({
    Key? key,
    Widget? child,
    required int count,
    BadgeType type = BadgeType.primary,
    BadgeSize size = BadgeSize.md,
    BadgePosition position = BadgePosition.topRight,
    BadgeVariant variant = BadgeVariant.filled,
    bool showZero = false,
    int maxCount = 99,
    Offset? offset,
    VoidCallback? onTap,
    String? tooltip,
    String? semanticLabel,
  }) {
    return Badge(
      key: key,
      child: child,
      count: count,
      type: type,
      size: size,
      position: position,
      variant: variant,
      showZero: showZero,
      maxCount: maxCount,
      offset: offset,
      onTap: onTap,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory for creating a label badge
  factory Badge.label({
    Key? key,
    Widget? child,
    required String label,
    BadgeType type = BadgeType.primary,
    BadgeSize size = BadgeSize.md,
    BadgePosition position = BadgePosition.topRight,
    BadgeVariant variant = BadgeVariant.filled,
    Offset? offset,
    VoidCallback? onTap,
    String? tooltip,
    String? semanticLabel,
  }) {
    return Badge(
      key: key,
      child: child,
      label: label,
      type: type,
      size: size,
      position: position,
      variant: variant,
      offset: offset,
      onTap: onTap,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory for creating a dot badge
  factory Badge.dot({
    Key? key,
    Widget? child,
    BadgeType type = BadgeType.primary,
    BadgeSize size = BadgeSize.md,
    BadgePosition position = BadgePosition.topRight,
    Offset? offset,
    VoidCallback? onTap,
    String? tooltip,
    String? semanticLabel,
  }) {
    return Badge(
      key: key,
      child: child,
      type: type,
      size: size,
      position: position,
      variant: BadgeVariant.dot,
      offset: offset,
      onTap: onTap,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
    );
  }

  /// Get font size based on badge size
  double get _fontSize {
    switch (size) {
      case BadgeSize.sm:
        return 10;
      case BadgeSize.md:
        return 12;
      case BadgeSize.lg:
        return 14;
    }
  }

  /// Get padding based on badge size
  EdgeInsets _getPadding(BuildContext context) {
    switch (size) {
      case BadgeSize.sm:
        return EdgeInsets.symmetric(
          horizontal: context.spacing.xs / 2,
          vertical: context.spacing.xs / 4,
        );
      case BadgeSize.md:
        return EdgeInsets.symmetric(
          horizontal: context.spacing.xs,
          vertical: context.spacing.xs / 2,
        );
      case BadgeSize.lg:
        return EdgeInsets.symmetric(
          horizontal: context.spacing.sm,
          vertical: context.spacing.xs,
        );
    }
  }

  String? get _displayText {
    if (label != null) return label;
    if (count != null) {
      if (count == 0 && !showZero) return null;
      if (count! > maxCount) return '$maxCount+';
      return count.toString();
    }
    return variant == BadgeVariant.dot ? null : '';
  }

  Alignment get _alignment {
    switch (position) {
      case BadgePosition.topRight:
        return Alignment.topRight;
      case BadgePosition.topLeft:
        return Alignment.topLeft;
      case BadgePosition.bottomRight:
        return Alignment.bottomRight;
      case BadgePosition.bottomLeft:
        return Alignment.bottomLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeVisible = _displayText != null || variant == BadgeVariant.dot;
    if (!badgeVisible) return child ?? const SizedBox.shrink();

    final color = type.getColor(context);
    final onColor = type.getOnColor(context);

    Widget badge = Container(
      padding: variant == BadgeVariant.dot ? EdgeInsets.zero : _getPadding(context),
      decoration: BoxDecoration(
        color: variant == BadgeVariant.filled || variant == BadgeVariant.dot
            ? color
            : Colors.transparent,
        border: variant == BadgeVariant.outlined
            ? Border.all(color: color, width: 1)
            : null,
        borderRadius: context.borderRadius(all: TokenRadiusSize.full),
      ),
      constraints: BoxConstraints(
        minWidth: variant == BadgeVariant.dot ? 8 : 16,
        minHeight: variant == BadgeVariant.dot ? 8 : 16,
      ),
      child: variant == BadgeVariant.dot
          ? null
          : Text(
              _displayText!,
              style: TokenAdapters.textStyleFromTokens(
                tokenStyle: TokenTextStyle.labelSmall,
                color: variant == BadgeVariant.filled ? onColor : color,
                fontWeight: FontWeight.w600,
              ).copyWith(fontSize: _fontSize),
              textAlign: TextAlign.center,
            ),
    );

    // Add gesture detection if onTap provided
    if (onTap != null) {
      badge = A11yFocusableWidget(
        semanticLabel: semanticLabel ?? _displayText ?? 'Badge',
        child: GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: badge,
          ),
        ),
      );
    }

    // Add semantics
    badge = Semantics(
      button: onTap != null,
      label: semanticLabel ?? _displayText ?? 'Indicator',
      child: badge,
    );

    // Add tooltip if provided
    if (tooltip != null) {
      badge = Tooltip(
        message: tooltip!,
        child: badge,
      );
    }

    if (child == null) return badge;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Align(
          alignment: _alignment,
          child: Transform.translate(
            offset: offset ?? Offset.zero,
            child: badge,
          ),
        ),
      ],
    );
  }
}