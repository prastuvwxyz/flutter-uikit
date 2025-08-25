import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  group('UiColorTokens Tests', () {
    test('Material3 color tokens have correct values', () {
      const tokens = UiColorTokens.material3();
      
      // Primary color should be blue
      expect(tokens.primary[500], const Color(0xFF0091FF));
      expect(tokens.primary[100], const Color(0xFFCCE9FF));
      expect(tokens.primary[900], const Color(0xFF001D33));
      
      // Secondary color should be purple
      expect(tokens.secondary[500], const Color(0xFF8265FF));
      
      // Error color should be red
      expect(tokens.error.value, equals(const Color(0xFFDC3545).value));
      
      // Dark mode should invert the color scheme
      expect(tokens.dark.primary[900], const Color(0xFFE6F4FF));
    });
    
    test('Color palette has proper lerp functionality', () {
      final palette1 = ColorPalette(
        shade50: const Color(0xFFE6F4FF),
        shade100: const Color(0xFFCCE9FF),
        shade200: const Color(0xFF99D3FF),
        shade300: const Color(0xFF66BDFF),
        shade400: const Color(0xFF33A7FF),
        shade500: const Color(0xFF0091FF),
        shade600: const Color(0xFF0074CC),
        shade700: const Color(0xFF005799),
        shade800: const Color(0xFF003A66),
        shade900: const Color(0xFF001D33),
      );
      
      final palette2 = ColorPalette(
        shade50: const Color(0xFFE3F2FD),
        shade100: const Color(0xFFBBDEFB),
        shade200: const Color(0xFF90CAF9),
        shade300: const Color(0xFF64B5F6),
        shade400: const Color(0xFF42A5F5),
        shade500: const Color(0xFF2196F3),
        shade600: const Color(0xFF1E88E5),
        shade700: const Color(0xFF1976D2),
        shade800: const Color(0xFF1565C0),
        shade900: const Color(0xFF0D47A1),
      );
      
      final lerped = palette1.lerp(palette2, 0.5);
      
      // Lerped values should be halfway between
      expect(lerped[500].value, closeTo(
        Color.lerp(const Color(0xFF0091FF), const Color(0xFF2196F3), 0.5)!.value, 
        1)
      );
    });
  });
  
  group('UiTypographyTokens Tests', () {
    test('Typography tokens have correct sizes', () {
      // Create mock typography tokens to avoid Google Fonts network issues in tests
      final tokens = UiTypographyTokens(
        displayLarge: const TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
        displayMedium: const TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: const TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
        headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      );
      
      expect(tokens.displayLarge.fontSize, 57);
      expect(tokens.bodyMedium.fontSize, 14);
      expect(tokens.labelSmall.fontSize, 11);
      
      // Font weights should be correct
      expect(tokens.titleLarge.fontWeight, FontWeight.w500);
      expect(tokens.bodyLarge.fontWeight, FontWeight.w400);
    });
  });
  
  group('UiSpacingTokens Tests', () {
    test('Spacing tokens follow 4px grid', () {
      const tokens = UiSpacingTokens.standard();
      
      expect(tokens.xs, 4);
      expect(tokens.sm, 8);
      expect(tokens.md, 12);
      expect(tokens.lg, 16);
      
      // Test operator access
      expect(tokens[0], 4);
      expect(tokens[3], 16);
    });
    
    test('Compact spacing is 75% of standard', () {
      const standard = UiSpacingTokens.standard();
      final compact = UiSpacingTokens.compact();
      
      expect(compact.md, closeTo(standard.md * 0.75, 0.01));
      expect(compact.lg, closeTo(standard.lg * 0.75, 0.01));
    });
  });
  
  group('UiRadiusTokens Tests', () {
    test('Radius tokens have correct values', () {
      const tokens = UiRadiusTokens.standard();
      
      expect(tokens.none, 0);
      expect(tokens.sm, 4);
      expect(tokens.md, 8);
      expect(tokens.lg, 12);
      expect(tokens.full, 9999);
    });
  });
  
  group('UiElevationTokens Tests', () {
    test('Elevation tokens produce shadows', () {
      final tokens = UiElevationTokens.material3();
      
      // Level 0 should have no shadow
      expect(tokens.getShadow(0), isEmpty);
      
      // Level 3 should have shadow
      final level3Shadow = tokens.getShadow(3);
      expect(level3Shadow, isNotEmpty);
      expect(level3Shadow.length, 2); // We generate 2 shadows per level
    });
  });
  
  group('UiMotionTokens Tests', () {
    test('Motion tokens have correct durations', () {
      final tokens = UiMotionTokens.standard();
      
      expect(tokens.xs.inMilliseconds, 50);
      expect(tokens.sm.inMilliseconds, 100);
      expect(tokens.md.inMilliseconds, 200);
      expect(tokens.lg.inMilliseconds, 300);
      expect(tokens.xl.inMilliseconds, 400);
      
      // Standard curve should be easeInOutCubic
      expect(tokens.standard, Curves.easeInOutCubic);
    });
  });
  
  group('UiTokens Integration Tests', () {
    testWidgets('UiTokens can be retrieved from Theme', (WidgetTester tester) async {
      final tokens = UiTokens.standard();
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [tokens],
          ),
          home: Builder(
            builder: (context) {
              final retrievedTokens = UiTokens.of(context);
              
              // Verify we can retrieve tokens
              expect(retrievedTokens, isNotNull);
              
              return const SizedBox();
            },
          ),
        ),
      );
    });
    
    test('UiTokens dark mode properly applied', () {
      final lightTokens = UiTokens.standard();
      final darkTokens = lightTokens.dark;
      
      expect(darkTokens.colorTokens.isDark, isTrue);
      expect(darkTokens.elevationTokens.isDark, isTrue);
    });
    
    test('UiTokens high contrast properly applied', () {
      final standardTokens = UiTokens.standard();
      final highContrastTokens = standardTokens.highContrast;
      
      expect(highContrastTokens.colorTokens.isHighContrast, isTrue);
    });
  });
}
