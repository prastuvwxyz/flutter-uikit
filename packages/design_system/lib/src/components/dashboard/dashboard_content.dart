import 'package:flutter/material.dart';
import '../../tokens/ui_tokens.dart';

/// Dashboard content container following Material Kit React patterns
/// 
/// Provides consistent spacing, responsive behavior, and max-width constraints
/// for dashboard content sections. Uses CSS-like spacing variables for consistency.
class DashboardContent extends StatelessWidget {
  /// The main content to display
  final Widget child;
  
  /// Maximum width constraint ('xs', 'sm', 'md', 'lg', 'xl', or null for no constraint)
  final String? maxWidth;
  
  /// Additional padding around the content
  final EdgeInsetsGeometry? padding;
  
  /// Whether to use responsive padding that adapts to screen size
  final bool responsivePadding;

  const DashboardContent({
    super.key,
    required this.child,
    this.maxWidth = 'xl',
    this.padding,
    this.responsivePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        
        // Calculate responsive padding
        final horizontalPadding = responsivePadding 
            ? _getResponsivePadding(screenWidth)
            : 24.0;
            
        final verticalPadding = responsivePadding 
            ? _getVerticalPadding(screenWidth)
            : 24.0;
        
        Widget content = Container(
          width: double.infinity,
          constraints: _getMaxWidthConstraints(screenWidth),
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: child,
        );
        
        // Center content if maxWidth is set
        if (maxWidth != null) {
          content = Center(child: content);
        }
        
        return content;
      },
    );
  }
  
  /// Get responsive horizontal padding based on screen width
  double _getResponsivePadding(double screenWidth) {
    if (screenWidth >= 1200) return 40.0; // xl
    if (screenWidth >= 900) return 32.0;  // lg
    if (screenWidth >= 600) return 24.0;  // md
    return 16.0; // sm/xs
  }
  
  /// Get responsive vertical padding based on screen width
  double _getVerticalPadding(double screenWidth) {
    if (screenWidth >= 900) return 32.0;  // lg+
    if (screenWidth >= 600) return 24.0;  // md
    return 16.0; // sm/xs
  }
  
  /// Get max width constraints based on breakpoint
  BoxConstraints? _getMaxWidthConstraints(double screenWidth) {
    if (maxWidth == null) return null;
    
    switch (maxWidth) {
      case 'xs':
        return const BoxConstraints(maxWidth: 444);
      case 'sm':
        return const BoxConstraints(maxWidth: 600);
      case 'md':
        return const BoxConstraints(maxWidth: 900);
      case 'lg':
        return const BoxConstraints(maxWidth: 1200);
      case 'xl':
        return const BoxConstraints(maxWidth: 1536);
      default:
        return null;
    }
  }
}

/// Responsive grid system following Material Kit React patterns
class DashboardGrid extends StatelessWidget {
  /// Child widgets to display in the grid
  final List<Widget> children;
  
  /// Spacing between grid items
  final double spacing;
  
  /// Responsive column configuration (xs, sm, md, lg, xl)
  final GridBreakpoints breakpoints;

  const DashboardGrid({
    super.key,
    required this.children,
    this.spacing = 24.0,
    this.breakpoints = const GridBreakpoints(),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final columns = _getColumns(screenWidth);
        
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((child) {
            final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
  
  int _getColumns(double screenWidth) {
    if (screenWidth >= 1536) return breakpoints.xl;
    if (screenWidth >= 1200) return breakpoints.lg;
    if (screenWidth >= 900) return breakpoints.md;
    if (screenWidth >= 600) return breakpoints.sm;
    return breakpoints.xs;
  }
}

/// Configuration class for responsive grid breakpoints
class GridBreakpoints {
  final int xs;
  final int sm;
  final int md;
  final int lg;
  final int xl;
  
  const GridBreakpoints({
    this.xs = 1,
    this.sm = 2,
    this.md = 3,
    this.lg = 4,
    this.xl = 4,
  });
  
  /// Common breakpoint configuration for summary cards (4 across on desktop)
  static const summaryCards = GridBreakpoints(
    xs: 1,
    sm: 2,
    md: 2,
    lg: 4,
    xl: 4,
  );
  
  /// Common breakpoint configuration for analytics cards (3 across on desktop)
  static const analyticsCards = GridBreakpoints(
    xs: 1,
    sm: 1,
    md: 2,
    lg: 3,
    xl: 3,
  );
  
  /// Common breakpoint configuration for content cards (2 across on desktop)
  static const contentCards = GridBreakpoints(
    xs: 1,
    sm: 1,
    md: 2,
    lg: 2,
    xl: 2,
  );
}

/// Dashboard section with title and optional actions
class DashboardSection extends StatelessWidget {
  /// Section title
  final String title;
  
  /// Optional subtitle
  final String? subtitle;
  
  /// Section content
  final Widget child;
  
  /// Optional action widgets (e.g., buttons, links)
  final List<Widget>? actions;
  
  /// Spacing between title and content
  final double spacing;

  const DashboardSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions,
    this.spacing = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: tokens.colorTokens.neutral.shade900,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: tokens.colorTokens.neutral.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (actions != null) ...[
              const SizedBox(width: 16),
              ...actions!.map((action) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: action,
              )),
            ],
          ],
        ),
        SizedBox(height: spacing),
        child,
      ],
    );
  }
}