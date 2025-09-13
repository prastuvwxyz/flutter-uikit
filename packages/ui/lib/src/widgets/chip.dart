import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../internal/token_adapters.dart';
import '../internal/a11y.dart';

/// Visual variants for chips
enum ChipVariant {
  /// Filled background with contrasting text
  filled,
  /// Outlined border with surface background
  outlined,
  /// Transparent background with colored text
  ghost,
}

/// Size variants for chips
enum ChipSize {
  /// Small chip
  sm,
  /// Medium chip (default)
  md,
  /// Large chip
  lg,
}

/// Custom color configuration for chips
class ChipColor {
  final Color? background;
  final Color? foreground;
  final Color? border;

  const ChipColor({
    this.background,
    this.foreground,
    this.border,
  });
}

/// A compact element for displaying information, actions, or choices
class Chip extends StatelessWidget {
  /// The text label to display
  final String label;

  /// Optional leading avatar/icon
  final Widget? avatar;

  /// Whether the chip is selected
  final bool selected;

  /// Callback when selection state changes
  final ValueChanged<bool>? onSelected;

  /// Callback when chip is deleted
  final VoidCallback? onDeleted;

  /// Custom delete icon (defaults to close icon)
  final Widget? deleteIcon;

  /// Visual style variant
  final ChipVariant variant;

  /// Size of the chip
  final ChipSize size;

  /// Custom color configuration
  final ChipColor? color;

  /// Whether the chip is disabled
  final bool disabled;

  /// Tooltip text for the chip
  final String? tooltip;

  const Chip({
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
    this.tooltip,
  });

  /// Factory for selectable chips
  factory Chip.selectable({
    Key? key,
    required String label,
    Widget? avatar,
    bool selected = false,
    required ValueChanged<bool> onSelected,
    ChipVariant variant = ChipVariant.outlined,
    ChipSize size = ChipSize.md,
    ChipColor? color,
    bool disabled = false,
    String? tooltip,
  }) {
    return Chip(
      key: key,
      label: label,
      avatar: avatar,
      selected: selected,
      onSelected: disabled ? null : onSelected,
      variant: variant,
      size: size,
      color: color,
      disabled: disabled,
      tooltip: tooltip,
    );
  }

  /// Factory for deletable chips
  factory Chip.deletable({
    Key? key,
    required String label,
    Widget? avatar,
    required VoidCallback onDeleted,
    Widget? deleteIcon,
    ChipVariant variant = ChipVariant.filled,
    ChipSize size = ChipSize.md,
    ChipColor? color,
    bool disabled = false,
    String? tooltip,
  }) {
    return Chip(
      key: key,
      label: label,
      avatar: avatar,
      onDeleted: disabled ? null : onDeleted,
      deleteIcon: deleteIcon,
      variant: variant,
      size: size,
      color: color,
      disabled: disabled,
      tooltip: tooltip,
    );
  }

  /// Factory for action chips
  factory Chip.action({
    Key? key,
    required String label,
    Widget? avatar,
    required ValueChanged<bool> onSelected,
    ChipVariant variant = ChipVariant.ghost,
    ChipSize size = ChipSize.md,
    ChipColor? color,
    bool disabled = false,
    String? tooltip,
  }) {
    return Chip(
      key: key,
      label: label,
      avatar: avatar,
      onSelected: disabled ? null : onSelected,
      variant: variant,
      size: size,
      color: color,
      disabled: disabled,
      tooltip: tooltip,
    );
  }

  /// Get padding based on size
  EdgeInsets get _padding {
    switch (size) {
      case ChipSize.sm:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 2);
      case ChipSize.md:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
      case ChipSize.lg:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  /// Get icon size based on chip size
  double get _iconSize {
    switch (size) {
      case ChipSize.sm:
        return 16;
      case ChipSize.md:
        return 20;
      case ChipSize.lg:
        return 24;
    }
  }

  /// Get text style based on size
  TokenTextStyle get _textStyle {
    switch (size) {
      case ChipSize.sm:
        return TokenTextStyle.labelSmall;
      case ChipSize.md:
        return TokenTextStyle.labelMedium;
      case ChipSize.lg:
        return TokenTextStyle.labelLarge;
    }
  }

  /// Get effective colors based on variant and state
  ChipColor _getEffectiveColor(BuildContext context) {
    if (color != null) return color!;

    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final surface = colorScheme.surface;
    final onSurface = colorScheme.onSurface;
    final outline = colorScheme.outline;

    switch (variant) {
      case ChipVariant.filled:
        return ChipColor(
          background: disabled
              ? onSurface.withValues(alpha: 0.12)
              : selected
                  ? primary.withValues(alpha: 0.16)
                  : surface,
          foreground: disabled
              ? onSurface.withValues(alpha: 0.38)
              : selected
                  ? primary
                  : onSurface,
          border: Colors.transparent,
        );

      case ChipVariant.outlined:
        return ChipColor(
          background: disabled
              ? onSurface.withValues(alpha: 0.04)
              : Colors.transparent,
          foreground: disabled
              ? onSurface.withValues(alpha: 0.38)
              : selected
                  ? primary
                  : onSurface,
          border: disabled
              ? outline.withValues(alpha: 0.12)
              : selected
                  ? primary
                  : outline,
        );

      case ChipVariant.ghost:
        return ChipColor(
          background: Colors.transparent,
          foreground: disabled
              ? onSurface.withValues(alpha: 0.38)
              : selected
                  ? primary
                  : onSurface,
          border: Colors.transparent,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = _getEffectiveColor(context);
    final borderRadius = TokenAdapters.radiusFromTokens(
      context: context,
      all: TokenRadiusSize.full,
    );

    // Build delete icon
    Widget? deleteIconWidget;
    if (onDeleted != null) {
      deleteIconWidget = GestureDetector(
        onTap: disabled ? null : onDeleted,
        child: deleteIcon ??
            Icon(
              Icons.close,
              size: _iconSize * 0.8,
              color: effectiveColor.foreground,
            ),
      );
    }

    // Build chip content
    Widget chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (avatar != null) ...[
          IconTheme(
            data: IconThemeData(
              color: effectiveColor.foreground,
              size: _iconSize,
            ),
            child: avatar!,
          ),
          SizedBox(width: context.spacing.xs),
        ],
        Flexible(
          child: Text(
            label,
            style: TokenAdapters.textStyleFromTokens(
              tokenStyle: _textStyle,
              color: effectiveColor.foreground,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (deleteIconWidget != null) ...[
          SizedBox(width: context.spacing.xs / 2),
          deleteIconWidget,
        ],
      ],
    );

    chipContent = Padding(
      padding: _padding,
      child: chipContent,
    );

    // Build the chip
    Widget chip = AnimatedContainer(
      duration: TokenAdapters.durationFromTokens(TokenDuration.fast),
      curve: TokenAdapters.curveFromTokens(TokenCurve.easeOut),
      decoration: BoxDecoration(
        color: effectiveColor.background,
        border: variant == ChipVariant.outlined
            ? Border.all(
                color: effectiveColor.border ?? Colors.transparent,
                width: 1,
              )
            : null,
        borderRadius: borderRadius,
      ),
      child: chipContent,
    );

    // Add gesture detection and focus handling
    chip = A11yFocusableWidget(
      semanticLabel: tooltip ?? label,
      onKey: (node, event) => _handleKeyEvent(event),
      child: GestureDetector(
        onTap: disabled
            ? null
            : () {
                if (onSelected != null) {
                  onSelected!(!selected);
                }
              },
        child: chip,
      ),
    );

    // Add semantics
    chip = Semantics(
      button: onSelected != null || onDeleted != null,
      enabled: !disabled,
      selected: selected,
      onTap: disabled || onSelected == null
          ? null
          : () => onSelected!(!selected),
      onDismiss: disabled || onDeleted == null ? null : onDeleted,
      child: chip,
    );

    // Add tooltip if provided
    if (tooltip != null) {
      chip = Tooltip(
        message: tooltip!,
        child: chip,
      );
    }

    return chip;
  }

  /// Handle keyboard events
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        if (!disabled && onSelected != null) {
          onSelected!(!selected);
          return KeyEventResult.handled;
        }
        break;

      case LogicalKeyboardKey.delete:
      case LogicalKeyboardKey.backspace:
        if (!disabled && onDeleted != null) {
          onDeleted!();
          return KeyEventResult.handled;
        }
        break;
    }

    return KeyEventResult.ignored;
  }
}

/// A set of related chips that allows selection of one or multiple items
class ChipSet extends StatelessWidget {
  /// List of chip labels
  final List<String> labels;

  /// List of selected indices
  final List<int> selected;

  /// Callback when selection changes
  final ValueChanged<List<int>>? onSelectionChanged;

  /// Whether multiple chips can be selected
  final bool multiSelect;

  /// Visual style variant for all chips
  final ChipVariant variant;

  /// Size for all chips
  final ChipSize size;

  /// Spacing between chips
  final double? spacing;

  /// Whether chips are disabled
  final bool disabled;

  /// Custom avatars for each chip
  final List<Widget?>? avatars;

  const ChipSet({
    super.key,
    required this.labels,
    this.selected = const [],
    this.onSelectionChanged,
    this.multiSelect = true,
    this.variant = ChipVariant.outlined,
    this.size = ChipSize.md,
    this.spacing,
    this.disabled = false,
    this.avatars,
  });

  /// Factory for single-select chip set
  factory ChipSet.singleSelect({
    Key? key,
    required List<String> labels,
    int? selectedIndex,
    ValueChanged<int?>? onSelectionChanged,
    ChipVariant variant = ChipVariant.outlined,
    ChipSize size = ChipSize.md,
    double? spacing,
    bool disabled = false,
    List<Widget?>? avatars,
  }) {
    return ChipSet(
      key: key,
      labels: labels,
      selected: selectedIndex != null ? [selectedIndex] : [],
      onSelectionChanged: onSelectionChanged != null
          ? (selected) => onSelectionChanged(selected.isEmpty ? null : selected.first)
          : null,
      multiSelect: false,
      variant: variant,
      size: size,
      spacing: spacing,
      disabled: disabled,
      avatars: avatars,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSpacing = spacing ?? context.spacing.xs;

    return Wrap(
      spacing: effectiveSpacing,
      runSpacing: effectiveSpacing,
      children: labels.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final isSelected = selected.contains(index);
        final avatar = avatars?.elementAtOrNull(index);

        return Chip.selectable(
          label: label,
          avatar: avatar,
          selected: isSelected,
          onSelected: disabled
              ? (_) {}
              : (selected) => _handleSelection(index, selected),
          variant: variant,
          size: size,
          disabled: disabled,
        );
      }).toList(),
    );
  }

  /// Handle chip selection
  void _handleSelection(int index, bool isSelected) {
    if (onSelectionChanged == null) return;

    List<int> newSelection = List.from(selected);

    if (multiSelect) {
      if (isSelected) {
        if (!newSelection.contains(index)) {
          newSelection.add(index);
        }
      } else {
        newSelection.remove(index);
      }
    } else {
      // Single select
      if (isSelected) {
        newSelection = [index];
      } else {
        newSelection = [];
      }
    }

    onSelectionChanged!(newSelection);
  }
}