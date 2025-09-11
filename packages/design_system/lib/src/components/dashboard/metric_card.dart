import 'package:flutter/material.dart';
import '../../tokens/ui_tokens.dart';

/// Universal metric card component for displaying any data value with optional visual elements
/// 
/// This component can be reused across the entire application to show metrics, 
/// statistics, or any data with consistent styling and layout patterns.
class MetricCard extends StatelessWidget {
  /// The title/label for the metric
  final String title;
  
  /// The main value to display (can be text, number, percentage, etc.)
  final String value;
  
  /// Optional subtitle or description
  final String? subtitle;
  
  /// Optional icon to display
  final Widget? icon;
  
  /// Color for the icon background and accents
  final Color? accentColor;
  
  /// Optional widget to display in the corner (trend, badge, etc.)
  final Widget? cornerWidget;
  
  /// Optional bottom widget (chart, progress bar, etc.)
  final Widget? bottomWidget;
  
  /// Optional tap handler (but generally should not redirect)
  final VoidCallback? onTap;
  
  /// Card background color (null for default white)
  final Color? backgroundColor;
  
  /// Card style variant
  final MetricCardStyle style;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.accentColor,
    this.cornerWidget,
    this.bottomWidget,
    this.onTap,
    this.backgroundColor,
    this.style = MetricCardStyle.standard,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    final effectiveAccentColor = accentColor ?? tokens.colorTokens.primary.shade500;
    final hasCustomBackground = backgroundColor != null;
    
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(style == MetricCardStyle.compact ? 16 : 24),
          decoration: BoxDecoration(
            gradient: hasCustomBackground
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      backgroundColor!,
                      backgroundColor!.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            color: hasCustomBackground ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildCardContent(tokens, effectiveAccentColor, hasCustomBackground),
        ),
      ),
    );
  }
  
  Widget _buildCardContent(UiTokens tokens, Color effectiveAccentColor, bool hasCustomBackground) {
    switch (style) {
      case MetricCardStyle.standard:
        return _buildStandardLayout(tokens, effectiveAccentColor, hasCustomBackground);
      case MetricCardStyle.compact:
        return _buildCompactLayout(tokens, effectiveAccentColor, hasCustomBackground);
      case MetricCardStyle.featured:
        return _buildFeaturedLayout(tokens, effectiveAccentColor, hasCustomBackground);
    }
  }
  
  Widget _buildStandardLayout(UiTokens tokens, Color effectiveAccentColor, bool hasCustomBackground) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with icon and corner widget
        Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: hasCustomBackground
                      ? Colors.white.withValues(alpha: 0.2)
                      : effectiveAccentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: hasCustomBackground ? Colors.white : effectiveAccentColor,
                    size: 24,
                  ),
                  child: icon!,
                ),
              ),
              const Spacer(),
            ] else if (cornerWidget != null) ...[
              const Spacer(),
            ],
            
            if (cornerWidget != null) cornerWidget!,
          ],
        ),
        
        if (icon != null || cornerWidget != null) const SizedBox(height: 24),
        
        // Main content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: hasCustomBackground 
                    ? Colors.white 
                    : tokens.colorTokens.neutral.shade900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: hasCustomBackground 
                    ? Colors.white.withValues(alpha: 0.8)
                    : tokens.colorTokens.neutral.shade600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: hasCustomBackground 
                      ? Colors.white.withValues(alpha: 0.7)
                      : tokens.colorTokens.neutral.shade500,
                ),
              ),
            ],
          ],
        ),
        
        // Bottom widget
        if (bottomWidget != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: bottomWidget!,
          ),
        ],
      ],
    );
  }
  
  Widget _buildCompactLayout(UiTokens tokens, Color effectiveAccentColor, bool hasCustomBackground) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: hasCustomBackground
                  ? Colors.white.withValues(alpha: 0.2)
                  : effectiveAccentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconTheme(
              data: IconThemeData(
                color: hasCustomBackground ? Colors.white : effectiveAccentColor,
                size: 20,
              ),
              child: icon!,
            ),
          ),
          const SizedBox(width: 12),
        ],
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: hasCustomBackground 
                      ? Colors.white 
                      : tokens.colorTokens.neutral.shade900,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: hasCustomBackground 
                      ? Colors.white.withValues(alpha: 0.8)
                      : tokens.colorTokens.neutral.shade600,
                ),
              ),
            ],
          ),
        ),
        
        if (cornerWidget != null) ...[
          const SizedBox(width: 8),
          cornerWidget!,
        ],
      ],
    );
  }
  
  Widget _buildFeaturedLayout(UiTokens tokens, Color effectiveAccentColor, bool hasCustomBackground) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top section with icon and corner widget
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: hasCustomBackground
                      ? Colors.white.withValues(alpha: 0.2)
                      : effectiveAccentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: hasCustomBackground ? Colors.white : effectiveAccentColor,
                    size: 28,
                  ),
                  child: icon!,
                ),
              ),
              const Spacer(),
            ] else if (cornerWidget != null) ...[
              const Spacer(),
            ],
            
            if (cornerWidget != null) cornerWidget!,
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Main value
        Text(
          value,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: hasCustomBackground 
                ? Colors.white 
                : tokens.colorTokens.neutral.shade900,
            height: 1.1,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Title and subtitle
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: hasCustomBackground 
                ? Colors.white.withValues(alpha: 0.9)
                : tokens.colorTokens.neutral.shade700,
          ),
        ),
        
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14,
              color: hasCustomBackground 
                  ? Colors.white.withValues(alpha: 0.7)
                  : tokens.colorTokens.neutral.shade500,
            ),
          ),
        ],
        
        // Bottom widget
        if (bottomWidget != null) ...[
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: bottomWidget!,
          ),
        ],
      ],
    );
  }
}

/// Style variants for the metric card
enum MetricCardStyle {
  /// Standard layout with icon at top, suitable for most use cases
  standard,
  
  /// Compact horizontal layout, good for smaller spaces
  compact,
  
  /// Featured layout with larger text and spacing, for key metrics
  featured,
}

/// Helper widget for trend indicators
class TrendIndicator extends StatelessWidget {
  final double percentage;
  final bool isPositive;
  final String? label;
  final bool showIcon;

  const TrendIndicator({
    super.key,
    required this.percentage,
    this.isPositive = true,
    this.label,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    final color = isPositive 
        ? tokens.colorTokens.success[600]! 
        : tokens.colorTokens.error[600]!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive 
            ? tokens.colorTokens.success[50]! 
            : tokens.colorTokens.error[50]!,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              isPositive 
                  ? Icons.trending_up_rounded 
                  : Icons.trending_down_rounded,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            '${percentage.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(
              label!,
              style: TextStyle(
                fontSize: 11,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}