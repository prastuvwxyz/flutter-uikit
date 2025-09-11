import 'package:flutter/material.dart';
import '../../../src/tokens/ui_tokens.dart';

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

  const NavigationSection({
    required this.title,
    required this.items,
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

/// A responsive DashboardTemplate matching Minimal UI patterns.
class DashboardTemplate extends StatelessWidget {
  final Widget body;
  final String selectedRoute;
  final ValueChanged<String> onRouteChanged;
  final List<NavigationSection> navigationSections;
  final BrandConfig brandConfig;
  final Widget? headerActions;
  final String? userDisplayName;
  final Widget? userAvatar;
  final VoidCallback? onUserTap;
  final Widget? footerContent;
  final Color? backgroundColor;
  final double sidebarWidth;
  final bool showMobileDrawer;

  const DashboardTemplate({
    super.key,
    required this.body,
    required this.selectedRoute,
    required this.onRouteChanged,
    required this.navigationSections,
    this.brandConfig = const BrandConfig(),
    this.headerActions,
    this.userDisplayName = 'Admin User',
    this.userAvatar,
    this.onUserTap,
    this.footerContent,
    this.backgroundColor,
    this.sidebarWidth = 280,
    this.showMobileDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    
    return Scaffold(
      backgroundColor: backgroundColor ?? tokens.colorTokens.neutral.shade50,
      drawer: isDesktop || !showMobileDrawer ? null : Drawer(
        child: _MinimalSidebar(
          selectedRoute: selectedRoute,
          onRouteChanged: (route) {
            onRouteChanged(route);
            Navigator.of(context).pop();
          },
          navigationSections: navigationSections,
          brandConfig: brandConfig,
          footerContent: footerContent,
          width: sidebarWidth,
        ),
      ),
      body: Row(
        children: [
          // Desktop Sidebar
          if (isDesktop) 
            _MinimalSidebar(
              selectedRoute: selectedRoute,
              onRouteChanged: onRouteChanged,
              navigationSections: navigationSections,
              brandConfig: brandConfig,
              footerContent: footerContent,
              width: sidebarWidth,
            ),
          
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Header
                _DashboardHeader(
                  selectedRoute: selectedRoute,
                  isDesktop: isDesktop,
                  headerActions: headerActions,
                  userDisplayName: userDisplayName,
                  userAvatar: userAvatar,
                  onUserTap: onUserTap,
                ),
                
                // Content Area
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal sidebar widget for the dashboard
class _MinimalSidebar extends StatefulWidget {
  final String selectedRoute;
  final ValueChanged<String> onRouteChanged;
  final List<NavigationSection> navigationSections;
  final BrandConfig brandConfig;
  final Widget? footerContent;
  final double width;

  const _MinimalSidebar({
    super.key,
    required this.selectedRoute,
    required this.onRouteChanged,
    required this.navigationSections,
    required this.brandConfig,
    this.footerContent,
    required this.width,
  });

  @override
  State<_MinimalSidebar> createState() => _MinimalSidebarState();
}

class _MinimalSidebarState extends State<_MinimalSidebar> {
  final Set<String> _expandedItems = <String>{};

  @override
  void initState() {
    super.initState();
    _updateExpandedItems();
  }

  @override
  void didUpdateWidget(_MinimalSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRoute != widget.selectedRoute) {
      _updateExpandedItems();
    }
  }

  void _updateExpandedItems() {
    // Auto-expand parent items if their child routes are active
    for (final section in widget.navigationSections) {
      for (final item in section.items) {
        if (item.children != null && item.children!.isNotEmpty) {
          final hasActiveChild = item.children!.any((child) => widget.selectedRoute == child.route);
          if (hasActiveChild) {
            _expandedItems.add(item.route);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: tokens.colorTokens.neutral.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(1, 0),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo/Brand Section
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                widget.brandConfig.logo ?? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        tokens.colorTokens.primary.shade500,
                        tokens.colorTokens.primary.shade700,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.brandConfig.fallbackIcon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                if (widget.brandConfig.title != null || widget.brandConfig.subtitle != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.brandConfig.title != null)
                          Text(
                            widget.brandConfig.title!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: tokens.colorTokens.neutral.shade900,
                            ),
                          ),
                        if (widget.brandConfig.subtitle != null)
                          Text(
                            widget.brandConfig.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: tokens.colorTokens.neutral.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Navigation Sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final section in widget.navigationSections) ...[
                  _buildSectionHeader(section.title, tokens),
                  for (final item in section.items)
                    _buildNavItem(item, tokens),
                  if (section != widget.navigationSections.last)
                    const SizedBox(height: 16),
                ],
              ],
            ),
          ),
          
          // Footer Section
          if (widget.footerContent != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: widget.footerContent!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, UiTokens tokens) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: tokens.colorTokens.neutral.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item, UiTokens tokens) {
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isExpanded = _expandedItems.contains(item.route);
    final isSelected = widget.selectedRoute == item.route;
    final isChildSelected = hasChildren && item.children!.any((child) => widget.selectedRoute == child.route);
    
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
                  widget.onRouteChanged(item.route);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: (isSelected || isChildSelected)
                      ? tokens.colorTokens.primary.shade500.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      (isSelected || isChildSelected) ? item.selectedIcon : item.icon,
                      size: 20,
                      color: (isSelected || isChildSelected)
                          ? tokens.colorTokens.primary.shade600
                          : tokens.colorTokens.neutral.shade600,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          color: (isSelected || isChildSelected)
                              ? tokens.colorTokens.primary.shade600
                              : tokens.colorTokens.neutral.shade700,
                          fontWeight: (isSelected || isChildSelected) ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (hasChildren)
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 16,
                        color: tokens.colorTokens.neutral.shade500,
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
                    children: item.children!.map((child) => _buildChildNavItem(child, tokens)).toList(),
                  )
                : const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }

  Widget _buildChildNavItem(NavigationItem item, UiTokens tokens) {
    final isSelected = widget.selectedRoute == item.route;
    
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 12, top: 2, bottom: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () => widget.onRouteChanged(item.route),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected 
                  ? tokens.colorTokens.primary.shade500.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tokens.colorTokens.primary.shade600
                        : tokens.colorTokens.neutral.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? tokens.colorTokens.primary.shade600
                          : tokens.colorTokens.neutral.shade700,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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

/// Internal header widget for the dashboard
class _DashboardHeader extends StatelessWidget {
  final String selectedRoute;
  final bool isDesktop;
  final Widget? headerActions;
  final String? userDisplayName;
  final Widget? userAvatar;
  final VoidCallback? onUserTap;

  const _DashboardHeader({
    required this.selectedRoute,
    required this.isDesktop,
    this.headerActions,
    this.userDisplayName,
    this.userAvatar,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: tokens.colorTokens.neutral.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          // Mobile menu button
          if (!isDesktop)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          
          // Page Title
          Text(
            _getPageTitle(selectedRoute),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: tokens.colorTokens.neutral.shade900,
            ),
          ),
          
          const Spacer(),
          
          // Header Actions
          if (headerActions != null) 
            headerActions!
          else 
            _defaultHeaderActions(tokens),
        ],
      ),
    );
  }

  Widget _defaultHeaderActions(UiTokens tokens) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_outlined, 
            color: tokens.colorTokens.neutral.shade600),
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search, 
            color: tokens.colorTokens.neutral.shade600),
          tooltip: 'Search',
        ),
        const SizedBox(width: 16),
        
        // User Profile
        InkWell(
          onTap: onUserTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: tokens.colorTokens.neutral.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                userAvatar ?? CircleAvatar(
                  radius: 16,
                  backgroundColor: tokens.colorTokens.primary.shade500,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                if (userDisplayName != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    userDisplayName!,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: tokens.colorTokens.neutral.shade700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: tokens.colorTokens.neutral.shade600,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getPageTitle(String route) {
    switch (route) {
      case '/':
      case '/dashboard':
        return 'Dashboard';
      case '/analytics':
        return 'Analytics';
      case '/motorcycles':
        return 'Motorcycles';
      case '/motorcycles/stocks':
        return 'Motorcycle Stocks';
      case '/motorcycles/maintenance':
        return 'Motorcycle Maintenance';
      case '/rentals':
        return 'Rentals';
      case '/maintenance':
        return 'Maintenance';
      case '/customers':
        return 'Customers';
      case '/payments':
        return 'Payments';
      case '/reports':
        return 'Reports';
      case '/settings':
        return 'Settings';
      default:
        final routeName = route.replaceAll('/', '');
        if (routeName.isEmpty) return 'Dashboard';
        return routeName.split(RegExp(r'[_-]')).map((word) => 
          word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ').trim();
    }
  }
}
