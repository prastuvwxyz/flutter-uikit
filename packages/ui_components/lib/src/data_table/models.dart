import 'package:flutter/widgets.dart';

typedef DataTableSortCallback = void Function(int columnIndex, bool ascending);

class DataTableColumn<T> {
  const DataTableColumn({
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

class DataTableRowModel<T> {
  const DataTableRowModel({required this.data, this.selected = false});

  final T data;
  final bool selected;
}

class DataTablePagination {
  const DataTablePagination({
    required this.pageSize,
    this.currentPage = 0,
    this.pageSizeOptions = const [10, 25, 50],
  });

  final int pageSize;
  final int currentPage;
  final List<int> pageSizeOptions;
}
