/// Defines available size options for MinimalDialog
enum DialogSize {
  /// Small dialog (400px)
  sm,

  /// Medium dialog (560px) - default
  md,

  /// Large dialog (720px)
  lg,

  /// Extra large dialog (960px)
  xl,

  /// Full screen dialog
  fullscreen,
}

/// Extension to get width values for each dialog size
extension DialogSizeExtension on DialogSize {
  /// Returns the width in logical pixels for this dialog size
  double get width {
    switch (this) {
      case DialogSize.sm:
        return 400.0;
      case DialogSize.md:
        return 560.0;
      case DialogSize.lg:
        return 720.0;
      case DialogSize.xl:
        return 960.0;
      case DialogSize.fullscreen:
        return double.infinity;
    }
  }

  /// Returns if this dialog size is fullscreen
  bool get isFullscreen => this == DialogSize.fullscreen;
}
