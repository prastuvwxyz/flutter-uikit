import 'package:flutter/material.dart';
import 'package:ui/ui.dart' as ui;
import 'package:go_router/go_router.dart';
import 'package:tokens/tokens.dart' as tokens;

class AppLayout extends StatelessWidget {
  final String currentRoute;
  final Widget child;

  const AppLayout({super.key, required this.currentRoute, required this.child});

  @override
  Widget build(BuildContext context) {
    return ui.AppShell(
      child: child,
      currentRoute: currentRoute,
      navigationConfig: ui.NavigationConfig(
        sections: _getNavigationSections(),
        onRouteChanged: (route) {
          context.go(route);
        },
      ),
      brandConfig: const ui.BrandConfig(
        title: 'Operation Fleet',
        subtitle: 'Fleet Management Portal',
        fallbackIcon: Icons.motorcycle_rounded,
      ),
      footerContent: _buildFooterContent(context),
    );
  }

  List<ui.NavigationSection> _getNavigationSections() {
    return [
      ui.NavigationSection(
        title: 'OVERVIEW',
        items: [
          ui.NavigationItem(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard_rounded,
            label: 'Dashboard',
            route: '/',
          ),
        ],
      ),
      ui.NavigationSection(
        title: 'ASSET MANAGEMENT',
        items: [
          ui.NavigationItem(
            icon: Icons.motorcycle_outlined,
            selectedIcon: Icons.motorcycle_rounded,
            label: 'Assets',
            route: '/assets',
            children: [
              ui.NavigationItem(
                icon: Icons.inventory_2_outlined,
                selectedIcon: Icons.inventory_2_rounded,
                label: 'Motorcycle Stocks',
                route: '/assets/motorcycle/stocks',
              ),
              ui.NavigationItem(
                icon: Icons.add_box_outlined,
                selectedIcon: Icons.add_box_rounded,
                label: 'In Maintenance Motorcycle',
                route: '/motorcycles/maintenance',
              ),
            ],
          ),
          ui.NavigationItem(
            icon: Icons.build_outlined,
            selectedIcon: Icons.build_rounded,
            label: 'Maintenance',
            route: '/maintenance',
          ),
        ],
      ),
      ui.NavigationSection(
        title: 'BUSINESS',
        items: [
          ui.NavigationItem(
            icon: Icons.people_outline,
            selectedIcon: Icons.people_rounded,
            label: 'Customers',
            route: '/customers',
          ),
          ui.NavigationItem(
            icon: Icons.handshake_outlined,
            selectedIcon: Icons.handshake_rounded,
            label: 'Rental',
            route: '/rental',
            children: [
              ui.NavigationItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person_rounded,
                label: 'Rent to Customer',
                route: '/rental/customer',
              ),
              ui.NavigationItem(
                icon: Icons.business_outlined,
                selectedIcon: Icons.business_rounded,
                label: 'Rent to Partner',
                route: '/rental/partner',
              ),
            ],
          ),
        ],
      ),
      ui.NavigationSection(
        title: 'TRANSACTIONS',
        items: [
          ui.NavigationItem(
            icon: Icons.people_outline,
            selectedIcon: Icons.people_rounded,
            label: 'Swap',
            route: '/transaction/swap',
          ),
          ui.NavigationItem(
            icon: Icons.people_outline,
            selectedIcon: Icons.people_rounded,
            label: 'Purchase Package',
            route: '/transaction/purchase',
          ),
          ui.NavigationItem(
            icon: Icons.people_outline,
            selectedIcon: Icons.people_rounded,
            label: 'Rental Payment',
            route: '/transaction/rental-payment',
          ),
        ],
      ),
    ];
  }

  Widget _buildFooterContent(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.help_outline_rounded,
            color: theme.colorScheme.onSecondaryContainer,
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
}
