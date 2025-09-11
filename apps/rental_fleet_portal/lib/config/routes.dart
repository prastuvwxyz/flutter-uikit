import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/layouts/app.dart';
import '../views/dashboard/dashboard_page.dart';
import '../views/motorcycles/motorcycle_stocks_page.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(
            currentRoute: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/motorcycles',
            name: 'motorcycles',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const Center(
                child: Text('Motorcycles Overview - Coming Soon'),
              ),
            ),
          ),
          GoRoute(
            path: '/motorcycles/stocks',
            name: 'motorcycle-stocks',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const MotorcycleStocksPage(),
            ),
          ),
          GoRoute(
            path: '/motorcycles/maintenance',
            name: 'motorcycle-maintenance',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const Center(
                child: Text('Maintenance Motorcycles - Coming Soon'),
              ),
            ),
          ),
          GoRoute(
            path: '/rentals',
            name: 'rentals',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const Center(
                child: Text('Rentals - Coming Soon'),
              ),
            ),
          ),
          GoRoute(
            path: '/maintenance',
            name: 'maintenance',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const Center(
                child: Text('Maintenance - Coming Soon'),
              ),
            ),
          ),
          GoRoute(
            path: '/customers',
            name: 'customers',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const Center(
                child: Text('Customers - Coming Soon'),
              ),
            ),
          ),
          GoRoute(
            path: '/payments',
            name: 'payments',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const Center(
                child: Text('Payments - Coming Soon'),
              ),
            ),
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const Center(
                child: Text('Reports - Coming Soon'),
              ),
            ),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const Center(
                child: Text('Settings - Coming Soon'),
              ),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page Not Found: ${state.uri.path}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );

}
