import 'package:flutter/material.dart';
import '../internal/token_adapters.dart';
import '../internal/a11y.dart';

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

/// Extension methods for AvatarStatus
extension AvatarStatusExtension on AvatarStatus {
  /// Color for this status
  Color getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (this) {
      case AvatarStatus.online:
        return Colors.green.shade600;
      case AvatarStatus.offline:
        return colorScheme.outline;
      case AvatarStatus.away:
        return Colors.orange.shade600;
      case AvatarStatus.busy:
        return Colors.red.shade600;
    }
  }

  /// Semantic label for accessibility
  String get semanticLabel {
    switch (this) {
      case AvatarStatus.online:
        return 'Online';
      case AvatarStatus.offline:
        return 'Offline';
      case AvatarStatus.away:
        return 'Away';
      case AvatarStatus.busy:
        return 'Busy';
    }
  }
}

/// A circular or square representation of a user's profile picture, initials, or icon
class Avatar extends StatelessWidget {
  /// Image source for the avatar
  final ImageProvider? image;

  /// Fallback text to display (usually initials)
  final String? initials;

  /// Icon to display as fallback
  final IconData? icon;

  /// Background color for the avatar
  final Color? backgroundColor;

  /// Text/icon color for the avatar
  final Color? foregroundColor;

  /// Size of the avatar
  final AvatarSize size;

  /// Shape of the avatar
  final AvatarShape shape;

  /// Status indicator to show
  final AvatarStatus? status;

  /// Whether the avatar is clickable
  final VoidCallback? onTap;

  /// Tooltip text for the avatar
  final String? tooltip;

  /// Whether the avatar is disabled
  final bool disabled;

  /// Hero tag for hero animations
  final String? heroTag;

  const Avatar({
    super.key,
    this.image,
    this.initials,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.size = AvatarSize.md,
    this.shape = AvatarShape.circle,
    this.status,
    this.onTap,
    this.tooltip,
    this.disabled = false,
    this.heroTag,
  });

  /// Factory for creating an avatar with an image
  factory Avatar.image({
    Key? key,
    required ImageProvider image,
    AvatarSize size = AvatarSize.md,
    AvatarShape shape = AvatarShape.circle,
    AvatarStatus? status,
    VoidCallback? onTap,
    String? tooltip,
    bool disabled = false,
    String? heroTag,
  }) {
    return Avatar(
      key: key,
      image: image,
      size: size,
      shape: shape,
      status: status,
      onTap: onTap,
      tooltip: tooltip,
      disabled: disabled,
      heroTag: heroTag,
    );
  }

  /// Factory for creating an avatar with initials
  factory Avatar.initials({
    Key? key,
    required String initials,
    Color? backgroundColor,
    Color? foregroundColor,
    AvatarSize size = AvatarSize.md,
    AvatarShape shape = AvatarShape.circle,
    AvatarStatus? status,
    VoidCallback? onTap,
    String? tooltip,
    bool disabled = false,
    String? heroTag,
  }) {
    return Avatar(
      key: key,
      initials: initials,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      size: size,
      shape: shape,
      status: status,
      onTap: onTap,
      tooltip: tooltip,
      disabled: disabled,
      heroTag: heroTag,
    );
  }

  /// Factory for creating an avatar with an icon
  factory Avatar.icon({
    Key? key,
    required IconData icon,
    Color? backgroundColor,
    Color? foregroundColor,
    AvatarSize size = AvatarSize.md,
    AvatarShape shape = AvatarShape.circle,
    AvatarStatus? status,
    VoidCallback? onTap,
    String? tooltip,
    bool disabled = false,
    String? heroTag,
  }) {
    return Avatar(
      key: key,
      icon: icon,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      size: size,
      shape: shape,
      status: status,
      onTap: onTap,
      tooltip: tooltip,
      disabled: disabled,
      heroTag: heroTag,
    );
  }

  /// Get the border radius based on shape
  BorderRadius _getBorderRadius() {
    final sizeData = AvatarSizeData.forSize(size);

    switch (shape) {
      case AvatarShape.circle:
        return BorderRadius.circular(sizeData.size / 2);
      case AvatarShape.square:
        return BorderRadius.zero;
      case AvatarShape.rounded:
        return BorderRadius.circular(sizeData.size * 0.2);
    }
  }

  /// Get effective colors
  ({Color background, Color foreground}) _getEffectiveColors(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (backgroundColor != null && foregroundColor != null) {
      return (
        background: backgroundColor!,
        foreground: foregroundColor!,
      );
    }

    // Default colors based on primary scheme
    final defaultBackground = colorScheme.primary;
    final defaultForeground = colorScheme.onPrimary;

    return (
      background: backgroundColor ?? defaultBackground,
      foreground: foregroundColor ?? defaultForeground,
    );
  }

  /// Build the main avatar content
  Widget _buildAvatarContent(BuildContext context) {
    final sizeData = AvatarSizeData.forSize(size);
    final colors = _getEffectiveColors(context);

    if (image != null) {
      return CircleAvatar(
        radius: sizeData.size / 2,
        backgroundImage: image,
        backgroundColor: colors.background,
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback to initials or icon on image error
        },
      );
    }

    Widget content;
    if (initials != null && initials!.isNotEmpty) {
      content = Text(
        initials!.toUpperCase(),
        style: TokenAdapters.textStyleFromTokens(
          tokenStyle: TokenTextStyle.labelLarge,
          color: colors.foreground,
        ).copyWith(
          fontSize: sizeData.fontSize,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    } else if (icon != null) {
      content = Icon(
        icon,
        size: sizeData.fontSize * 1.2,
        color: colors.foreground,
      );
    } else {
      content = Icon(
        Icons.person,
        size: sizeData.fontSize * 1.2,
        color: colors.foreground,
      );
    }

    return Container(
      width: sizeData.size,
      height: sizeData.size,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: _getBorderRadius(),
      ),
      child: Center(child: content),
    );
  }

  /// Build status indicator if present
  Widget? _buildStatusIndicator(BuildContext context) {
    if (status == null) return null;

    final sizeData = AvatarSizeData.forSize(size);
    final statusColor = status!.getColor(context);

    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        width: sizeData.statusSize,
        height: sizeData.statusSize,
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(sizeData.statusSize / 2),
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeData = AvatarSizeData.forSize(size);

    Widget avatar = _buildAvatarContent(context);

    // Add status indicator if present
    final statusIndicator = _buildStatusIndicator(context);
    if (statusIndicator != null) {
      avatar = SizedBox(
        width: sizeData.size,
        height: sizeData.size,
        child: Stack(
          children: [
            avatar,
            statusIndicator,
          ],
        ),
      );
    }

    // Add hero animation if heroTag is provided
    if (heroTag != null) {
      avatar = Hero(
        tag: heroTag!,
        child: avatar,
      );
    }

    // Add gesture detection
    if (onTap != null) {
      avatar = A11yFocusableWidget(
        semanticLabel: tooltip ?? (status != null ? status!.semanticLabel : null),
        child: GestureDetector(
          onTap: disabled ? null : onTap,
          child: MouseRegion(
            cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
            child: avatar,
          ),
        ),
      );
    }

    // Add semantics
    avatar = Semantics(
      button: onTap != null,
      enabled: !disabled,
      image: image != null,
      label: tooltip,
      child: avatar,
    );

    // Add tooltip if provided
    if (tooltip != null) {
      avatar = Tooltip(
        message: tooltip!,
        child: avatar,
      );
    }

    return avatar;
  }
}

/// A group of overlapping avatars to show multiple users
class AvatarGroup extends StatelessWidget {
  /// List of avatars to display
  final List<Avatar> avatars;

  /// Maximum number of avatars to show before showing count
  final int maxVisible;

  /// Size for all avatars in the group
  final AvatarSize size;

  /// Amount of overlap between avatars (0.0 to 1.0)
  final double overlap;

  /// Background color for the overflow count avatar
  final Color? overflowBackgroundColor;

  /// Text color for the overflow count
  final Color? overflowTextColor;

  /// Callback when overflow avatar is tapped
  final VoidCallback? onOverflowTap;

  const AvatarGroup({
    super.key,
    required this.avatars,
    this.maxVisible = 3,
    this.size = AvatarSize.md,
    this.overlap = 0.3,
    this.overflowBackgroundColor,
    this.overflowTextColor,
    this.onOverflowTap,
  });

  @override
  Widget build(BuildContext context) {
    if (avatars.isEmpty) return const SizedBox.shrink();

    final sizeData = AvatarSizeData.forSize(size);
    final overlapAmount = sizeData.size * overlap;
    final visibleAvatars = avatars.take(maxVisible).toList();
    final hasOverflow = avatars.length > maxVisible;
    final overflowCount = avatars.length - maxVisible;

    final children = <Widget>[];

    // Add visible avatars
    for (int i = 0; i < visibleAvatars.length; i++) {
      final avatar = visibleAvatars[i];

      children.add(
        Positioned(
          left: i * (sizeData.size - overlapAmount),
          child: Avatar(
            key: avatar.key,
            image: avatar.image,
            initials: avatar.initials,
            icon: avatar.icon,
            backgroundColor: avatar.backgroundColor,
            foregroundColor: avatar.foregroundColor,
            size: size,
            shape: avatar.shape,
            status: avatar.status,
            onTap: avatar.onTap,
            tooltip: avatar.tooltip,
            disabled: avatar.disabled,
            heroTag: avatar.heroTag,
          ),
        ),
      );
    }

    // Add overflow avatar if needed
    if (hasOverflow) {
      final colors = (
        background: overflowBackgroundColor ?? Theme.of(context).colorScheme.outline,
        foreground: overflowTextColor ?? Theme.of(context).colorScheme.onSurface,
      );

      children.add(
        Positioned(
          left: visibleAvatars.length * (sizeData.size - overlapAmount),
          child: Avatar.initials(
            initials: '+$overflowCount',
            backgroundColor: colors.background,
            foregroundColor: colors.foreground,
            size: size,
            onTap: onOverflowTap,
            tooltip: '$overflowCount more',
          ),
        ),
      );
    }

    final totalWidth = (visibleAvatars.length + (hasOverflow ? 1 : 0)) *
                      (sizeData.size - overlapAmount) + overlapAmount;

    return SizedBox(
      width: totalWidth,
      height: sizeData.size,
      child: Stack(
        children: children.reversed.toList(), // Reverse to show first avatar on top
      ),
    );
  }
}