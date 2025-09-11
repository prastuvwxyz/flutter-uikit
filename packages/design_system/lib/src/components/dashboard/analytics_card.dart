import 'package:flutter/material.dart';
import '../../tokens/ui_tokens.dart';

/// Analytics card widget for displaying key metrics and statistics
class AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final Color? iconColor;
  final double? percentage;
  final bool isPositiveTrend;
  final Widget? chart;
  final VoidCallback? onTap;

  const AnalyticsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.percentage,
    this.isPositiveTrend = true,
    this.chart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: tokens.colorTokens.neutral.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (iconColor ?? tokens.colorTokens.primary.shade500)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          color: iconColor ?? tokens.colorTokens.primary.shade500,
                          size: 24,
                        ),
                        child: icon!,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: tokens.colorTokens.neutral.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: tokens.colorTokens.neutral.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Percentage change indicator
              if (percentage != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPositiveTrend
                            ? tokens.colorTokens.success[50]
                            : tokens.colorTokens.error[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositiveTrend 
                                ? Icons.trending_up_rounded 
                                : Icons.trending_down_rounded,
                            size: 16,
                            color: isPositiveTrend
                                ? tokens.colorTokens.success[600]
                                : tokens.colorTokens.error[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${percentage!.abs().toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isPositiveTrend
                                  ? tokens.colorTokens.success[600]
                                  : tokens.colorTokens.error[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.colorTokens.neutral.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ] else if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: tokens.colorTokens.neutral.shade500,
                  ),
                ),
              ],
              
              // Chart section
              if (chart != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  child: chart!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple line chart widget for analytics cards
class SimpleLineChart extends StatelessWidget {
  final List<double> data;
  final Color? color;
  final double strokeWidth;

  const SimpleLineChart({
    super.key,
    required this.data,
    this.color,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    final chartColor = color ?? tokens.colorTokens.primary.shade500;

    return CustomPaint(
      painter: _LineChartPainter(
        data: data,
        color: chartColor,
        strokeWidth: strokeWidth,
      ),
      child: Container(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double strokeWidth;

  _LineChartPainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedY = range > 0 ? (data[i] - minValue) / range : 0.5;
      final y = size.height - (normalizedY * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw gradient fill
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}