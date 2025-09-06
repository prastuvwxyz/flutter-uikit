import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ChipVariant enum for different visual styles.
enum ChipVariant { filled, outlined, ghost }

/// ChipSize enum for size variants.
enum ChipSize { sm, md, lg }

/// ChipColor for custom color overrides (can be extended).
class ChipColor {
  final Color? background;
  final Color? foreground;
  final Color? border;
  const ChipColor({this.background, this.foreground, this.border});
}

/// MinimalChip widget as described in UIK-117.
class MinimalChip extends StatelessWidget {
  final String label;
  final Widget? avatar;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onDeleted;
  final Widget? deleteIcon;
  final ChipVariant variant;
  final ChipSize size;
  final ChipColor? color;
  final bool disabled;

  const MinimalChip({
    super.key,
    required this.label,
    this.avatar,
    this.selected = false,
    this.onSelected,
    this.onDeleted,
    this.deleteIcon,
    this.variant = ChipVariant.filled,
    this.size = ChipSize.md,
    this.color,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use theme tokens or fallback values
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor =
        color ?? _defaultColor(theme, variant, selected, disabled, isDark);
    final borderRadius = BorderRadius.circular(1000); // full radius
    final padding = _chipPadding(size);
    final textStyle = _chipTextStyle(theme, size);
    final deleteIconWidget = onDeleted != null
        ? GestureDetector(
            onTap: disabled ? null : onDeleted,
            child:
                deleteIcon ??
                Icon(
                  Icons.close,
                  size: _iconSize(size),
                  color: effectiveColor.foreground?.withOpacity(
                    disabled ? 0.38 : 1,
                  ),
                ),
          )
        : null;

    Widget chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (avatar != null) ...[avatar!, SizedBox(width: 8)],
        Flexible(
          child: Text(
            label,
            style: textStyle.copyWith(
              color: effectiveColor.foreground?.withOpacity(
                disabled ? 0.38 : 1,
              ),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (deleteIconWidget != null) ...[SizedBox(width: 4), deleteIconWidget],
      ],
    );

    chipContent = Padding(padding: padding, child: chipContent);

    return Semantics(
      button: true,
      enabled: !disabled,
      selected: selected,
      child: FocusableActionDetector(
        enabled: !disabled,
        onShowHoverHighlight: (hovering) {},
        onShowFocusHighlight: (focusing) {},
        shortcuts: _chipShortcuts,
        actions: _chipActions(
          context,
          onSelected,
          onDeleted,
          selected,
          disabled,
        ),
        child: GestureDetector(
          onTap: disabled
              ? null
              : () {
                  if (onSelected != null) onSelected!(!selected);
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: effectiveColor.background,
              border: variant == ChipVariant.outlined
                  ? Border.all(
                      color: effectiveColor.border ?? Colors.transparent,
                    )
                  : null,
              borderRadius: borderRadius,
            ),
            child: chipContent,
          ),
        ),
      ),
    );
  }
}

// --- Helpers ---

EdgeInsets _chipPadding(ChipSize size) {
  switch (size) {
    case ChipSize.sm:
      return const EdgeInsets.symmetric(horizontal: 8, vertical: 2);
    case ChipSize.lg:
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    case ChipSize.md:
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  }
}

double _iconSize(ChipSize size) {
  switch (size) {
    case ChipSize.sm:
      return 16;
    case ChipSize.lg:
      return 24;
    case ChipSize.md:
      return 20;
  }
}

TextStyle _chipTextStyle(ThemeData theme, ChipSize size) {
  switch (size) {
    case ChipSize.sm:
      return theme.textTheme.labelSmall ?? const TextStyle(fontSize: 12);
    case ChipSize.lg:
      return theme.textTheme.labelLarge ?? const TextStyle(fontSize: 16);
    case ChipSize.md:
      return theme.textTheme.labelMedium ?? const TextStyle(fontSize: 14);
  }
}

ChipColor _defaultColor(
  ThemeData theme,
  ChipVariant variant,
  bool selected,
  bool disabled,
  bool isDark,
) {
  // Replace with design tokens as needed
  final primary = theme.colorScheme.primary;
  final surface = theme.colorScheme.surface;
  final onSurface = theme.colorScheme.onSurface;
  final outline = theme.colorScheme.outline;
  switch (variant) {
    case ChipVariant.filled:
      return ChipColor(
        background: disabled
            ? onSurface.withOpacity(0.12)
            : selected
            ? primary.withOpacity(0.16)
            : surface,
        foreground: disabled
            ? onSurface
            : selected
            ? primary
            : onSurface,
        border: Colors.transparent,
      );
    case ChipVariant.outlined:
      return ChipColor(
        background: disabled ? onSurface.withOpacity(0.04) : surface,
        foreground: disabled
            ? onSurface
            : selected
            ? primary
            : onSurface,
        border: selected ? primary : outline,
      );
    case ChipVariant.ghost:
      return ChipColor(
        background: Colors.transparent,
        foreground: disabled
            ? onSurface
            : selected
            ? primary
            : onSurface,
        border: Colors.transparent,
      );
  }
}

final Map<LogicalKeySet, Intent> _chipShortcuts = {
  LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
  LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
  LogicalKeySet(LogicalKeyboardKey.delete): const DismissIntent(),
  LogicalKeySet(LogicalKeyboardKey.backspace): const DismissIntent(),
};

Map<Type, Action<Intent>> _chipActions(
  BuildContext context,
  ValueChanged<bool>? onSelected,
  VoidCallback? onDeleted,
  bool selected,
  bool disabled,
) {
  return <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(
      onInvoke: (intent) {
        if (!disabled && onSelected != null) onSelected(!selected);
        return null;
      },
    ),
    DismissIntent: CallbackAction<DismissIntent>(
      onInvoke: (intent) {
        if (!disabled && onDeleted != null) onDeleted();
        return null;
      },
    ),
  };
}

class DismissIntent extends Intent {
  const DismissIntent();
}
