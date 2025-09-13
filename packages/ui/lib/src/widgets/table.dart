import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef TableSortCallback = void Function(int columnIndex, bool ascending);

class TableColumn<T> {
  const TableColumn({
    required this.label,
    required this.cellBuilder,
    this.tooltip,
    this.numeric = false,
    this.comparator,
  });

  final Widget label;
  final String? tooltip;
  final bool numeric;
  final Widget Function(T item) cellBuilder;
  final int Function(T a, T b)? comparator;
}

class TableRowModel<T> {
  const TableRowModel({required this.data, this.selected = false});

  final T data;
  final bool selected;
}

class TablePagination {
  const TablePagination({
    required this.pageSize,
    this.currentPage = 0,
    this.pageSizeOptions = const [10, 25, 50],
  });

  final int pageSize;
  final int currentPage;
  final List<int> pageSizeOptions;
}

class Table<T> extends StatefulWidget {
  const Table({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.selection,
    this.onSelectionChanged,
    this.showCheckboxColumn = false,
    this.pagination,
    this.loading = false,
    this.empty,
    this.error,
    this.virtualized = true,
    this.onRowTap,
  });

  final List<TableColumn<T>> columns;
  final List<TableRowModel<T>> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final TableSortCallback? onSort;
  final Set<int>? selection;
  final ValueChanged<Set<int>>? onSelectionChanged;
  final bool showCheckboxColumn;
  final TablePagination? pagination;
  final bool loading;
  final Widget? empty;
  final Widget? error;
  final bool virtualized;
  final void Function(int index, T row)? onRowTap;

  @override
  State<Table<T>> createState() => _TableState<T>();
}

class _TableState<T> extends State<Table<T>> {
  late List<TableRowModel<T>> _rows;
  late Set<int> _selection;

  @override
  void initState() {
    super.initState();
    _rows = List.of(widget.rows);
    _selection = widget.selection != null ? Set.of(widget.selection!) : <int>{};
  }

  @override
  void didUpdateWidget(covariant Table<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.rows, widget.rows)) {
      _rows = List.of(widget.rows);
    }
    if (!setEquals(oldWidget.selection ?? {}, widget.selection ?? {})) {
      _selection = widget.selection != null
          ? Set.of(widget.selection!)
          : <int>{};
    }
  }

  void _toggleSelect(int index) {
    setState(() {
      if (_selection.contains(index)) {
        _selection.remove(index);
      } else {
        _selection.add(index);
      }
    });
    widget.onSelectionChanged?.call(_selection);
  }

  Widget _buildHeader() {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          if (widget.showCheckboxColumn)
            SizedBox(width: 48, child: Checkbox(value: false, onChanged: null)),
          ...widget.columns
              .map(
                (c) => Expanded(
                  child: InkWell(
                    onTap: () {
                      final idx = widget.columns.indexOf(c);
                      widget.onSort?.call(idx, !(widget.sortAscending));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(child: c.label),
                          if (c.tooltip != null)
                            Icon(Icons.info_outline, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRow(int index) {
    final row = _rows[index];
    return InkWell(
      onTap: widget.onRowTap != null
          ? () => widget.onRowTap!(index, row.data)
          : null,
      child: Container(
        color: _selection.contains(index)
            ? Colors.blue.withValues(alpha: 0.08)
            : null,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            if (widget.showCheckboxColumn)
              SizedBox(
                width: 48,
                child: Checkbox(
                  value: _selection.contains(index),
                  onChanged: (_) => _toggleSelect(index),
                ),
              ),
            ...widget.columns
                .map((c) => Expanded(child: c.cellBuilder(row.data)))
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_rows.isEmpty) {
      return widget.empty ?? Center(child: Text('No data'));
    }

    final body = widget.virtualized
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _rows.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildHeader();
              return _buildRow(index - 1);
            },
          )
        : Column(
            children: [
              _buildHeader(),
              ...List.generate(_rows.length, (i) => _buildRow(i)),
            ],
          );

    if (widget.pagination != null) {
      final p = widget.pagination!;
      final totalPages = (_rows.length / p.pageSize).ceil();
      return Column(
        children: [
          Expanded(child: body),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: p.currentPage > 0 ? () {} : null,
                icon: Icon(Icons.chevron_left),
              ),
              Text('${p.currentPage + 1} / $totalPages'),
              IconButton(
                onPressed: p.currentPage < totalPages - 1 ? () {} : null,
                icon: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      );
    }

    return SizedBox(height: 400, child: body);
  }
}