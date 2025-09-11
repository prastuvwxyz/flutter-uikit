/// Avatar size variants
enum AvatarSize {
  /// Extra small (24px)
  xs,

  /// Small (32px)
  sm,

  /// Medium (40px) - default
  md,

  /// Large (48px)
  lg,

  /// Extra large (56px)
  xl,

  /// 2x large (64px)
  xl2,
}

/// Avatar shape variants
enum AvatarShape {
  /// Circular avatar
  circle,

  /// Square avatar
  square,

  /// Rounded square avatar
  rounded,
}

/// Avatar status indicators
enum AvatarStatus {
  /// Online status (green)
  online,

  /// Offline status (gray)
  offline,

  /// Away status (yellow)
  away,

  /// Busy status (red)
  busy,
}

/// Internal mapping for avatar size dimensions
class AvatarSizeData {
  /// Size dimension in logical pixels
  final double size;

  /// Font size to use for initials
  final double fontSize;

  /// Status indicator size
  final double statusSize;

  /// Create avatar size data
  const AvatarSizeData({
    required this.size,
    required this.fontSize,
    required this.statusSize,
  });

  /// Get size data for a specific avatar size
  static AvatarSizeData forSize(AvatarSize size) {
    switch (size) {
      case AvatarSize.xs:
        return const AvatarSizeData(size: 24, fontSize: 12, statusSize: 6);
      case AvatarSize.sm:
        return const AvatarSizeData(size: 32, fontSize: 14, statusSize: 8);
      case AvatarSize.md:
        return const AvatarSizeData(size: 40, fontSize: 16, statusSize: 10);
      case AvatarSize.lg:
        return const AvatarSizeData(size: 48, fontSize: 18, statusSize: 12);
      case AvatarSize.xl:
        return const AvatarSizeData(size: 56, fontSize: 20, statusSize: 14);
      case AvatarSize.xl2:
        return const AvatarSizeData(size: 64, fontSize: 24, statusSize: 16);
    }
  }
}
