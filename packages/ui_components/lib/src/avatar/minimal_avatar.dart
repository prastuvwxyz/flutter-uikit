import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'avatar_types.dart';

/// A flexible avatar component that displays a user's photo, initials, or icon
/// with support for various sizes, shapes, and status indicators.
class MinimalAvatar extends StatelessWidget {
  /// Image URL or asset path
  final String? src;

  /// Accessibility description
  final String? alt;

  /// Fallback initials when image is not available
  final String? initials;

  /// Fallback icon when image and initials are not available
  final Widget? icon;

  /// Size variant of the avatar
  final AvatarSize size;

  /// Shape of the avatar
  final AvatarShape shape;

  /// Status indicator
  final AvatarStatus? status;

  /// Badge overlay (e.g., notification count)
  final Widget? badge;

  /// Background color override
  final Color? backgroundColor;

  /// Tap handler
  final VoidCallback? onTap;

  /// Creates a minimal avatar component
  const MinimalAvatar({
    super.key,
    this.src,
    this.alt,
    this.initials,
    this.icon,
    this.size = AvatarSize.md,
    this.shape = AvatarShape.circle,
    this.status,
    this.badge,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final sizeData = AvatarSizeData.forSize(size);
    final avatarSize = sizeData.size;

    // Determine border radius based on shape
    final BorderRadius borderRadius;
    switch (shape) {
      case AvatarShape.circle:
        borderRadius = BorderRadius.circular(avatarSize);
      case AvatarShape.square:
        borderRadius = BorderRadius.zero;
      case AvatarShape.rounded:
        borderRadius = BorderRadius.circular(tokens.radiusTokens.md);
    }

    // Determine background color
    final bgColor = backgroundColor ?? tokens.colorTokens.primary.shade100;

    return Semantics(
      label:
          alt ?? 'Avatar${initials != null ? ' with initials $initials' : ''}',
      image: true,
      child: Stack(
        children: [
          // Interactive container
          InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: _buildAvatarContent(context, sizeData, bgColor),
              ),
            ),
          ),

          // Status indicator
          if (status != null) _buildStatusIndicator(context, sizeData),

          // Badge overlay
          if (badge != null) Positioned(top: 0, right: 0, child: badge!),
        ],
      ),
    );
  }

  /// Builds the avatar content (image, initials, or icon)
  Widget _buildAvatarContent(
    BuildContext context,
    AvatarSizeData sizeData,
    Color backgroundColor,
  ) {
    // If image URL is provided, try to load it
    if (src != null) {
      return _buildImageAvatar(context, sizeData, backgroundColor);
    }

    // If initials are provided, use them as fallback
    if (initials != null && initials!.isNotEmpty) {
      return _buildInitialsAvatar(context, sizeData, backgroundColor);
    }

    // Otherwise use icon or default person icon
    return _buildIconAvatar(context, sizeData, backgroundColor);
  }

  /// Builds an avatar with an image
  Widget _buildImageAvatar(
    BuildContext context,
    AvatarSizeData sizeData,
    Color backgroundColor,
  ) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();

    return Image.network(
      src!,
      width: sizeData.size,
      height: sizeData.size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fall back to initials or icon on error
        if (initials != null && initials!.isNotEmpty) {
          return _buildInitialsAvatar(context, sizeData, backgroundColor);
        }
        return _buildIconAvatar(context, sizeData, backgroundColor);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        // Show skeleton loader while loading
        return Container(
          width: sizeData.size,
          height: sizeData.size,
          color: tokens.colorTokens.neutral[200],
        );
      },
    );
  }

  /// Builds an avatar with initials
  Widget _buildInitialsAvatar(
    BuildContext context,
    AvatarSizeData sizeData,
    Color backgroundColor,
  ) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final textColor = tokens.colorTokens.primary.shade700;

    // Use initials directly if they're already formatted correctly
    String displayInitials = initials!;

    // If initials contain spaces, extract first letter of each word (up to 2)
    if (displayInitials.contains(' ')) {
      displayInitials = displayInitials
          .trim()
          .split(' ')
          .take(2)
          .map((name) => name.isNotEmpty ? name[0] : '')
          .join('')
          .toUpperCase();
    }

    // Limit to 2 characters
    if (displayInitials.length > 2) {
      displayInitials = displayInitials.substring(0, 2);
    }

    return Container(
      width: sizeData.size,
      height: sizeData.size,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Text(
        displayInitials.toUpperCase(),
        style: TextStyle(
          fontSize: sizeData.fontSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  /// Builds an avatar with an icon
  Widget _buildIconAvatar(
    BuildContext context,
    AvatarSizeData sizeData,
    Color backgroundColor,
  ) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final iconSize = sizeData.size * 0.5;
    final iconColor = tokens.colorTokens.primary.shade700;

    return Container(
      width: sizeData.size,
      height: sizeData.size,
      color: backgroundColor,
      alignment: Alignment.center,
      child: icon ?? Icon(Icons.person, size: iconSize, color: iconColor),
    );
  }

  /// Builds the status indicator
  Widget _buildStatusIndicator(BuildContext context, AvatarSizeData sizeData) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();

    // Determine status color
    final Color statusColor;
    switch (status!) {
      case AvatarStatus.online:
        statusColor = tokens.colorTokens.success[500]!;
      case AvatarStatus.offline:
        statusColor = tokens.colorTokens.neutral[400];
      case AvatarStatus.away:
        statusColor = tokens.colorTokens.warning[500]!;
      case AvatarStatus.busy:
        statusColor = tokens.colorTokens.error[500]!;
    }

    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        width: sizeData.statusSize,
        height: sizeData.statusSize,
        decoration: BoxDecoration(
          color: statusColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: sizeData.statusSize * 0.2,
          ),
        ),
      ),
    );
  }
}
