import 'package:flutter/material.dart';
import 'package:tokens/tokens.dart' as tokens;

/// A tag component for displaying status information with color coding.
///
/// Tag displays text with a colored background or border to indicate
/// different states or categories.
class Tag extends StatelessWidget {
  /// The text to display in the tag
  final String text;

  /// The color scheme for the tag
  final Color color;

  /// Whether to use an outlined style instead of filled
  final bool outlined;

  /// The size of the tag
  final TagSize size;

  /// Creates a Tag.
  ///
  /// [text] is the content to display.
  /// [color] is the primary color for the tag styling.
  const Tag({
    super.key,
    required this.text,
    required this.color,
    this.outlined = false,
    this.size = TagSize.md,
  });

  /// Creates an outlined tag
  factory Tag.outlined({
    Key? key,
    required String text,
    required Color color,
    TagSize size = TagSize.md,
  }) =>
      Tag(
        key: key,
        text: text,
        color: color,
        outlined: true,
        size: size,
      );

  @override
  Widget build(BuildContext context) {
    final spacing = tokens.Spacing.of(context);
    final radius = tokens.Radius.of(context);

    final sizeData = _getSizeData(spacing);

    final backgroundColor = outlined
        ? Colors.transparent
        : color.withValues(alpha: 0.1);

    final textColor = outlined
        ? color
        : _getContrastingTextColor(color);

    final border = outlined
        ? Border.all(color: color, width: 1.0)
        : null;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeData.horizontalPadding,
        vertical: sizeData.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: BorderRadius.circular(radius.sm),
      ),
      child: Text(
        text,
        style: sizeData.textStyle.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Get contrasting text color for the given background color
  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate relative luminance
    final luminance = backgroundColor.computeLuminance();
    // Use white text for dark backgrounds, dark text for light backgrounds
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// Get size properties based on the tag size
  _TagSizeData _getSizeData(tokens.Spacing spacing) {
    switch (size) {
      case TagSize.sm:
        return _TagSizeData(
          horizontalPadding: spacing.xs,
          verticalPadding: spacing.xs / 2,
          textStyle: const TextStyle(fontSize: 12),
        );
      case TagSize.md:
        return _TagSizeData(
          horizontalPadding: spacing.sm,
          verticalPadding: spacing.xs,
          textStyle: const TextStyle(fontSize: 14),
        );
      case TagSize.lg:
        return _TagSizeData(
          horizontalPadding: spacing.md,
          verticalPadding: spacing.sm,
          textStyle: const TextStyle(fontSize: 16),
        );
    }
  }
}

/// Size variants for Tag
enum TagSize {
  sm,
  md,
  lg,
}

/// Helper class for tag size properties
class _TagSizeData {
  final double horizontalPadding;
  final double verticalPadding;
  final TextStyle textStyle;

  const _TagSizeData({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.textStyle,
  });
}