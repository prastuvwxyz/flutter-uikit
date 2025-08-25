import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

/// Callback for refresh operations that return a Future
typedef RefreshCallback = Future<void> Function();

/// A minimal list component with support for virtualization, custom item builders,
/// loading states, empty states, error states, pull-to-refresh, and infinite scroll.
///
/// The list can be configured for vertical or horizontal scrolling and includes
/// keyboard navigation support for accessibility.
class MinimalList<T> extends StatefulWidget {
  /// The items to display in the list
  final List<T>? items;

  /// The builder function to create list item widgets
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Optional builder function to create separator widgets
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Whether the list is in a loading state
  final bool loading;

  /// Widget to display when the items list is empty
  final Widget? empty;

  /// Widget to display when there is an error
  final Widget? error;

  /// Whether to enable virtualization for better performance with large lists
  final bool virtualized;

  /// The scroll direction of the list
  final Axis scrollDirection;

  /// Padding around the list content
  final EdgeInsets? padding;

  /// Callback function for pull-to-refresh
  final RefreshCallback? onRefresh;

  /// Callback function for infinite scroll load more
  final VoidCallback? onLoadMore;

  /// Callback function when an item is tapped
  final void Function(T item, int index)? onItemTap;

  /// Creates a MinimalList component.
  const MinimalList({
    super.key,
    required this.itemBuilder,
    this.items,
    this.separatorBuilder,
    this.loading = false,
    this.empty,
    this.error,
    this.virtualized = true,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.onRefresh,
    this.onLoadMore,
    this.onItemTap,
  });

  @override
  State<MinimalList<T>> createState() => _MinimalListState<T>();
}

class _MinimalListState<T> extends State<MinimalList<T>> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    _setupKeyboardListener();
  }

  void _setupScrollListener() {
    if (widget.onLoadMore != null) {
      _scrollController.addListener(() {
        if (!_isLoadingMore &&
            _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 300) {
          setState(() {
            _isLoadingMore = true;
          });
          widget.onLoadMore!();
          // Reset the loading more state after a delay to prevent multiple triggers
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isLoadingMore = false;
              });
            }
          });
        }
      });
    }
  }

  void _setupKeyboardListener() {
    // Keyboard navigation is handled via focus and key handling in build method
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Builds loading skeleton placeholders
  Widget _buildLoadingState() {
    return ListView.separated(
      scrollDirection: widget.scrollDirection,
      padding: widget.padding,
      itemCount: 5, // Show 5 skeleton items
      separatorBuilder:
          widget.separatorBuilder ??
          (context, _) => const SizedBox(height: 8, width: 8),
      itemBuilder: (context, index) => _buildSkeletonItem(context),
    );
  }

  /// Builds a skeleton placeholder item
  Widget _buildSkeletonItem(BuildContext context) {
    final isVertical = widget.scrollDirection == Axis.vertical;
    return Container(
      height: isVertical ? 60 : double.infinity,
      width: isVertical ? double.infinity : 200,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Builds the empty state widget
  Widget _buildEmptyState() {
    if (widget.empty != null) {
      return widget.empty!;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the error state widget
  Widget _buildErrorState() {
    if (widget.error != null) {
      return widget.error!;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Handles keyboard navigation
  Widget _buildKeyboardNavigableList(Widget child) {
    return Focus(
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;

        if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _scrollController.animateTo(
            _scrollController.offset + 60,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _scrollController.animateTo(
            _scrollController.offset - 60,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.home) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.end) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
          _scrollController.animateTo(
            _scrollController.offset -
                _scrollController.position.viewportDimension,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
          _scrollController.animateTo(
            _scrollController.offset +
                _scrollController.position.viewportDimension,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      autofocus: true,
      child: child,
    );
  }

  /// Builds a virtualized list with ListView.builder
  Widget _buildVirtualizedList() {
    final items = widget.items ?? [];

    // Handle empty list when not loading
    if (items.isEmpty && !widget.loading) {
      return _buildEmptyState();
    }

    final hasRefresh = widget.onRefresh != null;

    Widget listView;
    if (widget.separatorBuilder != null) {
      listView = ListView.separated(
        controller: _scrollController,
        scrollDirection: widget.scrollDirection,
        padding: widget.padding,
        itemCount: items.length,
        separatorBuilder: widget.separatorBuilder!,
        itemBuilder: (context, index) {
          final item = items[index];
          return _wrapWithTapHandler(
            widget.itemBuilder(context, item, index),
            item,
            index,
          );
        },
      );
    } else {
      listView = ListView.builder(
        controller: _scrollController,
        scrollDirection: widget.scrollDirection,
        padding: widget.padding,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _wrapWithTapHandler(
            widget.itemBuilder(context, item, index),
            item,
            index,
          );
        },
      );
    }

    // Add keyboard navigation
    listView = _buildKeyboardNavigableList(listView);

    // Add semantic container for accessibility
    listView = Semantics(
      container: true,
      liveRegion: true,
      label: 'List of items',
      explicitChildNodes: true,
      child: listView,
    );

    // Add pull to refresh if needed
    if (hasRefresh) {
      return RefreshIndicator(onRefresh: widget.onRefresh!, child: listView);
    }

    return listView;
  }

  /// Builds a non-virtualized list with ListView
  Widget _buildNonVirtualizedList() {
    final items = widget.items ?? [];

    // Handle empty list when not loading
    if (items.isEmpty && !widget.loading) {
      return _buildEmptyState();
    }

    final hasRefresh = widget.onRefresh != null;

    List<Widget> children = [];
    for (int i = 0; i < items.length; i++) {
      children.add(
        _wrapWithTapHandler(
          widget.itemBuilder(context, items[i], i),
          items[i],
          i,
        ),
      );

      if (widget.separatorBuilder != null && i < items.length - 1) {
        children.add(widget.separatorBuilder!(context, i));
      }
    }

    Widget listView = SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: widget.scrollDirection,
      padding: widget.padding,
      child: widget.scrollDirection == Axis.vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
    );

    // Add keyboard navigation
    listView = _buildKeyboardNavigableList(listView);

    // Add semantic container for accessibility
    listView = Semantics(
      container: true,
      liveRegion: true,
      label: 'List of items',
      explicitChildNodes: true,
      child: listView,
    );

    // Add pull to refresh if needed
    if (hasRefresh) {
      return RefreshIndicator(onRefresh: widget.onRefresh!, child: listView);
    }

    return listView;
  }

  /// Wraps a widget with tap handling functionality
  Widget _wrapWithTapHandler(Widget child, T item, int index) {
    if (widget.onItemTap == null) return child;

    return InkWell(onTap: () => widget.onItemTap!(item, index), child: child);
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (widget.loading) {
      return _buildLoadingState();
    }

    // Show error state if provided and no items
    if (widget.error != null &&
        (widget.items == null || widget.items!.isEmpty)) {
      return _buildErrorState();
    }

    // Build list based on virtualization flag
    return widget.virtualized
        ? _buildVirtualizedList()
        : _buildNonVirtualizedList();
  }
}
