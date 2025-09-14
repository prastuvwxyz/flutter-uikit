import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'header.dart';

/// A complete app shell with responsive sidebar and header
class AppShell extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  final NavigationConfig navigationConfig;
  final BrandConfig brandConfig;
  final List<HeaderAction>? headerActions;
  final Widget? customHeader;
  final UserProfile? userProfile;
  final Widget? footerContent;
  final Color? backgroundColor;
  final double sidebarWidth;
  final bool showMobileDrawer;

  const AppShell({
    super.key,
    required this.child,
    required this.currentRoute,
    required this.navigationConfig,
    this.brandConfig = const BrandConfig(),
    this.headerActions,
    this.customHeader,
    this.userProfile,
    this.footerContent,
    this.backgroundColor,
    this.sidebarWidth = 280,
    this.showMobileDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor:
          backgroundColor ?? theme.colorScheme.surfaceContainerLowest,
      drawer: isDesktop || !showMobileDrawer
          ? null
          : Drawer(
              child: Sidebar(
                selectedRoute: currentRoute,
                navigationConfig: NavigationConfig(
                  sections: navigationConfig.sections,
                  onRouteChanged: (route) {
                    navigationConfig.onRouteChanged(route);
                    Navigator.of(context).pop();
                  },
                ),
                brandConfig: brandConfig,
                footerContent: footerContent,
                width: sidebarWidth,
              ),
            ),
      body: Row(
        children: [
          // Desktop Sidebar
          if (isDesktop)
            Sidebar(
              selectedRoute: currentRoute,
              navigationConfig: navigationConfig,
              brandConfig: brandConfig,
              footerContent: footerContent,
              width: sidebarWidth,
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Header
                if (customHeader != null)
                  customHeader!
                else
                  Header(
                    currentRoute: currentRoute,
                    isDesktop: isDesktop,
                    headerActions: headerActions,
                    userProfile:
                        userProfile ??
                        const UserProfile(displayName: 'Admin User'),
                  ),

                // Content Area
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            64, // Account for header height
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
