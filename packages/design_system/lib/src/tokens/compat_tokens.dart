import 'package:flutter/material.dart';
import 'ui_tokens.dart';
import 'spacing_tokens.dart';
import 'radius_tokens.dart';
import 'elevation_tokens.dart';
import 'typography_tokens.dart';

/// Compatibility facade for legacy token names used across the codebase.
/// Provides simple static accessors that map to the new UiTokens-based API.

/// Legacy-style accessors for colors (e.g. `ColorTokens.surface`).
/// These are thin wrappers around `UiTokens.standard()` to avoid mass refactors.
// Note: `ColorTokens` is provided in `color_tokens.dart` so we don't
// duplicate it here. The remaining legacy wrappers are below.

/// Legacy spacing names (e.g. `SpacingTokens.md`).
class SpacingTokens {
  static final UiSpacingTokens _s = UiTokens.standard().spacingTokens;

  static double get xs => _s.xs;
  static double get sm => _s.sm;
  static double get md => _s.md;
  static double get lg => _s.lg;
  static double get xl => _s.xl;
  static double get xxl => _s.xxl;
  static double get xxxl => _s.xxxl;
  static double get xxxxl => _s.xxxxl;
}

/// Legacy radius names (e.g. `RadiusTokens.md`).
class RadiusTokens {
  static final UiRadiusTokens _r = UiTokens.standard().radiusTokens;

  static double get none => _r.none;
  static double get sm => _r.sm;
  static double get md => _r.md;
  static double get lg => _r.lg;
  static double get xl => _r.xl;
}

/// Legacy elevation tokens.
class ElevationTokens {
  static final UiElevationTokens _e = UiTokens.standard().elevationTokens;

  static double get level0 => _e.level0;
  static double get level1 => _e.level1;
  static double get level2 => _e.level2;
  static double get level3 => _e.level3;
  // convenience alias used in older code
  static double get md => _e.level2;
}

/// Legacy typography shortcuts (e.g. `TypographyTokens.labelMd`).
class TypographyTokens {
  static final UiTypographyTokens _t = UiTokens.standard().typographyTokens;

  static TextStyle get labelMd => _t.labelMedium;
  static TextStyle get labelSm => _t.labelSmall;
  static TextStyle get bodyMd => _t.bodyMedium;
  static TextStyle get bodySm => _t.bodySmall;
}
