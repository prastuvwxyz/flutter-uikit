import 'package:flutter/widgets.dart';
import '../internal/token_adapters.dart';

/// Screen types used for responsive design
enum ScreenType { mobile, tablet, desktop }

/// Responsive breakpoints configuration
class ResponsiveBreakpoints {
  final double mobile;
  final double tablet;
  final double desktop;

  const ResponsiveBreakpoints({
    this.mobile = 768.0,
    this.tablet = 1024.0,
    this.desktop = 1440.0,
  });

  /// Default breakpoints following common design system standards
  static const ResponsiveBreakpoints defaults = ResponsiveBreakpoints();

  /// Material Design breakpoints
  static const ResponsiveBreakpoints material = ResponsiveBreakpoints(
    mobile: 600.0,
    tablet: 1024.0,
    desktop: 1440.0,
  );

  /// Bootstrap-like breakpoints
  static const ResponsiveBreakpoints bootstrap = ResponsiveBreakpoints(
    mobile: 576.0,
    tablet: 768.0,
    desktop: 1200.0,
  );
}

/// Responsive configuration data
class ResponsiveData {
  final ScreenType screenType;
  final Size size;
  final ResponsiveBreakpoints breakpoints;
  final double devicePixelRatio;
  final bool isLandscape;

  const ResponsiveData({
    required this.screenType,
    required this.size,
    required this.breakpoints,
    this.devicePixelRatio = 1.0,
    this.isLandscape = false,
  });

  /// Get responsive value based on screen type
  T value<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Check if current screen is mobile
  bool get isMobile => screenType == ScreenType.mobile;

  /// Check if current screen is tablet
  bool get isTablet => screenType == ScreenType.tablet;

  /// Check if current screen is desktop
  bool get isDesktop => screenType == ScreenType.desktop;

  /// Check if current screen is mobile or tablet
  bool get isMobileOrTablet => isMobile || isTablet;

  /// Check if current screen is tablet or desktop
  bool get isTabletOrDesktop => isTablet || isDesktop;

  /// Get responsive spacing based on screen type using tokens
  TokenSize get responsiveSpacing {
    switch (screenType) {
      case ScreenType.mobile:
        return TokenSize.sm;
      case ScreenType.tablet:
        return TokenSize.md;
      case ScreenType.desktop:
        return TokenSize.lg;
    }
  }

  /// Get responsive text size based on screen type
  TokenTextStyle responsiveTextStyle(TokenTextStyle baseStyle) {
    if (isMobile) {
      // Use smaller text styles on mobile
      switch (baseStyle) {
        case TokenTextStyle.displayLarge:
          return TokenTextStyle.displayMedium;
        case TokenTextStyle.displayMedium:
          return TokenTextStyle.displaySmall;
        case TokenTextStyle.headlineLarge:
          return TokenTextStyle.headlineMedium;
        case TokenTextStyle.headlineMedium:
          return TokenTextStyle.headlineSmall;
        case TokenTextStyle.titleLarge:
          return TokenTextStyle.titleMedium;
        case TokenTextStyle.titleMedium:
          return TokenTextStyle.titleSmall;
        default:
          return baseStyle;
      }
    }
    return baseStyle;
  }

  /// Get responsive padding based on screen type
  TokenSize get responsivePadding {
    switch (screenType) {
      case ScreenType.mobile:
        return TokenSize.xs;
      case ScreenType.tablet:
        return TokenSize.sm;
      case ScreenType.desktop:
        return TokenSize.md;
    }
  }

  /// Get responsive margin based on screen type
  TokenSize get responsiveMargin {
    switch (screenType) {
      case ScreenType.mobile:
        return TokenSize.sm;
      case ScreenType.tablet:
        return TokenSize.md;
      case ScreenType.desktop:
        return TokenSize.lg;
    }
  }
}

/// InheritedWidget for responsive data
class _ResponsiveScope extends InheritedWidget {
  final ResponsiveData data;

  const _ResponsiveScope({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _ResponsiveScope oldWidget) {
    return oldWidget.data.screenType != data.screenType ||
        oldWidget.data.size != data.size ||
        oldWidget.data.isLandscape != data.isLandscape;
  }
}

/// Builder function type for responsive widgets
typedef ResponsiveBuilder = Widget Function(BuildContext context, ResponsiveData data);

/// Widget builder for specific screen types
typedef ResponsiveWidgetBuilder = Widget Function(BuildContext context, ScreenType screenType);

/// Responsive widget that provides screen-specific layouts
class Responsive extends StatelessWidget {
  /// Widget to show on mobile screens
  final Widget? mobile;

  /// Widget to show on tablet screens
  final Widget? tablet;

  /// Widget to show on desktop screens
  final Widget? desktop;

  /// Fallback widget if no screen-specific widget is provided
  final Widget? child;

  /// Builder function that receives responsive data
  final ResponsiveBuilder? builder;

  /// Builder function that receives screen type
  final ResponsiveWidgetBuilder? widgetBuilder;

  /// Custom breakpoints (optional)
  final ResponsiveBreakpoints? breakpoints;

  /// Whether to consider orientation in layout decisions
  final bool considerOrientation;

  const Responsive({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.child,
    this.builder,
    this.widgetBuilder,
    this.breakpoints,
    this.considerOrientation = false,
  });

  /// Factory constructor for builder pattern
  factory Responsive.builder({
    Key? key,
    required ResponsiveBuilder builder,
    ResponsiveBreakpoints? breakpoints,
    bool considerOrientation = false,
  }) {
    return Responsive(
      key: key,
      builder: builder,
      breakpoints: breakpoints,
      considerOrientation: considerOrientation,
    );
  }

  /// Factory constructor for widget builder pattern
  factory Responsive.widgets({
    Key? key,
    required ResponsiveWidgetBuilder builder,
    ResponsiveBreakpoints? breakpoints,
    bool considerOrientation = false,
  }) {
    return Responsive(
      key: key,
      widgetBuilder: builder,
      breakpoints: breakpoints,
      considerOrientation: considerOrientation,
    );
  }

  /// Get responsive data from context
  static ResponsiveData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ResponsiveScope>();
    if (scope != null) {
      return scope.data;
    }

    // Fallback: create responsive data from MediaQuery
    final mediaQuery = MediaQuery.of(context);
    final breakpoints = ResponsiveBreakpoints.defaults;
    final screenType = _getScreenType(mediaQuery.size.width, breakpoints);

    return ResponsiveData(
      screenType: screenType,
      size: mediaQuery.size,
      breakpoints: breakpoints,
      devicePixelRatio: mediaQuery.devicePixelRatio,
      isLandscape: mediaQuery.orientation == Orientation.landscape,
    );
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) => of(context).isMobile;

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) => of(context).isTablet;

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) => of(context).isDesktop;

  /// Get responsive value based on screen type
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return of(context).value<T>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive spacing token
  static TokenSize spacing(BuildContext context) => of(context).responsiveSpacing;

  /// Get responsive padding token
  static TokenSize padding(BuildContext context) => of(context).responsivePadding;

  /// Get responsive margin token
  static TokenSize margin(BuildContext context) => of(context).responsiveMargin;

  /// Get responsive text style
  static TokenTextStyle textStyle(BuildContext context, TokenTextStyle baseStyle) {
    return of(context).responsiveTextStyle(baseStyle);
  }

  /// Determine screen type based on width and breakpoints
  static ScreenType _getScreenType(double width, ResponsiveBreakpoints breakpoints) {
    if (width < breakpoints.mobile) {
      return ScreenType.mobile;
    } else if (width < breakpoints.tablet) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bp = breakpoints ?? ResponsiveBreakpoints.defaults;
    final screenType = _getScreenType(mediaQuery.size.width, bp);

    final data = ResponsiveData(
      screenType: screenType,
      size: mediaQuery.size,
      breakpoints: bp,
      devicePixelRatio: mediaQuery.devicePixelRatio,
      isLandscape: considerOrientation &&
          mediaQuery.orientation == Orientation.landscape,
    );

    Widget content;

    if (builder != null) {
      content = builder!(context, data);
    } else if (widgetBuilder != null) {
      content = widgetBuilder!(context, screenType);
    } else {
      // Choose widget based on screen type with fallbacks
      switch (screenType) {
        case ScreenType.mobile:
          content = mobile ?? child ?? const SizedBox.shrink();
          break;
        case ScreenType.tablet:
          content = tablet ?? mobile ?? child ?? const SizedBox.shrink();
          break;
        case ScreenType.desktop:
          content = desktop ?? tablet ?? mobile ?? child ?? const SizedBox.shrink();
          break;
      }
    }

    return _ResponsiveScope(
      data: data,
      child: content,
    );
  }
}

/// Extension methods for responsive utilities
extension ResponsiveExtensions on BuildContext {
  /// Get responsive data
  ResponsiveData get responsive => Responsive.of(this);

  /// Check if current screen is mobile
  bool get isMobile => Responsive.isMobile(this);

  /// Check if current screen is tablet
  bool get isTablet => Responsive.isTablet(this);

  /// Check if current screen is desktop
  bool get isDesktop => Responsive.isDesktop(this);

  /// Get responsive value
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return Responsive.value<T>(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive spacing token
  TokenSize get responsiveSpacing => Responsive.spacing(this);

  /// Get responsive padding token
  TokenSize get responsivePadding => Responsive.padding(this);

  /// Get responsive margin token
  TokenSize get responsiveMargin => Responsive.margin(this);

  /// Get responsive text style
  TokenTextStyle responsiveTextStyle(TokenTextStyle baseStyle) {
    return Responsive.textStyle(this, baseStyle);
  }
}

/// Widget that automatically adjusts its layout based on available space
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool centerContent;
  final bool useResponsivePadding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
    this.centerContent = false,
    this.useResponsivePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveData = Responsive.of(context);

    // Determine container constraints based on screen type
    final double? constraintMaxWidth = maxWidth ??
        responsiveData.value<double?>(
          mobile: null, // Full width on mobile
          tablet: 800.0,
          desktop: 1200.0,
        );

    // Use responsive padding if requested
    final EdgeInsetsGeometry effectivePadding = padding ??
        (useResponsivePadding
            ? context.padding(all: responsiveData.responsivePadding)
            : EdgeInsets.zero);

    final EdgeInsetsGeometry effectiveMargin = margin ??
        (useResponsivePadding
            ? context.margin(horizontal: responsiveData.responsiveMargin)
            : EdgeInsets.zero);

    Widget container = Container(
      constraints: constraintMaxWidth != null
          ? BoxConstraints(maxWidth: constraintMaxWidth)
          : null,
      padding: effectivePadding,
      margin: effectiveMargin,
      child: child,
    );

    if (centerContent) {
      container = Center(child: container);
    }

    return container;
  }
}

/// Widget for responsive columns/rows layout
class ResponsiveLayout extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool forceColumn;
  final bool forceRow;

  const ResponsiveLayout({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.forceColumn = false,
    this.forceRow = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveData = Responsive.of(context);

    // Determine layout direction based on screen type
    bool shouldUseColumn = forceColumn ||
        (!forceRow &&
            (responsiveData.isMobile ||
                (responsiveData.isTablet && responsiveData.isLandscape)));

    if (shouldUseColumn) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    }
  }
}