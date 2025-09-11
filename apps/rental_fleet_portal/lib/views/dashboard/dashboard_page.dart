import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.of(context);
    
    // Add null check for tokens
    if (tokens.colorTokens == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1536), // xl breakpoint
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page header
              DashboardSection(
                title: 'Rental Fleet Dashboard',
                subtitle: 'Monitor your fleet performance and key metrics',
                spacing: 32,
                child: const SizedBox.shrink(),
              ),

              // Fleet Operations Overview - Head of Operations Focus
              DashboardSection(
                title: 'Fleet Overview',
                subtitle:
                    'Critical operational metrics for rental, asset, repossession & service operations',
                child: DashboardGrid(
                  spacing: 24,
                  breakpoints: const GridBreakpoints(
                    xs: 1, // Mobile: 1 column
                    sm: 2, // Small tablet: 2 columns  
                    md: 4, // Tablet+: 4 columns (changed from 2 to 4)
                    lg: 4, // Desktop: 4 columns
                    xl: 4, // Large desktop: 4 columns
                  ),
                  children: [
                    // 1. RENTAL OPS - Fleet Utilization (Most Critical)
                    MetricCard(
                      title: 'Fleet Utilization Rate',
                      value: '78.5%',
                      subtitle: 'Motorcycles generating revenue',
                      icon: const Icon(Icons.trending_up_rounded),
                      accentColor: tokens.colorTokens.success[600] ?? Colors.green,
                      cornerWidget: const TrendIndicator(
                        percentage: 3.2,
                        isPositive: true,
                      ),
                      bottomWidget: _buildUtilizationBar(tokens),
                    ),

                    // 2. ASSET OPS - Available Inventory
                    MetricCard(
                      title: 'Available Motorcycle',
                      value: '53',
                      subtitle: 'Ready for immediate rental',
                      icon: const Icon(Icons.inventory_2_rounded),
                      accentColor: tokens.colorTokens.primary.shade500,
                      cornerWidget: const TrendIndicator(
                        percentage: 7.1,
                        isPositive: true,
                      ),
                      bottomWidget: SimpleLineChart(
                        data: [45, 48, 51, 47, 50, 53],
                        color: tokens.colorTokens.primary.shade500,
                      ),
                    ),

                    // 3. SERVICE OPS - Maintenance Critical
                    MetricCard(
                      title: 'Service Required',
                      value: '18',
                      subtitle: 'Urgent maintenance needed',
                      icon: const Icon(Icons.warning_rounded),
                      accentColor: tokens.colorTokens.error[500] ?? Colors.red,
                      cornerWidget: const TrendIndicator(
                        percentage: 12.5,
                        isPositive: false,
                      ),
                      bottomWidget: SimpleLineChart(
                        data: [25, 22, 20, 19, 17, 18],
                        color: tokens.colorTokens.error[500] ?? Colors.red,
                      ),
                    ),

                    // 4. REPOSSESSION OPS - Recovery Pipeline
                    MetricCard(
                      title: 'Recovery Pipeline',
                      value: '7',
                      subtitle: 'Motorcycles pending recovery',
                      icon: const Icon(Icons.assignment_return_rounded),
                      accentColor: tokens.colorTokens.warning[600] ?? Colors.orange,
                      cornerWidget: const TrendIndicator(
                        percentage: 2.3,
                        isPositive: false,
                      ),
                      bottomWidget: _buildRecoveryBar(tokens),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Fleet Analytics
              DashboardSection(
                title: 'Fleet Analytics',
                subtitle: 'Visual breakdown and trends of fleet operations',
                child: DashboardGrid(
                  spacing: 24,
                  breakpoints: const GridBreakpoints(
                    xs: 1,
                    sm: 1,
                    md: 2,
                    lg: 2,
                    xl: 2,
                  ),
                  children: [
                    // Pie chart widget for motorcycle status
                    LXCard(
                      header: const LXCardHeader(
                        title: 'Motorcycle Status Distribution',
                      ),
                      body: SizedBox(
                        height: 200,
                        child: const MotorcycleStatusPieChart(
                          size: 180,
                          showLegend: false,
                        ),
                      ),
                      footer: _buildMotorcycleStatusLegend(tokens),
                    ),

                    // Line/Bar chart for daily acquisitions
                    LXCard(
                      header: const LXCardHeader(
                        title: 'Daily Rental Acquisitions',
                      ),
                      body: const SizedBox(
                        height: 200,
                        child: DailyAcquisitionsBarChart(height: 160),
                      ),
                      footer: _buildDailyAcquisitionsFooter(tokens),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUtilizationBar(UiTokens tokens) {
    return Container(
      width: double.infinity,
      height: 6,
      decoration: BoxDecoration(
        color: tokens.colorTokens.neutral.shade200,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 75, // 75% utilization
            child: Container(
              decoration: BoxDecoration(
                color: tokens.colorTokens.info[600] ?? Colors.blue,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Expanded(
            flex: 25, // 25% remaining
            child: Container(), // Empty space
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryBar(UiTokens tokens) {
    return Container(
      width: double.infinity,
      height: 6,
      decoration: BoxDecoration(
        color: tokens.colorTokens.neutral.shade200,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          // Overdue (Critical)
          Expanded(
            flex: 3, // 3 out of 7 are overdue
            child: Container(
              decoration: BoxDecoration(
                color: tokens.colorTokens.error[600] ?? Colors.red,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  bottomLeft: Radius.circular(3),
                ),
              ),
            ),
          ),
          // In Progress
          Expanded(
            flex: 4, // 4 out of 7 in progress
            child: Container(
              decoration: BoxDecoration(
                color: tokens.colorTokens.warning[500] ?? Colors.orange,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(3),
                  bottomRight: Radius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorcycleStatusLegend(UiTokens tokens) {
    // Motorcycle status data matching the pie chart
    final statusData = [
      {'label': 'RENTED', 'value': 142, 'color': tokens.colorTokens.success[500] ?? Colors.green},
      {'label': 'AVAILABLE', 'value': 53, 'color': tokens.colorTokens.primary.shade500},
      {'label': 'MAINTENANCE', 'value': 18, 'color': tokens.colorTokens.warning[500] ?? Colors.orange},
      {'label': 'DAMAGED', 'value': 12, 'color': tokens.colorTokens.error[500] ?? Colors.red},
      {'label': 'STOLEN', 'value': 2, 'color': tokens.colorTokens.neutral.shade400},
    ];
    
    final total = statusData.fold<int>(0, (sum, data) => sum + (data['value'] as int));
    
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
                        color: tokens.colorTokens.neutral.shade600,
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
                  color: tokens.colorTokens.neutral.shade900,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 9,
                  color: tokens.colorTokens.neutral.shade500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDailyAcquisitionsFooter(UiTokens tokens) {
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
                  color: tokens.colorTokens.neutral.shade900,
                ),
              ),
              Text(
                'Total this week',
                style: TextStyle(
                  fontSize: 11,
                  color: tokens.colorTokens.neutral.shade600,
                ),
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
                  color: tokens.colorTokens.primary.shade500,
                ),
              ),
              Text(
                'Daily average',
                style: TextStyle(
                  fontSize: 11,
                  color: tokens.colorTokens.neutral.shade600,
                ),
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
                  color: tokens.colorTokens.info[600] ?? Colors.blue,
                ),
              ),
              Text(
                'Today',
                style: TextStyle(
                  fontSize: 11,
                  color: tokens.colorTokens.neutral.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}