import 'package:flutter/material.dart';
import 'breadcrumb_item.dart';

enum BreadcrumbOverflow { wrap, scroll, collapse }

class MinimalBreadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final ValueChanged<int>? onItemTapped;
  final Widget? separator;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final int? maxItems;
  final BreadcrumbOverflow overflow;
  final TextStyle? itemStyle;
  final TextStyle? currentItemStyle;
  final TextStyle? separatorStyle;
  final double spacing;
  final double runSpacing;

  const MinimalBreadcrumbs({
    Key? key,
    this.items = const [],
    this.onItemTapped,
    this.separator,
    this.separatorBuilder,
    this.maxItems,
    this.overflow = BreadcrumbOverflow.wrap,
    this.itemStyle,
    this.currentItemStyle,
    this.separatorStyle,
    this.spacing = 8.0,
    this.runSpacing = 4.0,
  }) : super(key: key);

  Widget _buildSeparator(BuildContext context, int index) {
    if (separatorBuilder != null) return separatorBuilder!(context, index);
    if (separator != null) return separator!;
    return Text(
      '/',
      style: separatorStyle ?? Theme.of(context).textTheme.bodySmall,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final visibleItems = items;

    Widget content;

    // Build row of items with separators
    List<Widget> children = [];
    for (var i = 0; i < visibleItems.length; i++) {
      final item = visibleItems[i];
      final isCurrent = item.isCurrent;

      final child = GestureDetector(
        onTap: isCurrent ? null : () => onItemTapped?.call(i),
        child: DefaultTextStyle(
          style: isCurrent
              ? (currentItemStyle ??
                    const TextStyle(fontWeight: FontWeight.bold))
              : (itemStyle ?? const TextStyle()),
          child: item.child,
        ),
      );

      children.add(child);

      if (i != visibleItems.length - 1) {
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: _buildSeparator(context, i),
          ),
        );
      }
    }

    if (overflow == BreadcrumbOverflow.scroll) {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: children),
      );
    } else if (overflow == BreadcrumbOverflow.wrap) {
      content = Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: children,
      );
    } else {
      // collapse - simple truncation with ellipsis in middle when maxItems provided
      if (maxItems != null && items.length > maxItems!) {
        final headCount = (maxItems! / 2).floor();
        final tailCount = maxItems! - headCount - 1;
        final List<Widget> collapsed = [];

        for (var i = 0; i < headCount; i++) {
          collapsed.add(
            children[i * 2],
          ); // account for separators in children list
          collapsed.add(
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing / 2),
              child: _buildSeparator(context, i),
            ),
          );
        }

        collapsed.add(
          Text(
            '…',
            style: separatorStyle ?? Theme.of(context).textTheme.bodySmall,
          ),
        );

        for (var i = items.length - tailCount; i < items.length; i++) {
          collapsed.add(
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing / 2),
              child: _buildSeparator(context, i - 1),
            ),
          );
          collapsed.add(children[(i * 2)]);
        }

        content = Row(children: collapsed);
      } else {
        content = Row(children: children);
      }
    }

    return Semantics(
      container: true,
      label: 'Breadcrumbs',
      child: ExcludeSemantics(child: content),
    );
  }
}
