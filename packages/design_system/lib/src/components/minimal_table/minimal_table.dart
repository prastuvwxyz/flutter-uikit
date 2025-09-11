import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A minimal table widget with basic sorting and selection support.
class MinimalTable extends StatelessWidget {
  const MinimalTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    this.showCheckboxColumn = false,
    this.headingRowHeight,
    this.dataRowHeight,
    this.dividerThickness,
    this.columnSpacing,
  });

  final List<MinimalTableColumn> columns;
  final List<MinimalTableRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ValueChanged<bool?>? onSelectAll;
  final bool showCheckboxColumn;
  final double? headingRowHeight;
  final double? dataRowHeight;
  final double? dividerThickness;
  final double? columnSpacing;

  @override
  Widget build(BuildContext context) {
    // We'll build using Flutter's DataTable under the hood to get accessibility & keyboard support.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _buildDataColumns(),
        rows: _buildDataRows(),
        sortColumnIndex: sortColumnIndex,
        sortAscending: sortAscending,
        headingRowHeight: headingRowHeight ?? 56.0,
        dataRowHeight: dataRowHeight ?? 48.0,
        dividerThickness: dividerThickness ?? 0.5,
        columnSpacing: columnSpacing ?? 16.0,
        showCheckboxColumn: showCheckboxColumn,
        onSelectAll: onSelectAll,
      ),
    );
  }

  List<DataColumn> _buildDataColumns() {
    return List<DataColumn>.generate(columns.length, (index) {
      final col = columns[index];
      return DataColumn(
        label: col.label,
        numeric: col.numeric,
        tooltip: col.tooltip,
        onSort: col.onSort != null
            ? (colIndex, ascending) => col.onSort!(colIndex)
            : null,
      );
    });
  }

  List<DataRow> _buildDataRows() {
    return rows.map((r) {
      return DataRow(
        selected: r.selected,
        onSelectChanged: r.onSelectChanged,
        color: r.color != null ? MaterialStateProperty.all(r.color) : null,
        cells: r.cells.map((w) => DataCell(w)).toList(),
      );
    }).toList();
  }
}

class MinimalTableColumn {
  const MinimalTableColumn({
    required this.label,
    this.tooltip,
    this.numeric = false,
    this.onSort,
  });

  final Widget label;
  final String? tooltip;
  final bool numeric;
  final ValueChanged<int>? onSort;
}

class MinimalTableRow {
  const MinimalTableRow({
    required this.cells,
    this.selected = false,
    this.onSelectChanged,
    this.color,
  });

  final List<Widget> cells;
  final bool selected;
  final ValueChanged<bool?>? onSelectChanged;
  final Color? color;
}
