import 'package:flutter/material.dart';
import 'color_tokens.dart';
import 'typography_tokens.dart';
import 'spacing_tokens.dart';
import 'radius_tokens.dart';
import 'elevation_tokens.dart';
import 'motion_tokens.dart';

/// UiTokens is the main class that contains all design tokens
/// for the Flutter UI Kit.
///
/// This class provides access to color, typography, spacing,
/// radius, elevation, and motion tokens that maintain design
/// consistency across the UI Kit.
class UiTokens extends ThemeExtension<UiTokens> {
  /// Primary, secondary, and semantic color tokens
  final UiColorTokens colorTokens;

  /// Font families, sizes, weights
  final UiTypographyTokens typographyTokens;

  /// 4px base unit scaling
  final UiSpacingTokens spacingTokens;

  /// Border radius scale
  final UiRadiusTokens radiusTokens;

  /// Shadow and elevation
  final UiElevationTokens elevationTokens;

  /// Durations and curves
  final UiMotionTokens motionTokens;

  /// Creates a UiTokens instance with the provided token sets.
  const UiTokens({
    this.colorTokens = const UiColorTokens.material3(),
    required this.typographyTokens,
    required this.spacingTokens,
    required this.radiusTokens,
    required this.elevationTokens,
    required this.motionTokens,
  });
  
  /// Default constructor with standard values
  factory UiTokens.standard() {
    return UiTokens(
      typographyTokens: UiTypographyTokens.standard(),
      spacingTokens: const UiSpacingTokens.standard(),
      radiusTokens: const UiRadiusTokens.standard(),
      elevationTokens: UiElevationTokens.material3(),
      motionTokens: UiMotionTokens.standard(),
    );
  }

  /// Create a new instance of UiTokens with updated values.
  @override
  UiTokens copyWith({
    UiColorTokens? colorTokens,
    UiTypographyTokens? typographyTokens,
    UiSpacingTokens? spacingTokens,
    UiRadiusTokens? radiusTokens,
    UiElevationTokens? elevationTokens,
    UiMotionTokens? motionTokens,
  }) {
    return UiTokens(
      colorTokens: colorTokens ?? this.colorTokens,
      typographyTokens: typographyTokens ?? this.typographyTokens,
      spacingTokens: spacingTokens ?? this.spacingTokens,
      radiusTokens: radiusTokens ?? this.radiusTokens,
      elevationTokens: elevationTokens ?? this.elevationTokens,
      motionTokens: motionTokens ?? this.motionTokens,
    );
  }

  /// Lerp between two UiTokens instances.
  @override
  UiTokens lerp(UiTokens? other, double t) {
    if (other == null) return this;
    
    return UiTokens(
      colorTokens: colorTokens.lerp(other.colorTokens, t),
      typographyTokens: typographyTokens.lerp(other.typographyTokens, t),
      spacingTokens: spacingTokens.lerp(other.spacingTokens, t),
      radiusTokens: radiusTokens.lerp(other.radiusTokens, t),
      elevationTokens: elevationTokens.lerp(other.elevationTokens, t),
      motionTokens: motionTokens.lerp(other.motionTokens, t),
    );
  }

  /// Helper to access tokens from BuildContext
  static UiTokens of(BuildContext context) {
    return Theme.of(context).extension<UiTokens>() ?? 
           UiTokens.standard();
  }
  
  /// Create a dark mode version of these tokens
  UiTokens get dark {
    return copyWith(
      colorTokens: colorTokens.dark,
      elevationTokens: elevationTokens.dark,
    );
  }
  
  /// Create a high-contrast version of these tokens
  UiTokens get highContrast {
    return copyWith(
      colorTokens: colorTokens.highContrast,
    );
  }
}
