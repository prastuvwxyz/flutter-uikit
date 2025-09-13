import 'package:flutter/material.dart';
import 'package:tokens/tokens.dart' as tokens;

/// Adapters and utilities for working with design tokens in the UI package.
///
/// This library provides helper functions and adapters to bridge between
/// the tokens system and Flutter's theme system, making it easier to access
/// and apply design tokens consistently across components.

/// Helper class for accessing and converting design tokens
class TokenAdapters {
  TokenAdapters._();

  /// Get spacing values using token size names (xs, sm, md, etc.)
  static EdgeInsets paddingFromTokens({
    required BuildContext context,
    TokenSize? all,
    TokenSize? horizontal,
    TokenSize? vertical,
    TokenSize? top,
    TokenSize? right,
    TokenSize? bottom,
    TokenSize? left,
  }) {
    final spacing = tokens.Spacing.of(context);

    if (all != null) {
      return EdgeInsets.all(_getSpacingValue(spacing, all));
    }

    return EdgeInsets.only(
      top: top != null ? _getSpacingValue(spacing, top) :
          (vertical != null ? _getSpacingValue(spacing, vertical) : 0),
      right: right != null ? _getSpacingValue(spacing, right) :
             (horizontal != null ? _getSpacingValue(spacing, horizontal) : 0),
      bottom: bottom != null ? _getSpacingValue(spacing, bottom) :
              (vertical != null ? _getSpacingValue(spacing, vertical) : 0),
      left: left != null ? _getSpacingValue(spacing, left) :
           (horizontal != null ? _getSpacingValue(spacing, horizontal) : 0),
    );
  }

  /// Get margin values using token size names
  static EdgeInsets marginFromTokens({
    required BuildContext context,
    TokenSize? all,
    TokenSize? horizontal,
    TokenSize? vertical,
    TokenSize? top,
    TokenSize? right,
    TokenSize? bottom,
    TokenSize? left,
  }) {
    return paddingFromTokens(
      context: context,
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );
  }

  /// Get border radius from tokens
  static BorderRadius radiusFromTokens({
    required BuildContext context,
    TokenRadiusSize? all,
    TokenRadiusSize? topLeft,
    TokenRadiusSize? topRight,
    TokenRadiusSize? bottomLeft,
    TokenRadiusSize? bottomRight,
  }) {
    final radius = tokens.Radius.of(context);

    if (all != null) {
      return BorderRadius.circular(_getRadiusValue(radius, all));
    }

    return BorderRadius.only(
      topLeft: Radius.circular(topLeft != null ? _getRadiusValue(radius, topLeft) : 0),
      topRight: Radius.circular(topRight != null ? _getRadiusValue(radius, topRight) : 0),
      bottomLeft: Radius.circular(bottomLeft != null ? _getRadiusValue(radius, bottomLeft) : 0),
      bottomRight: Radius.circular(bottomRight != null ? _getRadiusValue(radius, bottomRight) : 0),
    );
  }

  /// Get typography from tokens with style overrides
  static TextStyle textStyleFromTokens({
    required TokenTextStyle tokenStyle,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    final baseStyle = _getTextStyle(tokenStyle);

    return baseStyle.copyWith(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  /// Get duration from motion tokens
  static Duration durationFromTokens(TokenDuration duration) {
    return _getDuration(duration);
  }

  /// Get curve from motion tokens
  static Curve curveFromTokens(TokenCurve curve) {
    return _getCurve(curve);
  }

  /// Helper method to get spacing value from tokens
  static double _getSpacingValue(tokens.Spacing spacing, TokenSize size) {
    switch (size) {
      case TokenSize.xs:
        return spacing.xs;
      case TokenSize.sm:
        return spacing.sm;
      case TokenSize.md:
        return spacing.md;
      case TokenSize.lg:
        return spacing.lg;
      case TokenSize.xl:
        return spacing.xl;
      case TokenSize.xxl:
        return spacing.xxl;
      case TokenSize.xxxl:
        return spacing.xxxl;
      case TokenSize.xxxxl:
        return spacing.xxxxl;
      case TokenSize.xxxxxl:
        return spacing.xxxxxl;
      case TokenSize.xxxxxxl:
        return spacing.xxxxxxl;
    }
  }

  /// Helper method to get radius value from tokens
  static double _getRadiusValue(tokens.Radius radius, TokenRadiusSize size) {
    switch (size) {
      case TokenRadiusSize.none:
        return radius.none;
      case TokenRadiusSize.sm:
        return radius.sm;
      case TokenRadiusSize.md:
        return radius.md;
      case TokenRadiusSize.lg:
        return radius.lg;
      case TokenRadiusSize.xl:
        return radius.xl;
      case TokenRadiusSize.xxl:
        return radius.xxl;
      case TokenRadiusSize.full:
        return radius.full;
    }
  }

  /// Helper method to get text style from typography tokens
  static TextStyle _getTextStyle(TokenTextStyle style) {
    switch (style) {
      case TokenTextStyle.displayLarge:
        return tokens.Typography.displayLarge;
      case TokenTextStyle.displayMedium:
        return tokens.Typography.displayMedium;
      case TokenTextStyle.displaySmall:
        return tokens.Typography.displaySmall;
      case TokenTextStyle.headlineLarge:
        return tokens.Typography.headlineLarge;
      case TokenTextStyle.headlineMedium:
        return tokens.Typography.headlineMedium;
      case TokenTextStyle.headlineSmall:
        return tokens.Typography.headlineSmall;
      case TokenTextStyle.titleLarge:
        return tokens.Typography.titleLarge;
      case TokenTextStyle.titleMedium:
        return tokens.Typography.titleMedium;
      case TokenTextStyle.titleSmall:
        return tokens.Typography.titleSmall;
      case TokenTextStyle.bodyLarge:
        return tokens.Typography.bodyLarge;
      case TokenTextStyle.bodyMedium:
        return tokens.Typography.bodyMedium;
      case TokenTextStyle.bodySmall:
        return tokens.Typography.bodySmall;
      case TokenTextStyle.labelLarge:
        return tokens.Typography.labelLarge;
      case TokenTextStyle.labelMedium:
        return tokens.Typography.labelMedium;
      case TokenTextStyle.labelSmall:
        return tokens.Typography.labelSmall;
    }
  }

  /// Helper method to get duration from motion tokens
  static Duration _getDuration(TokenDuration duration) {
    switch (duration) {
      case TokenDuration.instant:
        return tokens.Motion.instant;
      case TokenDuration.fast:
        return tokens.Motion.fast;
      case TokenDuration.normal:
        return tokens.Motion.normal;
      case TokenDuration.slow:
        return tokens.Motion.slow;
      case TokenDuration.slower:
        return tokens.Motion.slower;
    }
  }

  /// Helper method to get curve from token curve enum
  static Curve _getCurve(TokenCurve curve) {
    switch (curve) {
      case TokenCurve.linear:
        return tokens.Motion.linear;
      case TokenCurve.easeIn:
        return tokens.Motion.easeIn;
      case TokenCurve.easeOut:
        return tokens.Motion.easeOut;
      case TokenCurve.easeInOut:
        return tokens.Motion.easeInOut;
      case TokenCurve.bounceIn:
        return tokens.Motion.bounceIn;
      case TokenCurve.bounceOut:
        return tokens.Motion.bounceOut;
      case TokenCurve.elasticIn:
        return tokens.Motion.elasticIn;
      case TokenCurve.elasticOut:
        return tokens.Motion.elasticOut;
    }
  }
}

/// Enumeration for token size values (spacing)
enum TokenSize {
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
  xxxl,
  xxxxl,
  xxxxxl,
  xxxxxxl,
}

/// Enumeration for token radius size values
enum TokenRadiusSize {
  none,
  sm,
  md,
  lg,
  xl,
  xxl,
  full,
}

/// Enumeration for token text styles
enum TokenTextStyle {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

/// Enumeration for token durations
enum TokenDuration {
  instant,
  fast,
  normal,
  slow,
  slower,
}

/// Enumeration for token curves
enum TokenCurve {
  linear,
  easeIn,
  easeOut,
  easeInOut,
  bounceIn,
  bounceOut,
  elasticIn,
  elasticOut,
}

/// Extension methods for easy access to common token-based styling
extension TokenStylingExtensions on BuildContext {
  /// Quick access to spacing values
  tokens.Spacing get spacing => tokens.Spacing.of(this);

  /// Quick access to radius values
  tokens.Radius get radius => tokens.Radius.of(this);

  /// Get padding using token sizes
  EdgeInsets padding({
    TokenSize? all,
    TokenSize? horizontal,
    TokenSize? vertical,
    TokenSize? top,
    TokenSize? right,
    TokenSize? bottom,
    TokenSize? left,
  }) {
    return TokenAdapters.paddingFromTokens(
      context: this,
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );
  }

  /// Get margin using token sizes
  EdgeInsets margin({
    TokenSize? all,
    TokenSize? horizontal,
    TokenSize? vertical,
    TokenSize? top,
    TokenSize? right,
    TokenSize? bottom,
    TokenSize? left,
  }) {
    return TokenAdapters.marginFromTokens(
      context: this,
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );
  }

  /// Get border radius using token sizes
  BorderRadius borderRadius({
    TokenRadiusSize? all,
    TokenRadiusSize? topLeft,
    TokenRadiusSize? topRight,
    TokenRadiusSize? bottomLeft,
    TokenRadiusSize? bottomRight,
  }) {
    return TokenAdapters.radiusFromTokens(
      context: this,
      all: all,
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }
}