import 'package:flutter/widgets.dart';

/// Screen types used by MinimalResponsive
enum ScreenType { mobile, tablet, desktop }

/// Simple breakpoint holder. Values are logical pixels.
class ResponsiveBreakpoints {
  final double mobile;
  final double tablet;
  final double desktop;

  const ResponsiveBreakpoints({
    this.mobile = 768,
    this.tablet = 1024,
    this.desktop = 1440,
  });
}

/// Data exposed to subtree via InheritedWidget
class ResponsiveData {
  final ScreenType screenType;
  final Size size;
  final ResponsiveBreakpoints breakpoints;

  const ResponsiveData({
    required this.screenType,
    required this.size,
    required this.breakpoints,
  });
}

class _ResponsiveScope extends InheritedWidget {
  final ResponsiveData data;

  const _ResponsiveScope({required this.data, required super.child, Key? key})
    : super(key: key);

  @override
  bool updateShouldNotify(covariant _ResponsiveScope oldWidget) {
    return oldWidget.data.screenType != data.screenType ||
        oldWidget.data.size != data.size;
  }
}

typedef ResponsiveBuilder = Widget Function(BuildContext, ScreenType);

/// Minimal responsive widget
class MinimalResponsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? child;
  final ResponsiveBuilder? builder;
  final ResponsiveBreakpoints? breakpoints;

  const MinimalResponsive({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.child,
    this.builder,
    this.breakpoints,
  });

  static ResponsiveData of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_ResponsiveScope>();
    if (scope == null) {
      final size = MediaQuery.of(context).size;
      final bp = const ResponsiveBreakpoints();
      final type = _screenTypeForWidth(size.width, bp);
      return ResponsiveData(screenType: type, size: size, breakpoints: bp);
    }
    return scope.data;
  }

  static bool isMobile(BuildContext context) =>
      of(context).screenType == ScreenType.mobile;
  static bool isTablet(BuildContext context) =>
      of(context).screenType == ScreenType.tablet;
  static bool isDesktop(BuildContext context) =>
      of(context).screenType == ScreenType.desktop;

  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? fallback,
  }) {
    final type = of(context).screenType;
    switch (type) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  static ScreenType _screenTypeForWidth(
    double width,
    ResponsiveBreakpoints bp,
  ) {
    if (width < bp.mobile) return ScreenType.mobile;
    if (width < bp.tablet) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bp = breakpoints ?? const ResponsiveBreakpoints();
    final type = _screenTypeForWidth(mq.size.width, bp);

    final data = ResponsiveData(
      screenType: type,
      size: mq.size,
      breakpoints: bp,
    );

    Widget content;
    if (builder != null) {
      content = builder!(context, type);
    } else {
      switch (type) {
        case ScreenType.mobile:
          content = mobile ?? child ?? const SizedBox.shrink();
          break;
        case ScreenType.tablet:
          content = tablet ?? mobile ?? child ?? const SizedBox.shrink();
          break;
        case ScreenType.desktop:
          content =
              desktop ?? tablet ?? mobile ?? child ?? const SizedBox.shrink();
          break;
      }
    }

    return _ResponsiveScope(data: data, child: content);
  }
}
