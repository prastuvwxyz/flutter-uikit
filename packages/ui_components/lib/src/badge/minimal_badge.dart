import 'package:flutter/material.dart';

// Enums for badge type, size, position, variant
enum BadgeType { primary, secondary, success, warning, error }

enum BadgeSize { sm, md, lg }

enum BadgePosition { topRight, topLeft, bottomRight, bottomLeft }

enum BadgeVariant { filled, outlined, dot }

class MinimalBadge extends StatelessWidget {
  final Widget? child;
  final String? label;
  final int? count;
  final BadgeType type;
  final BadgeSize size;
  final BadgePosition position;
  final BadgeVariant variant;
  final bool showZero;
  final int maxCount;
  final Offset? offset;

  const MinimalBadge({
    Key? key,
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
  }) : super(key: key);

  // Design tokens (replace with your token system)
  Color get _color {
    switch (type) {
      case BadgeType.primary:
        return const Color(0xFF1976D2); // ui.color.primary
      case BadgeType.secondary:
        return const Color(0xFF455A64); // ui.color.secondary
      case BadgeType.success:
        return const Color(0xFF388E3C); // ui.color.success
      case BadgeType.warning:
        return const Color(0xFFFBC02D); // ui.color.warning
      case BadgeType.error:
        return const Color(0xFFD32F2F); // ui.color.error
    }
  }

  Color get _onColor => Colors.white; // ui.color.onPrimary

  double get _radius => 9999; // ui.radius.full

  double get _fontSize {
    switch (size) {
      case BadgeSize.sm:
        return 10; // ui.text.label.xs
      case BadgeSize.md:
        return 12; // ui.text.label.sm
      case BadgeSize.lg:
        return 14;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case BadgeSize.sm:
        return const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ); // ui.spacing.xs
      case BadgeSize.md:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 3);
      case BadgeSize.lg:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    }
  }

  // Count formatting
  String? get _displayText {
    if (label != null) return label;
    if (count != null) {
      if (count == 0 && !showZero) return null;
      if (count! > maxCount) return '$maxCount+';
      return count.toString();
    }
    return variant == BadgeVariant.dot ? null : '';
  }

  // Positioning
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

    final badge = Semantics(
      label: _displayText ?? 'Indicator',
      // Use SemanticsRole.status for accessibility
      // role: Role.status, // Removed, not needed in Flutter
      child: Container(
        padding: variant == BadgeVariant.dot ? EdgeInsets.zero : _padding,
        decoration: BoxDecoration(
          color: variant == BadgeVariant.filled || variant == BadgeVariant.dot
              ? _color
              : Colors.transparent,
          border: variant == BadgeVariant.outlined
              ? Border.all(color: _color, width: 1)
              : null,
          borderRadius: BorderRadius.circular(_radius),
        ),
        constraints: BoxConstraints(
          minWidth: variant == BadgeVariant.dot ? 8 : 16,
          minHeight: variant == BadgeVariant.dot ? 8 : 16,
        ),
        child: variant == BadgeVariant.dot
            ? null
            : Text(
                _displayText!,
                style: TextStyle(
                  color: variant == BadgeVariant.filled ? _onColor : _color,
                  fontSize: _fontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );

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
