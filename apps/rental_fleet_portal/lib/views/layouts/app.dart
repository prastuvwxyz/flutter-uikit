import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  final String currentRoute;
  final Widget child;

  const AppLayout({
    super.key,
    required this.currentRoute,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardTemplate(
      selectedRoute: currentRoute,
      onRouteChanged: (route) {
        context.go(route);
      },
      navigationSections: _getNavigationSections(),
      brandConfig: const BrandConfig(
        title: 'Rental Fleet',
        subtitle: 'Operation Portal Management',
        fallbackIcon: Icons.motorcycle_rounded,
      ),
      footerContent: _buildFooterContent(context),
      body: child,
    );
  }

  List<NavigationSection> _getNavigationSections() {
    return [
      NavigationSection(
        title: 'OVERVIEW',
        items: [
          NavigationItem(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard_rounded,
            label: 'Dashboard',
            route: '/',
          ),
        ],
      ),
      NavigationSection(
        title: 'FLEET MANAGEMENT',
        items: [
          NavigationItem(
            icon: Icons.motorcycle_outlined,
            selectedIcon: Icons.motorcycle_rounded,
            label: 'Motorcycles',
            route: '/motorcycles',
            children: [
              NavigationItem(
                icon: Icons.inventory_2_outlined,
                selectedIcon: Icons.inventory_2_rounded,
                label: 'Motorcycle Stocks',
                route: '/motorcycles/stocks',
              ),
              NavigationItem(
                icon: Icons.add_box_outlined,
                selectedIcon: Icons.add_box_rounded,
                label: 'In Maintenance Motorcycle',
                route: '/motorcycles/maintenance',
              ),
            ],
          ),
          NavigationItem(
            icon: Icons.receipt_long_outlined,
            selectedIcon: Icons.receipt_long_rounded,
            label: 'Rentals',
            route: '/rentals',
          ),
          NavigationItem(
            icon: Icons.build_outlined,
            selectedIcon: Icons.build_rounded,
            label: 'Maintenance',
            route: '/maintenance',
          ),
          NavigationItem(
            icon: Icons.people_outline,
            selectedIcon: Icons.people_rounded,
            label: 'Customers',
            route: '/customers',
          ),
        ],
      ),
      NavigationSection(
        title: 'BUSINESS',
        items: [
          NavigationItem(
            icon: Icons.payment_outlined,
            selectedIcon: Icons.payment_rounded,
            label: 'Payments',
            route: '/payments',
          ),
          NavigationItem(
            icon: Icons.description_outlined,
            selectedIcon: Icons.description_rounded,
            label: 'Reports',
            route: '/reports',
          ),
          NavigationItem(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings_rounded,
            label: 'Settings',
            route: '/settings',
          ),
        ],
      ),
    ];
  }

  Widget _buildFooterContent(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: tokens.colorTokens.success[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.help_outline_rounded,
            color: tokens.colorTokens.success[500],
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
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: tokens.colorTokens.neutral.shade900,
                ),
              ),
              Text(
                'Documentation',
                style: TextStyle(
                  fontSize: 12,
                  color: tokens.colorTokens.neutral.shade500,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
          color: tokens.colorTokens.neutral.shade400,
        ),
      ],
    );
  }
}