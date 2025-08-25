import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// Elevation tokens for the UI Kit.
///
/// Provides standardized elevation values for shadows and z-positioning
/// to create consistent depth in the UI.
class UiElevationTokens {
  /// Level 0 elevation (no shadow)
  final double level0;
  
  /// Level 1 elevation (subtle shadow)
  final double level1;
  
  /// Level 2 elevation (light shadow)
  final double level2;
  
  /// Level 3 elevation (medium shadow)
  final double level3;
  
  /// Level 4 elevation (pronounced shadow)
  final double level4;
  
  /// Level 5 elevation (strong shadow)
  final double level5;
  
  /// Shadow color for light theme
  final Color lightShadowColor;
  
  /// Shadow color for dark theme
  final Color darkShadowColor;
  
  /// Whether this token set is for dark mode
  final bool isDark;
  
  /// Creates an elevation token set with custom values
  const UiElevationTokens({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
    required this.lightShadowColor,
    required this.darkShadowColor,
    this.isDark = false,
  });
  
  /// Creates the Material 3 elevation token set
  factory UiElevationTokens.material3({
    bool isDark = false,
  }) {
    return UiElevationTokens(
      level0: 0.0,
      level1: 1.0,
      level2: 3.0,
      level3: 6.0,
      level4: 8.0,
      level5: 12.0,
      lightShadowColor: const Color(0x33000000), // 20% opacity black
      darkShadowColor: const Color(0x33000000),  // 20% opacity black
      isDark: isDark,
    );
  }
  
  /// Creates a lerped version between this and another elevation token set
  UiElevationTokens lerp(UiElevationTokens other, double t) {
    return UiElevationTokens(
      level0: lerpDouble(level0, other.level0, t)!,
      level1: lerpDouble(level1, other.level1, t)!,
      level2: lerpDouble(level2, other.level2, t)!,
      level3: lerpDouble(level3, other.level3, t)!,
      level4: lerpDouble(level4, other.level4, t)!,
      level5: lerpDouble(level5, other.level5, t)!,
      lightShadowColor: Color.lerp(lightShadowColor, other.lightShadowColor, t)!,
      darkShadowColor: Color.lerp(darkShadowColor, other.darkShadowColor, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
  
  /// Get a shadow for the given elevation level
  List<BoxShadow> getShadow(int level) {
    final color = isDark ? darkShadowColor : lightShadowColor;
    final elevationValue = getElevation(level);
    
    if (elevationValue <= 0) {
      return [];
    }
    
    return [
      BoxShadow(
        color: color.withOpacity(0.11),
        blurRadius: elevationValue * 1.0,
        spreadRadius: elevationValue * 0.08,
        offset: Offset(0, elevationValue * 0.15),
      ),
      BoxShadow(
        color: color.withOpacity(0.13),
        blurRadius: elevationValue * 0.5,
        spreadRadius: elevationValue * 0.02,
        offset: Offset(0, elevationValue * 0.05),
      ),
    ];
  }
  
  /// Get an elevation value by level number
  double getElevation(int level) {
    switch (level) {
      case 0: return level0;
      case 1: return level1;
      case 2: return level2;
      case 3: return level3;
      case 4: return level4;
      case 5: return level5;
      default: throw ArgumentError('Unknown elevation level: $level');
    }
  }
  
  /// Get an elevation value by index
  double operator [](int index) {
    return getElevation(index);
  }
  
  /// Dark mode version of these elevation tokens
  UiElevationTokens get dark {
    if (isDark) return this;
    
    return UiElevationTokens(
      level0: level0,
      level1: level1 * 0.85, // Slightly reduced for dark mode
      level2: level2 * 0.85,
      level3: level3 * 0.85,
      level4: level4 * 0.85,
      level5: level5 * 0.85,
      lightShadowColor: lightShadowColor,
      darkShadowColor: darkShadowColor,
      isDark: true,
    );
  }
}
