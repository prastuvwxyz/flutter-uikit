import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum CRUDLayout { adaptive, list, masterDetail }

/// A minimal, reusable CRUD template widget.
///
/// This implements the API described in UIK-302 with a small, testable
/// surface: list view, optional detail view, and optional create/edit form.
class CRUDTemplate<T> extends StatefulWidget {
  final String? title;
  final List<T>? items;
  final Widget Function(T, int)? listBuilder;
  final Widget Function(T)? detailBuilder;
  final Widget Function(T?)? formBuilder;
  final ValueChanged<T>? onItemTap;
  final VoidCallback? onAdd;
  final ValueChanged<T>? onEdit;
  final ValueChanged<T>? onDelete;
  final bool searchable;
  final bool filterable;
  final bool sortable;
  final CRUDLayout layout;

  const CRUDTemplate({
    super.key,
    this.title,
    this.items,
    this.listBuilder,
    this.detailBuilder,
    this.formBuilder,
    this.onItemTap,
    this.onAdd,
    this.onEdit,
    this.onDelete,
    this.searchable = true,
    this.filterable = true,
    this.sortable = true,
    this.layout = CRUDLayout.adaptive,
  });

  @override
  State<CRUDTemplate<T>> createState() => _CRUDTemplateState<T>();
}

class _CRUDTemplateState<T> extends State<CRUDTemplate<T>> {
  String _query = '';
  T? _selected;

  List<T> get _items => widget.items ?? <T>[];

  List<T> get _filtered {
    if (!widget.searchable || _query.isEmpty) return _items;
    // Fallback: use toString for simple search. Consumers may provide
    // custom filtering by passing filtered `items` prop.
    return _items
        .where((e) => describeEnumOrToString(e).contains(_query))
        .toList();
  }

  static String describeEnumOrToString(Object? v) {
    if (v == null) return '';
    try {
      return describeEnum(v as Enum);
    } catch (_) {
      return v.toString().toLowerCase();
    }
  }

  void _onTapItem(T item) {
    setState(() => _selected = item);
    widget.onItemTap?.call(item);
  }

  void _onAdd() {
    widget.onAdd?.call();
    // Optionally open create form - consumers can provide onAdd navigation.
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final useMasterDetail =
        widget.layout == CRUDLayout.masterDetail ||
        (widget.layout == CRUDLayout.adaptive && isWide);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
        actions: [
          if (widget.searchable)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: 200,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onAdd,
            tooltip: 'Add',
          ),
        ],
      ),
      body: useMasterDetail ? _buildMasterDetail(context) : _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox, size: 64, color: Colors.black26),
            const SizedBox(height: 12),
            const Text('No items'),
            if (widget.onAdd != null)
              ElevatedButton(onPressed: _onAdd, child: const Text('Add')),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        if (widget.listBuilder != null) {
          return InkWell(
            onTap: () => _onTapItem(item),
            child: widget.listBuilder!(item, index),
          );
        }
        // Default list tile
        return ListTile(
          title: Text(_itemTitle(item)),
          subtitle: Text(_itemSubtitle(item)),
          onTap: () => _onTapItem(item),
          trailing: PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') widget.onEdit?.call(item);
              if (v == 'delete') widget.onDelete?.call(item);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMasterDetail(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 1, child: _buildList(context)),
        const VerticalDivider(width: 1),
        Flexible(
          flex: 2,
          child: _selected != null
              ? _buildDetail(context, _selected as T)
              : const Center(child: Text('Select an item')),
        ),
      ],
    );
  }

  Widget _buildDetail(BuildContext context, T item) {
    if (widget.detailBuilder != null) {
      return widget.detailBuilder!(item);
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_itemTitle(item), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(_itemSubtitle(item)),
          const Spacer(),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => widget.onEdit?.call(item),
                child: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => widget.onDelete?.call(item),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _itemTitle(T item) {
    // Give consumers control by using toString() as a simple fallback.
    final s = item?.toString() ?? '';
    final lines = s.split('\n');
    return lines.isNotEmpty ? lines.first : s;
  }

  String _itemSubtitle(T item) {
    final s = item?.toString() ?? '';
    final lines = s.split('\n');
    return lines.length > 1 ? lines.sublist(1).join(' ').trim() : '';
  }
}
