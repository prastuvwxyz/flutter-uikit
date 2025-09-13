import 'package:flutter/material.dart';
import 'package:ui/ui.dart' as ui;
import 'package:tokens/tokens.dart' as tokens;
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ui.Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 1536),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Dashboard',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Operation fleet metrics',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 32),

          // Unified Responsive Grid Layout
          _buildResponsiveGrid(context),
        ],
      ),
    );
  }

  Widget _buildResponsiveGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // Calculate number of columns based on screen width
        int metricCardColumns;
        int chartCardColumns;

        if (screenWidth < 600) {
          // Mobile: 1 column for everything
          metricCardColumns = 1;
          chartCardColumns = 1;
        } else if (screenWidth < 960) {
          // Tablet: 2 columns for metric cards, 1 for charts
          metricCardColumns = 2;
          chartCardColumns = 1;
        } else {
          // Desktop: 4 columns for metric cards, 2 for charts
          metricCardColumns = 4;
          chartCardColumns = 2;
        }

        return Column(
          children: [
            // Metric Cards Row
            ui.Grid(
              spacing: 24,
              columns: metricCardColumns,
              naturalHeight: true, // Use natural sizing
              children: [
                _buildMetricCard(
                  context: context,
                  icon: Icons.trending_up_rounded,
                  title: 'Fleet Utilization Rate',
                  value: '78.5%',
                  trend: 3.2,
                  isPositive: true,
                  backgroundColor: Colors.green.shade50,
                  iconColor: Colors.green.shade600,
                  trendColor: Colors.green.shade600,
                ),
                _buildMetricCard(
                  context: context,
                  icon: Icons.inventory_2_rounded,
                  title: 'Available Motorcycle',
                  value: '53',
                  trend: 7.1,
                  isPositive: true,
                  backgroundColor: Colors.blue.shade50,
                  iconColor: Colors.blue.shade600,
                  trendColor: Colors.blue.shade600,
                ),
                _buildMetricCard(
                  context: context,
                  icon: Icons.warning_rounded,
                  title: 'Service Required',
                  value: '18',
                  trend: 12.5,
                  isPositive: false,
                  backgroundColor: Colors.red.shade50,
                  iconColor: Colors.red.shade600,
                  trendColor: Colors.red.shade600,
                ),
                _buildMetricCard(
                  context: context,
                  icon: Icons.assignment_return_rounded,
                  title: 'Recovery Pipeline',
                  value: '7',
                  trend: 2.3,
                  isPositive: false,
                  backgroundColor: Colors.orange.shade50,
                  iconColor: Colors.orange.shade600,
                  trendColor: Colors.orange.shade600,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Chart Cards Row
            ui.Grid(
              spacing: 24,
              columns: chartCardColumns,
              childAspectRatio: 2, // Better aspect ratio for charts
              children: [
                ui.Card(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  header: const ui.CardHeader(
                    title: 'Motorcycle Status Distribution',
                  ),
                  body: SizedBox(
                    height: 120,
                    child: _buildMotorcycleStatusPieChart(),
                  ),
                  footer: _buildMotorcycleStatusLegend(),
                ),
                ui.Card(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  header: const ui.CardHeader(
                    title: 'Daily Rental Acquisitions',
                  ),
                  body: SizedBox(
                    height: 120,
                    child: _buildDailyAcquisitionsChart(),
                  ),
                  footer: _buildDailyAcquisitionsFooter(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required double trend,
    required bool isPositive,
    required Color backgroundColor,
    required Color iconColor,
    required Color trendColor,
  }) {
    final theme = Theme.of(context);
    final spacing = tokens.Spacing.of(context);
    final radius = tokens.Radius.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with icon and trend
          Row(
            children: [
              // Icon - no background, just colored icon
              ui.CustomIcon(icon, size: ui.IconSize.md.size, color: iconColor),
              const Spacer(),
              // Trend indicator
              Row(
                children: [
                  ui.CustomIcon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    size: ui.IconSize.sm.size,
                    color: trendColor,
                  ),
                  SizedBox(width: spacing.xs),
                  Text(
                    '${isPositive ? '+' : '-'}${trend.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: spacing.lg),

          // Main content area - Title left, Value right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Left side - Title
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(width: spacing.sm),

              // Right side - Value
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMotorcycleStatusLegend() {
    // Motorcycle status data matching the pie chart
    final statusData = [
      {'label': 'RENTED', 'value': 142, 'color': Colors.green.shade600},
      {'label': 'AVAILABLE', 'value': 53, 'color': Colors.blue.shade600},
      {'label': 'MAINTENANCE', 'value': 18, 'color': Colors.orange.shade600},
      {'label': 'DAMAGED', 'value': 12, 'color': Colors.red.shade600},
      {'label': 'STOLEN', 'value': 2, 'color': Colors.grey.shade600},
    ];

    final total = statusData.fold<int>(
      0,
      (sum, data) => sum + (data['value'] as int),
    );

    // Use 5 columns 1 row layout for compact display
    return Row(
      children: statusData.map((data) {
        final value = data['value'] as int;
        final percentage = (value / total * 100).toStringAsFixed(1);

        return Expanded(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: data['color'] as Color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      data['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDailyAcquisitionsFooter() {
    return Row(
      children: [
        // Weekly total
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '119',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
              ),
              Text(
                'Total this week',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        // Average per day
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '17',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade600,
                ),
              ),
              Text(
                'Daily average',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        // Today
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '18',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade600,
                ),
              ),
              Text(
                'Today',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMotorcycleStatusPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 142,
            title: '142',
            color: Colors.green.shade600,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: 53,
            title: '53',
            color: Colors.blue.shade600,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: 18,
            title: '18',
            color: Colors.orange.shade600,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: 12,
            title: '12',
            color: Colors.red.shade600,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: 2,
            title: '2',
            color: Colors.grey.shade600,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 0,
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Handle touch events if needed
          },
        ),
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }

  Widget _buildDailyAcquisitionsChart() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 15),
                FlSpot(1, 18),
                FlSpot(2, 12),
                FlSpot(3, 22),
                FlSpot(4, 16),
                FlSpot(5, 18),
                FlSpot(6, 24),
              ],
              isCurved: true,
              color: Colors.blue.shade600,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.shade600.withValues(alpha: 0.1),
              ),
            ),
          ],
          minY: 0,
          maxY: 30,
        ),
      ),
    );
  }
}
