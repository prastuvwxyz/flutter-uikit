# Flutter Design System

A comprehensive Flutter design system built for modern dashboard applications. This design system follows Material Kit React patterns and provides reusable components, consistent theming, and responsive layouts.

## 🎯 Overview

This design system is designed to:
- **Provide consistent UI components** across multiple applications
- **Follow Material Design 3 principles** with custom enhancements
- **Support responsive layouts** for web, mobile, and desktop
- **Enable rapid dashboard development** with pre-built components
- **Maintain design consistency** through design tokens and theming

## 📁 Project Structure

```
packages/design_system/
├── lib/
│   ├── design_system.dart          # Main export file
│   └── src/
│       ├── components/             # Reusable UI components
│       │   ├── button/            # Button components
│       │   ├── container/         # Container components
│       │   ├── dashboard/         # Dashboard-specific components
│       │   ├── select/            # Select/dropdown components
│       │   └── text_field/        # Input components
│       ├── templates/             # Page templates
│       │   ├── dashboard/         # Dashboard template
│       │   └── mail.dart          # Mail template
│       ├── theme/                 # Theme extensions
│       └── tokens/                # Design tokens
│           ├── ui_tokens.dart     # Main token system
│           ├── color_tokens.dart  # Color palette
│           ├── typography_tokens.dart # Text styles
│           ├── spacing_tokens.dart # Spacing system
│           ├── radius_tokens.dart # Border radius
│           ├── elevation_tokens.dart # Shadow/elevation
│           └── motion_tokens.dart # Animation/transitions
└── README.md                      # This file
```

## 🚀 Getting Started

### Installation

Add the design system to your `pubspec.yaml`:

```yaml
dependencies:
  design_system:
    path: ../../packages/design_system
```

### Basic Usage

```dart
import 'package:design_system/design_system.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Dashboard',
      theme: ThemeData(
        // Your theme configuration
        useMaterial3: true,
      ),
      home: UiTokens(
        child: MyDashboard(),
      ),
    );
  }
}
```

## 🎨 Design Tokens

### Color System

The design system uses a semantic color palette:

```dart
final tokens = UiTokens.of(context);

// Primary colors
tokens.colorTokens.primary.shade500    // Main brand color
tokens.colorTokens.primary.shade50     // Light background

// Semantic colors
tokens.colorTokens.success[500]        // Success green
tokens.colorTokens.warning[500]        // Warning amber
tokens.colorTokens.error[500]          // Error red

// Neutral colors
tokens.colorTokens.neutral.shade900    // Dark text
tokens.colorTokens.neutral.shade600    // Medium text
tokens.colorTokens.neutral.shade200    // Light borders
```

### Typography

Consistent text styles using design tokens:

```dart
Text(
  'Dashboard Title',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: tokens.colorTokens.neutral.shade900,
  ),
)
```

### Spacing System

Consistent spacing using 8px base unit:

```dart
// Common spacing values
const EdgeInsets.all(8)   // xs
const EdgeInsets.all(16)  // sm
const EdgeInsets.all(24)  // md (recommended default)
const EdgeInsets.all(32)  // lg
const EdgeInsets.all(40)  // xl
```

## 🧩 Core Components

### Dashboard Components

#### DashboardContent
Main container for dashboard pages with responsive padding and max-width constraints.

```dart
DashboardContent(
  maxWidth: 'xl',  // xs, sm, md, lg, xl, or null
  child: YourContent(),
)
```

#### DashboardGrid
Responsive grid system following Material Kit React patterns.

```dart
DashboardGrid(
  spacing: 24,
  breakpoints: GridBreakpoints.summaryCards, // or analyticsCards, contentCards
  children: [
    // Your grid items
  ],
)
```

#### DashboardSection
Section wrapper with title, subtitle, and consistent spacing.

```dart
DashboardSection(
  title: 'Analytics',
  subtitle: 'Performance metrics and trends',
  child: YourSectionContent(),
)
```

### Card Components

#### SummaryCard
Summary metrics card with icon, trend indicator, and optional mini chart.

```dart
SummaryCard(
  title: 'Total Revenue',
  value: '\$52.4K',
  icon: Icons.attach_money_rounded,
  iconColor: Colors.green,
  percentage: 8.5,
  backgroundColor: Colors.green, // Optional gradient background
  trendChart: SimpleLineChart(data: [1, 2, 3, 4, 5]),
  onTap: () => Navigator.push(...),
)
```

#### AnalyticsCard
Detailed analytics card with charts and trend indicators.

```dart
AnalyticsCard(
  title: 'Revenue Growth',
  value: '\$52,140',
  subtitle: 'vs last month',
  percentage: 8.5,
  isPositiveTrend: true,
  icon: Icon(Icons.trending_up_rounded),
  chart: SimpleLineChart(data: chartData),
)
```

#### RecentActivityCard
Activity feed card with list of recent actions.

```dart
RecentActivityCard(
  title: 'Recent Activity',
  onViewAll: () => navigateToActivity(),
  activities: [
    ActivityItem(
      icon: Icons.add_circle_outline_rounded,
      iconColor: Colors.green,
      title: 'New Vehicle Added',
      subtitle: 'Toyota Camry 2024',
      time: '2 hours ago',
    ),
  ],
)
```

### Layout Components

#### MinimalContainer
Flexible container with customizable styling options.

```dart
// Basic container
MinimalContainer(
  padding: EdgeInsets.all(24),
  child: YourContent(),
)

// Card-styled container
MinimalContainer.card(
  child: YourContent(),
)

// Bordered container
MinimalContainer.bordered(
  borderColor: Colors.grey,
  child: YourContent(),
)
```

## 📐 Responsive Patterns

### Breakpoints

The design system uses these responsive breakpoints:

- **xs**: 0-599px (mobile)
- **sm**: 600-899px (small tablet)
- **md**: 900-1199px (tablet)
- **lg**: 1200-1535px (small desktop)
- **xl**: 1536px+ (large desktop)

### Grid Configurations

Pre-defined responsive configurations:

```dart
// Summary cards: 1→2→2→4→4 across
GridBreakpoints.summaryCards

// Analytics cards: 1→1→2→3→3 across
GridBreakpoints.analyticsCards

// Content cards: 1→1→2→2→2 across
GridBreakpoints.contentCards
```

## 🏗️ Templates

### DashboardTemplate
Complete dashboard layout with sidebar, header, and content area.

```dart
DashboardTemplate(
  selectedRoute: '/dashboard',
  onRouteChanged: (route) => setState(() => _selectedRoute = route),
  navigationSections: [
    NavigationSection(
      title: 'OVERVIEW',
      items: [
        NavigationItem(
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard_rounded,
          label: 'Dashboard',
          route: '/dashboard',
        ),
      ],
    ),
  ],
  brandConfig: BrandConfig(
    title: 'Your App',
    subtitle: 'Dashboard',
    fallbackIcon: Icons.dashboard,
  ),
  body: YourPageContent(),
)
```

## 🎯 Best Practices

### Layout Structure

Follow this hierarchy for consistent layouts:

```dart
DashboardTemplate(
  body: DashboardContent(
    child: Column(
      children: [
        DashboardSection(
          title: 'Section Title',
          child: DashboardGrid(
            breakpoints: GridBreakpoints.summaryCards,
            children: [
              // Your cards here
            ],
          ),
        ),
      ],
    ),
  ),
)
```

### Color Usage

- Use semantic colors for consistent meaning
- Primary colors for main actions and navigation
- Success/Warning/Error colors for status and feedback
- Neutral colors for text and backgrounds

### Spacing

- Use 24px as the standard spacing unit for most layouts
- Use 16px for compact spacing (mobile, card interiors)
- Use 40px for section separation
- Maintain consistent vertical rhythm

### Typography

- Use design tokens for consistent text styles
- Follow font weight hierarchy: 400 (normal), 500 (medium), 600 (semi-bold), 700 (bold)
- Maintain proper contrast ratios for accessibility

## 📱 Platform Support

- ✅ **Web**: Full responsive support
- ✅ **iOS**: Native iOS styling adaptations
- ✅ **Android**: Material Design 3 compliance
- ✅ **macOS**: Desktop-optimized layouts
- ✅ **Windows**: Windows 11 design patterns
- ✅ **Linux**: Cross-platform compatibility

## 🔧 Customization

### Custom Tokens

Extend the token system for your brand:

```dart
// Create custom color tokens
final customTokens = UiTokens.customize(
  colorTokens: CustomColorTokens(),
  typographyTokens: CustomTypographyTokens(),
);
```

### Custom Components

Build on existing components:

```dart
class CustomSummaryCard extends SummaryCard {
  // Add your customizations
}
```

## 📚 Examples

Check the `apps/rental_fleet_portal` directory for a complete implementation example showing:

- Dashboard layout setup
- Responsive grid usage
- Card component implementation
- Navigation configuration
- Theme integration

## 🤝 Contributing

1. **Follow design token patterns** for consistency
2. **Write comprehensive documentation** for new components
3. **Include usage examples** with code samples
4. **Test across all supported platforms**
5. **Follow Flutter best practices** and conventions

## 📄 License

This design system is part of the Flutter UIKit project and follows the same licensing terms.