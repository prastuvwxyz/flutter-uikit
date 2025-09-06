import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'header.dart';

/// A responsive DashboardTemplate matching Minimal UI patterns.
class DashboardTemplate extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const DashboardTemplate({
    Key? key,
    this.appBar,
    this.drawer,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1024;
    final bool isTablet = width >= 720 && width < 1024;

    return Scaffold(
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.background,
      // prefer provided appBar; if none, show Header on mobile/desktop as needed
      appBar: appBar ?? (isDesktop ? null : const Header()),
      drawer: isDesktop ? null : drawer ?? Drawer(child: const Sidebar()),
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar for desktop/tablet
            if (isDesktop) SizedBox(width: 280, child: const Sidebar()),
            if (isTablet) SizedBox(width: 220, child: const Sidebar()),
            // Content area
            Expanded(
              child: Column(
                children: [
                  // Show header only when no external appBar is provided
                  if (isDesktop && appBar == null) const Header(),
                  Expanded(child: body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
