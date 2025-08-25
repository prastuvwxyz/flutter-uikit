/// Defines breakpoints for responsive grid layouts
class GridBreakpoints {
  /// Creates a set of grid breakpoints for different screen sizes
  ///
  /// * [mobile] - Number of columns to use on mobile screens
  /// * [tablet] - Number of columns to use on tablet screens
  /// * [desktop] - Number of columns to use on desktop screens
  /// * [mobileWidth] - Maximum width for mobile breakpoint (default: 600)
  /// * [tabletWidth] - Maximum width for tablet breakpoint (default: 960)
  const GridBreakpoints({
    this.mobile = 1,
    this.tablet = 2,
    this.desktop = 4,
    this.mobileWidth = 600,
    this.tabletWidth = 960,
  });

  /// Number of columns for mobile screens
  final int mobile;

  /// Number of columns for tablet screens
  final int tablet;

  /// Number of columns for desktop screens
  final int desktop;

  /// Maximum width for mobile breakpoint
  final double mobileWidth;

  /// Maximum width for tablet breakpoint
  final double tabletWidth;

  /// Default grid breakpoint configuration
  static const GridBreakpoints standard = GridBreakpoints();

  /// Returns the number of columns based on the current screen width
  int columnsForWidth(double width) {
    if (width <= mobileWidth) {
      return mobile;
    } else if (width <= tabletWidth) {
      return tablet;
    } else {
      return desktop;
    }
  }
}
