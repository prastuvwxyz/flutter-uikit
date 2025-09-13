import 'package:flutter/material.dart';
import 'package:tokens/tokens.dart' as tokens;

/// Navigation item model for sidebar
class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final List<NavigationItem>? children;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
    this.children,
  });
}

/// Navigation section model for grouping navigation items
class NavigationSection {
  final String title;
  final List<NavigationItem> items;

  const NavigationSection({required this.title, required this.items});
}

/// Navigation configuration that includes sections and route handling
class NavigationConfig {
  final List<NavigationSection> sections;
  final ValueChanged<String> onRouteChanged;

  const NavigationConfig({
    required this.sections,
    required this.onRouteChanged,
  });
}

/// Brand configuration for the sidebar
class BrandConfig {
  final Widget? logo;
  final String? title;
  final String? subtitle;
  final IconData? fallbackIcon;

  const BrandConfig({
    this.logo,
    this.title,
    this.subtitle,
    this.fallbackIcon = Icons.apps,
  });
}

/// A reusable sidebar component following UI patterns
class Sidebar extends StatefulWidget {
  final String selectedRoute;
  final NavigationConfig navigationConfig;
  final BrandConfig brandConfig;
  final Widget? footerContent;
  final double width;

  const Sidebar({
    super.key,
    required this.selectedRoute,
    required this.navigationConfig,
    this.brandConfig = const BrandConfig(),
    this.footerContent,
    this.width = 280,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final Set<String> _expandedItems = <String>{};

  @override
  void initState() {
    super.initState();
    _updateExpandedItems();
  }

  @override
  void didUpdateWidget(Sidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRoute != widget.selectedRoute) {
      _updateExpandedItems();
    }
  }

  void _updateExpandedItems() {
    // Auto-expand parent items if their child routes are active
    for (final section in widget.navigationConfig.sections) {
      for (final item in section.items) {
        if (item.children != null && item.children!.isNotEmpty) {
          final hasActiveChild = item.children!.any(
            (child) => widget.selectedRoute == child.route,
          );
          if (hasActiveChild) {
            _expandedItems.add(item.route);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = tokens.Spacing.of(context);

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(1, 0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo/Brand Section
          _buildBrandSection(theme, spacing),

          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          // Navigation Sections
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: spacing.xs),
              children: [
                for (final section in widget.navigationConfig.sections) ...[
                  _buildSectionHeader(section.title, theme),
                  for (final item in section.items)
                    _buildNavItem(item, theme, spacing),
                  if (section != widget.navigationConfig.sections.last)
                    SizedBox(height: spacing.md),
                ],
              ],
            ),
          ),

          // Footer Section
          if (widget.footerContent != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: widget.footerContent!,
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              child: _buildFooterContent(context),
            ),
        ],
      ),
    );
  }

  Widget _buildBrandSection(ThemeData theme, tokens.Spacing spacing) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: Row(
        children: [
          widget.brandConfig.logo ??
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.brandConfig.fallbackIcon,
                  color: theme.colorScheme.onPrimary,
                  size: 22,
                ),
              ),
          if (widget.brandConfig.title != null ||
              widget.brandConfig.subtitle != null) ...[
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.brandConfig.title != null)
                    Text(
                      widget.brandConfig.title!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  if (widget.brandConfig.subtitle != null)
                    Text(
                      widget.brandConfig.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNavItem(
    NavigationItem item,
    ThemeData theme,
    tokens.Spacing spacing,
  ) {
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isExpanded = _expandedItems.contains(item.route);
    final isSelected = widget.selectedRoute == item.route;
    final isChildSelected =
        hasChildren &&
        item.children!.any((child) => widget.selectedRoute == child.route);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: 2),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                if (hasChildren) {
                  setState(() {
                    if (isExpanded) {
                      _expandedItems.remove(item.route);
                    } else {
                      _expandedItems.add(item.route);
                    }
                  });
                } else {
                  widget.navigationConfig.onRouteChanged(item.route);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: (isSelected || isChildSelected)
                      ? theme.colorScheme.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      (isSelected || isChildSelected)
                          ? item.selectedIcon
                          : item.icon,
                      size: 20,
                      color: (isSelected || isChildSelected)
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Text(
                        item.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: (isSelected || isChildSelected)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                          fontWeight: (isSelected || isChildSelected)
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (hasChildren)
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Children items with animation
        if (hasChildren)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: isExpanded ? (item.children!.length * 40.0) : 0,
            child: ClipRect(
              child: isExpanded
                  ? Column(
                      children: item.children!
                          .map(
                            (child) =>
                                _buildChildNavItem(child, theme, spacing),
                          )
                          .toList(),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }

  Widget _buildChildNavItem(
    NavigationItem item,
    ThemeData theme,
    tokens.Spacing spacing,
  ) {
    final isSelected = widget.selectedRoute == item.route;

    return Container(
      margin: EdgeInsets.only(
        left: spacing.lg,
        right: spacing.sm,
        top: 2,
        bottom: 2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () => widget.navigationConfig.onRouteChanged(item.route),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs / 2,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(right: spacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.4,
                          ),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

  Widget _buildFooterContent(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.help_outline_rounded,
            color: theme.colorScheme.onPrimaryContainer,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Need help?',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Documentation',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
