import 'package:flutter/material.dart';
import 'package:ui/ui.dart' as ui;
import 'package:tokens/tokens.dart' as tokens;

class MotorcycleStocksPage extends StatefulWidget {
  const MotorcycleStocksPage({super.key});

  @override
  State<MotorcycleStocksPage> createState() => _MotorcycleStocksPageState();
}

class _MotorcycleStocksPageState extends State<MotorcycleStocksPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedStatus = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allMotorcycles = [
    {
      'licensePlate': 'B 1234 ABC',
      'vin': 'MH2JC5940NK123456',
      'stockStatus': 'AVAILABLE',
      'model': 'H1',
      'color': 'Midnight Bromo',
      'sku': 'H1-MB',
      'productionYear': '2024',
      'ownerType': 'FIXED_ASSET',
      'ownerName': 'ELECTRUM',
      'lastDotThreeAction': 'Service Check',
      'avatar': 'H1',
    },
    {
      'licensePlate': 'B 5678 DEF',
      'vin': 'MH2JC5940NK789012',
      'stockStatus': 'RENTED',
      'model': 'H1',
      'color': 'Tifany Blue',
      'sku': 'H1-TB',
      'productionYear': '2024',
      'ownerType': 'ROU_ASSET',
      'ownerName': 'AIZEN',
      'lastDotThreeAction': 'Rental Started',
      'avatar': 'H1',
    },
    {
      'licensePlate': 'B 9012 GHI',
      'vin': 'MH2JC5940NK345678',
      'stockStatus': 'AVAILABLE',
      'model': 'H3',
      'color': 'Midnight Bromo',
      'sku': 'H3-MB',
      'productionYear': '2023',
      'ownerType': 'ROU_ASSET',
      'ownerName': 'DIPO',
      'lastDotThreeAction': 'Quality Check',
      'avatar': 'H3',
    },
    {
      'licensePlate': 'B 3456 JKL',
      'vin': 'MH2JC5940NK901234',
      'stockStatus': 'MAINTENANCE',
      'model': 'H3',
      'color': 'Tifany Blue',
      'sku': 'H3-TB',
      'productionYear': '2023',
      'ownerType': 'FIXED_ASSET',
      'ownerName': 'ELECTRUM',
      'lastDotThreeAction': 'Repair Order',
      'avatar': 'H3',
    },
    {
      'licensePlate': 'B 7890 MNO',
      'vin': 'MH2JC5940NK567890',
      'stockStatus': 'RENTED_TO_PARTNER',
      'model': 'H5',
      'color': 'Midnight Bromo',
      'sku': 'H5-MB',
      'productionYear': '2023',
      'ownerType': 'ROU_ASSET',
      'ownerName': 'TAKARI',
      'lastDotThreeAction': 'Partner Transfer',
      'avatar': 'H5',
    },
    {
      'licensePlate': 'B 2468 PQR',
      'vin': 'MH2JC5940NK121314',
      'stockStatus': 'DAMAGED',
      'model': 'H5',
      'color': 'Tifany Blue',
      'sku': 'H5-TB',
      'productionYear': '2022',
      'ownerType': 'FIXED_ASSET',
      'ownerName': 'ELECTRUM',
      'lastDotThreeAction': 'Damage Report',
      'avatar': 'H5',
    },
    {
      'licensePlate': 'B 1357 STU',
      'vin': 'MH2JC5940NK151617',
      'stockStatus': 'STOLEN',
      'model': 'H1',
      'color': 'Midnight Bromo',
      'sku': 'H1-MB',
      'productionYear': '2024',
      'ownerType': 'ROU_ASSET',
      'ownerName': 'AIZEN',
      'lastDotThreeAction': 'Police Report',
      'avatar': 'H1',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredMotorcycles {
    List<Map<String, dynamic>> filtered = _allMotorcycles;

    if (_selectedStatus != 'All') {
      filtered = filtered
          .where((m) => m['stockStatus'] == _selectedStatus)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (m) =>
                m['model'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                m['sku'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                m['licensePlate'].toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                m['vin'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                m['color'].toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return filtered;
  }

  Map<String, int> get _statusCounts {
    final Map<String, int> counts = {'All': _allMotorcycles.length};
    for (final motorcycle in _allMotorcycles) {
      final status = motorcycle['stockStatus'] as String;
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final statusCounts = _statusCounts;

    return ui.Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 1536),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Motorcycle Stocks',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Assets • Motorcycle Stocks',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Add motorcycle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.ColorPalettes.neutral.shade900,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Main Content
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Tab Bar
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: tokens.ColorPalettes.neutral.shade900,
                      unselectedLabelColor: tokens.ColorPalettes.neutral.shade500,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: tokens.ColorPalettes.neutral.shade900,
                          width: 2,
                        ),
                        insets: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      onTap: (index) {
                        final statuses = [
                          'All',
                          'AVAILABLE',
                          'RENTED',
                          'RENTED_TO_PARTNER',
                          'DAMAGED',
                          'STOLEN',
                          'MAINTENANCE',
                        ];
                        setState(() {
                          _selectedStatus = statuses[index];
                        });
                      },
                      tabs: [
                        Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('All'),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tokens.ColorPalettes.neutral.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${statusCounts['All']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: tokens.ColorPalettes.neutral.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Available'),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${statusCounts['AVAILABLE'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Rented'),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${statusCounts['RENTED'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Rented to Partner'),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${statusCounts['RENTED_TO_PARTNER'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Damaged'),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${statusCounts['DAMAGED'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Stolen'),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade900.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${statusCounts['STOLEN'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Maintenance'),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${statusCounts['MAINTENANCE'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Filters Row
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        // Model Filter Dropdown
                        Container(
                          width: 160,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: tokens.ColorPalettes.neutral.shade300,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'Model',
                              items: ['Model', 'H1', 'H3', 'H5']
                                  .map(
                                    (model) => DropdownMenuItem(
                                      value: model,
                                      child: Text(
                                        model,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: tokens.ColorPalettes.neutral.shade600,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                // Handle model filter
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Search Field
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: tokens.ColorPalettes.neutral.shade300,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  color: tokens.ColorPalettes.neutral.shade500,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: tokens.ColorPalettes.neutral.shade500,
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Data Table
                  _buildDataTable(),

                  // Pagination
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Text(
                          'Rows per page:',
                          style: TextStyle(
                            fontSize: 14,
                            color: tokens.ColorPalettes.neutral.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: tokens.ColorPalettes.neutral.shade300,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: 5,
                              items: [5, 10, 25, 50]
                                  .map(
                                    (count) => DropdownMenuItem(
                                      value: count,
                                      child: Text('$count'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '1-5 of ${_filteredMotorcycles.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: tokens.ColorPalettes.neutral.shade600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.chevron_left,
                            color: tokens.ColorPalettes.neutral.shade400,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.chevron_right,
                            color: tokens.ColorPalettes.neutral.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    final motorcycles = _filteredMotorcycles;

    return Column(
      children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: tokens.ColorPalettes.neutral.shade50,
            border: Border(
              top: BorderSide(color: tokens.ColorPalettes.neutral.shade200),
              bottom: BorderSide(color: tokens.ColorPalettes.neutral.shade200),
            ),
          ),
          child: Row(
            children: [
              // Checkbox
              SizedBox(
                width: 48,
                child: Checkbox(value: false, onChanged: (value) {}),
              ),
              // License Plate
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'License Plate',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tokens.ColorPalettes.neutral.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_upward,
                      size: 16,
                      color: tokens.ColorPalettes.neutral.shade400,
                    ),
                  ],
                ),
              ),
              // VIN
              Expanded(
                flex: 2,
                child: Text(
                  'VIN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.ColorPalettes.neutral.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Model
              Expanded(
                flex: 2,
                child: Text(
                  'Model',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.ColorPalettes.neutral.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Owner
              Expanded(
                flex: 2,
                child: Text(
                  'Owner',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.ColorPalettes.neutral.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Stock Status
              Expanded(
                flex: 2,
                child: Text(
                  'Stock Status',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.ColorPalettes.neutral.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Actions
              const SizedBox(width: 180),
            ],
          ),
        ),

        // Table Rows
        ...motorcycles.map((motorcycle) => _buildTableRow(motorcycle)),
      ],
    );
  }

  Widget _buildTableRow(Map<String, dynamic> motorcycle) {
    final stockStatus = motorcycle['stockStatus'] as String;

    Color statusColor;
    Color statusBgColor;
    switch (stockStatus) {
      case 'AVAILABLE':
        statusColor = Colors.green;
        statusBgColor = Colors.green.withValues(alpha: 0.1);
        break;
      case 'RENTED':
        statusColor = Colors.blue;
        statusBgColor = Colors.blue.withValues(alpha: 0.1);
        break;
      case 'RENTED_TO_PARTNER':
        statusColor = Colors.indigo;
        statusBgColor = Colors.indigo.withValues(alpha: 0.1);
        break;
      case 'DAMAGED':
        statusColor = Colors.red;
        statusBgColor = Colors.red.withValues(alpha: 0.1);
        break;
      case 'STOLEN':
        statusColor = Colors.red.shade900;
        statusBgColor = Colors.red.shade900.withValues(alpha: 0.1);
        break;
      case 'MAINTENANCE':
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withValues(alpha: 0.1);
        break;
      default:
        statusColor = tokens.ColorPalettes.neutral.shade500;
        statusBgColor = tokens.ColorPalettes.neutral.shade100;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: tokens.ColorPalettes.neutral.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          SizedBox(
            width: 48,
            child: Checkbox(
              value: false,
              onChanged: (value) {},
            ),
          ),
          // License Plate
          Expanded(
            flex: 2,
            child: Text(
              motorcycle['licensePlate'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: tokens.ColorPalettes.neutral.shade900,
              ),
            ),
          ),
          // VIN
          Expanded(
            flex: 2,
            child: Text(
              motorcycle['vin'],
              style: TextStyle(
                fontSize: 14,
                color: tokens.ColorPalettes.neutral.shade700,
              ),
            ),
          ),
          // Model Column: Model-Color (top) and SKU Year (bottom)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${motorcycle['model']}-${motorcycle['color']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: tokens.ColorPalettes.neutral.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${motorcycle['sku']} ${motorcycle['productionYear']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: tokens.ColorPalettes.neutral.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Owner
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  motorcycle['ownerType'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: tokens.ColorPalettes.neutral.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  motorcycle['ownerName'],
                  style: TextStyle(
                    fontSize: 12,
                    color: tokens.ColorPalettes.neutral.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Stock Status
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                stockStatus.replaceAll('_', ' '),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ),
          // Actions
          SizedBox(
            width: 180,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Show',
                    style: TextStyle(
                      fontSize: 12,
                      color: tokens.ColorPalettes.neutral.shade600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 12,
                      color: tokens.ColorPalettes.neutral.shade600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}