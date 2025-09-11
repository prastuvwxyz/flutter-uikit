import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../tokens/ui_tokens.dart';

/// Data model for pie chart segments
class LXPieChartData {
  final String label;
  final double value;
  final Color color;
  final String? displayValue;

  const LXPieChartData({
    required this.label,
    required this.value,
    required this.color,
    this.displayValue,
  });
}

/// LXPieChart - A customizable pie chart component using fl_chart
class LXPieChart extends StatelessWidget {
  final List<LXPieChartData> data;
  final double size;
  final bool showLabels;
  final bool showLegend;
  final bool showPercentages;
  final Widget? centerWidget;

  const LXPieChart({
    super.key,
    required this.data,
    this.size = 240,
    this.showLabels = true,
    this.showLegend = true,
    this.showPercentages = true,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    
    return Column(
      children: [
        // Pie Chart using fl_chart
        SizedBox(
          width: size,
          height: size,
          child: PieChart(
            PieChartData(
              sections: data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final percentage = (item.value / total * 100);
                
                return PieChartSectionData(
                  value: item.value,
                  color: item.color,
                  title: showLabels && percentage > 5 
                      ? showPercentages 
                          ? '${percentage.toStringAsFixed(1)}%'
                          : '${item.value.toInt()}'
                      : '',
                  titleStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  radius: size * 0.35,
                  titlePositionPercentageOffset: 0.6,
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: centerWidget != null ? size * 0.2 : 0,
              startDegreeOffset: -90,
            ),
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeInOutQuint,
          ),
        ),
        
        if (showLegend) ...[
          const SizedBox(height: 16),
          _buildLegend(total),
        ],
      ],
    );
  }

  Widget _buildLegend(double total) {
    return Column(
      children: data.map((item) {
        final percentage = (item.value / total * 100).toStringAsFixed(1);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                item.displayValue ?? '${item.value.toInt()}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showPercentages) ...[
                const SizedBox(width: 4),
                Text(
                  '($percentage%)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Pre-configured pie chart for motorcycle status using fl_chart
class MotorcycleStatusPieChart extends StatelessWidget {
  final double size;
  final bool showLegend;

  const MotorcycleStatusPieChart({
    super.key,
    this.size = 240,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    final data = [
      LXPieChartData(
        label: 'RENTED',
        value: 142,
        color: tokens.colorTokens.success[500]!,
      ),
      LXPieChartData(
        label: 'AVAILABLE',
        value: 53,
        color: tokens.colorTokens.primary.shade500,
      ),
      LXPieChartData(
        label: 'MAINTENANCE',
        value: 18,
        color: tokens.colorTokens.warning[500]!,
      ),
      LXPieChartData(
        label: 'DAMAGED',
        value: 12,
        color: tokens.colorTokens.error[500]!,
      ),
      LXPieChartData(
        label: 'STOLEN',
        value: 2,
        color: tokens.colorTokens.neutral.shade400,
      ),
    ];

    return LXPieChart(
      data: data,
      size: size,
      showLegend: showLegend,
      showLabels: true,
      showPercentages: true,
    );
  }
}