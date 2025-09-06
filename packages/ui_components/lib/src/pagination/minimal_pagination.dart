import 'package:flutter/material.dart';

/// Minimal pagination widget following UIK-139 spec (simplified).
class MinimalPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;
  final int itemsPerPage;
  final int? totalItems;
  final int visiblePages;
  final bool showFirstLast;
  final bool showPrevNext;
  final bool showPageNumbers;
  final bool showItemsPerPage;
  final List<int> itemsPerPageOptions;
  final ValueChanged<int>? onItemsPerPageChanged;
  final ButtonStyle? buttonStyle;
  final ButtonStyle? currentPageStyle;
  final bool compactMode;

  const MinimalPagination({
    Key? key,
    this.currentPage = 1,
    this.totalPages = 1,
    this.onPageChanged,
    this.itemsPerPage = 10,
    this.totalItems,
    this.visiblePages = 5,
    this.showFirstLast = true,
    this.showPrevNext = true,
    this.showPageNumbers = true,
    this.showItemsPerPage = false,
    this.itemsPerPageOptions = const [10, 25, 50, 100],
    this.onItemsPerPageChanged,
    this.buttonStyle,
    this.currentPageStyle,
    this.compactMode = false,
  }) : super(key: key);

  List<int> _pageNumbers() {
    final pages = <int>[];
    if (totalPages <= visiblePages) {
      for (var i = 1; i <= totalPages; i++) pages.add(i);
      return pages;
    }

    final half = visiblePages ~/ 2;
    var start = currentPage - half;
    var end = currentPage + half;
    if (start < 1) {
      start = 1;
      end = visiblePages;
    } else if (end > totalPages) {
      end = totalPages;
      start = totalPages - visiblePages + 1;
    }
    for (var i = start; i <= end; i++) pages.add(i);
    return pages;
  }

  Widget _pageButton(BuildContext context, int page) {
    final isCurrent = page == currentPage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        style: isCurrent
            ? (currentPageStyle ?? ElevatedButton.styleFrom())
            : (buttonStyle ?? ElevatedButton.styleFrom()),
        onPressed: isCurrent ? null : () => onPageChanged?.call(page),
        child: Text('$page'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pageNumbers();

    final List<Widget> children = [];

    if (showFirstLast) {
      children.add(
        IconButton(
          icon: const Icon(Icons.first_page),
          onPressed: currentPage == 1 ? null : () => onPageChanged?.call(1),
          tooltip: 'First',
        ),
      );
    }

    if (showPrevNext) {
      children.add(
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage == 1
              ? null
              : () => onPageChanged?.call(currentPage - 1),
          tooltip: 'Previous',
        ),
      );
    }

    if (showPageNumbers) {
      final first = pages.first;
      final last = pages.last;
      if (first > 1) {
        children.add(_pageButton(context, 1));
        if (first > 2)
          children.add(
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('...'),
            ),
          );
      }
      for (final p in pages) children.add(_pageButton(context, p));
      if (last < totalPages) {
        if (last < totalPages - 1)
          children.add(
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('...'),
            ),
          );
        children.add(_pageButton(context, totalPages));
      }
    }

    if (showPrevNext) {
      children.add(
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage == totalPages
              ? null
              : () => onPageChanged?.call(currentPage + 1),
          tooltip: 'Next',
        ),
      );
    }

    if (showFirstLast) {
      children.add(
        IconButton(
          icon: const Icon(Icons.last_page),
          onPressed: currentPage == totalPages
              ? null
              : () => onPageChanged?.call(totalPages),
          tooltip: 'Last',
        ),
      );
    }

    if (showItemsPerPage) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: DropdownButton<int>(
            value: itemsPerPageOptions.contains(itemsPerPage)
                ? itemsPerPage
                : itemsPerPageOptions.first,
            items: itemsPerPageOptions
                .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                .toList(),
            onChanged: onItemsPerPageChanged == null
                ? null
                : (int? v) {
                    if (v != null) onItemsPerPageChanged?.call(v);
                  },
          ),
        ),
      );
    }

    return Semantics(
      container: true,
      label: 'Pagination',
      child: ExcludeSemantics(
        excluding: false,
        child: SizedBox(
          height: compactMode ? 40 : 56,
          child: Row(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}
