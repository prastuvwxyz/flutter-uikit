import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../internal/token_adapters.dart';

/// A single breadcrumb item that can be interactive or static
class BreadcrumbItem {
  /// The content to display for this breadcrumb
  final Widget child;

  /// Whether this is the current/active page
  final bool isCurrent;

  /// Callback when this breadcrumb is tapped
  final VoidCallback? onTap;

  /// Tooltip text for this breadcrumb
  final String? tooltip;

  /// Creates a breadcrumb item
  const BreadcrumbItem({
    required this.child,
    this.isCurrent = false,
    this.onTap,
    this.tooltip,
  });

  /// Factory for text-based breadcrumbs
  factory BreadcrumbItem.text({
    required String text,
    bool isCurrent = false,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return BreadcrumbItem(
      child: Text(text),
      isCurrent: isCurrent,
      onTap: onTap,
      tooltip: tooltip,
    );
  }

  /// Factory for icon-based breadcrumbs
  factory BreadcrumbItem.icon({
    required IconData icon,
    bool isCurrent = false,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return BreadcrumbItem(
      child: Icon(icon),
      isCurrent: isCurrent,
      onTap: onTap,
      tooltip: tooltip,
    );
  }

  /// Factory for breadcrumbs with both icon and text
  factory BreadcrumbItem.iconText({
    required IconData icon,
    required String text,
    bool isCurrent = false,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return BreadcrumbItem(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
      isCurrent: isCurrent,
      onTap: onTap,
      tooltip: tooltip,
    );
  }
}

/// Size variants for breadcrumbs
enum BreadcrumbSize {
  /// Small breadcrumbs
  sm,
  /// Medium breadcrumbs (default)
  md,
  /// Large breadcrumbs
  lg,
}

/// Visual style variants for breadcrumbs
enum BreadcrumbVariant {
  /// Default breadcrumb style
  standard,
  /// Pills style with background
  pills,
  /// Underlined style
  underlined,
}

/// A navigation component showing the current page's location within the site hierarchy
class Breadcrumbs extends StatelessWidget {
  /// List of breadcrumb items to display
  final List<BreadcrumbItem> items;

  /// Custom separator widget between breadcrumbs
  final Widget? separator;

  /// Size variant for the breadcrumbs
  final BreadcrumbSize size;

  /// Visual style variant
  final BreadcrumbVariant variant;

  /// Maximum number of breadcrumbs to show before collapsing
  final int? maxItems;

  /// Whether to show a home icon as the first breadcrumb
  final bool showHome;

  /// Custom home icon
  final IconData homeIcon;

  /// Callback when home icon is tapped
  final VoidCallback? onHomeTap;

  /// Custom overflow widget when breadcrumbs are collapsed
  final Widget? overflowWidget;

  /// Whether breadcrumbs should wrap to new lines
  final bool allowWrap;

  /// Creates a breadcrumbs navigation component
  const Breadcrumbs({
    super.key,
    required this.items,
    this.separator,
    this.size = BreadcrumbSize.md,
    this.variant = BreadcrumbVariant.standard,
    this.maxItems,
    this.showHome = false,
    this.homeIcon = Icons.home,
    this.onHomeTap,
    this.overflowWidget,
    this.allowWrap = false,
  });

  /// Factory for simple text breadcrumbs
  factory Breadcrumbs.simple({
    Key? key,
    required List<String> labels,
    List<VoidCallback?>? onTaps,
    BreadcrumbSize size = BreadcrumbSize.md,
    BreadcrumbVariant variant = BreadcrumbVariant.standard,
    int? maxItems,
    bool showHome = false,
    VoidCallback? onHomeTap,
    bool allowWrap = false,
  }) {
    final items = labels.asMap().entries.map((entry) {
      final index = entry.key;
      final label = entry.value;
      final isLast = index == labels.length - 1;
      final onTap = onTaps?.elementAtOrNull(index);

      return BreadcrumbItem.text(
        text: label,
        isCurrent: isLast,
        onTap: onTap,
      );
    }).toList();

    return Breadcrumbs(
      key: key,
      items: items,
      size: size,
      variant: variant,
      maxItems: maxItems,
      showHome: showHome,
      onHomeTap: onHomeTap,
      allowWrap: allowWrap,
    );
  }

  /// Get text style based on size
  TextStyle _getTextStyle(BuildContext context) {
    switch (size) {
      case BreadcrumbSize.sm:
        return TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.bodySmall,
        );
      case BreadcrumbSize.md:
        return TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.bodyMedium,
        );
      case BreadcrumbSize.lg:
        return TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.bodyLarge,
        );
    }
  }

  /// Get icon size based on size
  double _getIconSize() {
    switch (size) {
      case BreadcrumbSize.sm:
        return 14.0;
      case BreadcrumbSize.md:
        return 16.0;
      case BreadcrumbSize.lg:
        return 18.0;
    }
  }

  /// Get spacing based on size
  double _getSpacing(BuildContext context) {
    switch (size) {
      case BreadcrumbSize.sm:
        return context.spacing.xs;
      case BreadcrumbSize.md:
        return context.spacing.sm;
      case BreadcrumbSize.lg:
        return context.spacing.md;
    }
  }

  /// Build default separator
  Widget _buildSeparator(BuildContext context) {
    if (separator != null) return separator!;

    return Icon(
      Icons.chevron_right,
      size: _getIconSize(),
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
    );
  }

  /// Build home breadcrumb if enabled
  Widget? _buildHomeBreadcrumb(BuildContext context) {
    if (!showHome) return null;

    final colorScheme = Theme.of(context).colorScheme;

    Widget homeWidget = Icon(
      homeIcon,
      size: _getIconSize(),
      color: colorScheme.primary,
    );

    if (onHomeTap != null) {
      homeWidget = InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onHomeTap!();
        },
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: homeWidget,
        ),
      );
    }

    return Semantics(
      button: onHomeTap != null,
      label: 'Home',
      child: homeWidget,
    );
  }

  /// Build a single breadcrumb item
  Widget _buildBreadcrumbItem(BuildContext context, BreadcrumbItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = _getTextStyle(context);

    // Determine colors based on state
    Color textColor;
    if (item.isCurrent) {
      textColor = colorScheme.onSurface;
    } else if (item.onTap != null) {
      textColor = colorScheme.primary;
    } else {
      textColor = colorScheme.onSurface.withValues(alpha: 0.7);
    }

    Widget content = DefaultTextStyle(
      style: textStyle.copyWith(
        color: textColor,
        fontWeight: item.isCurrent ? FontWeight.w600 : FontWeight.normal,
        decoration: variant == BreadcrumbVariant.underlined && item.onTap != null
            ? TextDecoration.underline
            : null,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: textColor,
          size: _getIconSize(),
        ),
        child: item.child,
      ),
    );

    // Apply variant-specific styling
    if (variant == BreadcrumbVariant.pills) {
      content = Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.sm,
          vertical: context.spacing.xs / 2,
        ),
        decoration: BoxDecoration(
          color: item.isCurrent
              ? colorScheme.primaryContainer
              : item.onTap != null
                  ? colorScheme.surfaceContainerHigh
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: content,
      );
    }

    // Add interactivity if onTap is provided
    if (item.onTap != null) {
      content = InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          item.onTap!();
        },
        borderRadius: BorderRadius.circular(4),
        child: variant == BreadcrumbVariant.pills
            ? content
            : Padding(
                padding: const EdgeInsets.all(4),
                child: content,
              ),
      );

      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: content,
      );
    }

    // Add tooltip if provided
    if (item.tooltip != null) {
      content = Tooltip(
        message: item.tooltip!,
        child: content,
      );
    }

    // Add semantics
    content = Semantics(
      button: item.onTap != null,
      selected: item.isCurrent,
      child: content,
    );

    return content;
  }

  /// Build overflow indicator when breadcrumbs are collapsed
  Widget _buildOverflowIndicator(BuildContext context) {
    if (overflowWidget != null) return overflowWidget!;

    return PopupMenuButton<void>(
      icon: Icon(
        Icons.more_horiz,
        size: _getIconSize(),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      itemBuilder: (context) => [],
      tooltip: 'Show more breadcrumbs',
    );
  }

  /// Get items to display with overflow handling
  List<Widget> _getDisplayItems(BuildContext context) {
    final allItems = <Widget>[];

    // Add home breadcrumb if enabled
    final home = _buildHomeBreadcrumb(context);
    if (home != null) {
      allItems.add(home);
    }

    // Convert breadcrumb items to widgets
    final breadcrumbWidgets = items
        .map((item) => _buildBreadcrumbItem(context, item))
        .toList();

    // Handle overflow
    if (maxItems != null && items.length > maxItems!) {
      final visibleCount = maxItems! - 1; // Reserve space for overflow indicator

      // Add first few items
      allItems.addAll(breadcrumbWidgets.take(visibleCount ~/ 2));

      // Add overflow indicator
      allItems.add(_buildOverflowIndicator(context));

      // Add last few items including current page
      final remainingCount = visibleCount - (visibleCount ~/ 2);
      allItems.addAll(breadcrumbWidgets.skip(items.length - remainingCount));
    } else {
      allItems.addAll(breadcrumbWidgets);
    }

    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = _getDisplayItems(context);
    final spacing = _getSpacing(context);

    if (displayItems.isEmpty) {
      return const SizedBox.shrink();
    }

    // Build list with separators
    final children = <Widget>[];
    for (int i = 0; i < displayItems.length; i++) {
      children.add(displayItems[i]);

      // Add separator between items (but not after the last item)
      if (i < displayItems.length - 1) {
        children.add(SizedBox(width: spacing));
        children.add(_buildSeparator(context));
        children.add(SizedBox(width: spacing));
      }
    }

    Widget breadcrumbsWidget;
    if (allowWrap) {
      breadcrumbsWidget = Wrap(
        spacing: spacing,
        runSpacing: spacing / 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      );
    } else {
      breadcrumbsWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: children,
        ),
      );
    }

    return Semantics(
      container: true,
      label: 'Breadcrumb navigation',
      child: breadcrumbsWidget,
    );
  }
}