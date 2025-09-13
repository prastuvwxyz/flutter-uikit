class Breakpoint {
  static const double xs = 0;
  static const double sm = 640;
  static const double md = 768;
  static const double lg = 1024;
  static const double xl = 1280;
  static const double xxl = 1536;

  static bool isXs(double width) => width < sm;
  static bool isSm(double width) => width >= sm && width < md;
  static bool isMd(double width) => width >= md && width < lg;
  static bool isLg(double width) => width >= lg && width < xl;
  static bool isXl(double width) => width >= xl && width < xxl;
  static bool isXxl(double width) => width >= xxl;

  static String getBreakpoint(double width) {
    if (isXs(width)) return 'xs';
    if (isSm(width)) return 'sm';
    if (isMd(width)) return 'md';
    if (isLg(width)) return 'lg';
    if (isXl(width)) return 'xl';
    return 'xxl';
  }
}