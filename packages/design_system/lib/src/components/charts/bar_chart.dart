import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../tokens/ui_tokens.dart';

/// Data model for bar chart segments
class LXBarChartData {
  final String label;
  final double value;
  final Color? color;

  const LXBarChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

/// LXBarChart - A customizable bar chart component using fl_chart
class LXBarChart extends StatelessWidget {
  final List<LXBarChartData> data;
  final double height;
  final Color? defaultColor;
  final bool showLabels;
  final bool showValues;
  final double maxY;

  const LXBarChart({
    super.key,
    required this.data,
    this.height = 200,
    this.defaultColor,
    this.showLabels = true,
    this.showValues = true,
    this.maxY = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    final effectiveColor = defaultColor ?? tokens.colorTokens.info[600]!;
    final calculatedMaxY = maxY > 0 
        ? maxY 
        : data.fold<double>(0, (max, item) => item.value > max ? item.value : max);

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          maxY: calculatedMaxY * 1.1, // Add 10% padding
          barGroups: data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.value,
                  color: item.color ?? effectiveColor,
                  width: 24,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showValues,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < data.length) {
                    final item = data[value.toInt()];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${item.value.toInt()}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: tokens.colorTokens.neutral.shade700,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: showValues ? 20 : 0,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showLabels,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < data.length) {
                    final item = data[value.toInt()];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: tokens.colorTokens.neutral.shade500,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: showLabels ? 30 : 0,
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => tokens.colorTokens.neutral.shade800,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = data[group.x];
                return BarTooltipItem(
                  '${item.label}\n${item.value.toInt()}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOutQuint,
      ),
    );
  }
}

/// Pre-configured bar chart for daily rental acquisitions
class DailyAcquisitionsBarChart extends StatelessWidget {
  final double height;

  const DailyAcquisitionsBarChart({
    super.key,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    // Last 7 days data for rental acquisitions
    final data = [
      const LXBarChartData(label: 'Mon', value: 12),
      const LXBarChartData(label: 'Tue', value: 15),
      const LXBarChartData(label: 'Wed', value: 8),
      const LXBarChartData(label: 'Thu', value: 22),
      const LXBarChartData(label: 'Fri', value: 19),
      const LXBarChartData(label: 'Sat', value: 25),
      const LXBarChartData(label: 'Sun', value: 18),
    ];

    return LXBarChart(
      data: data,
      height: height,
      defaultColor: tokens.colorTokens.info[600]!,
      showLabels: true,
      showValues: true,
    );
  }
}