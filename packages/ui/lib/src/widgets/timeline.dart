import 'package:flutter/material.dart';

enum TimelineAlignment {
  left,
  center,
  right,
}

class TimelineItem {
  final Widget content;
  final Color? indicatorColor;
  final Widget? customIndicator;
  final DateTime? timestamp;
  final String? title;

  const TimelineItem({
    required this.content,
    this.indicatorColor,
    this.customIndicator,
    this.timestamp,
    this.title,
  });
}

typedef TimelineItemBuilder = Widget Function(BuildContext, TimelineItem, int);

class Timeline extends StatelessWidget {
  final List<TimelineItem> items;
  final Axis direction;
  final TimelineAlignment alignment;
  final double indicatorSize;
  final double lineWidth;
  final Color? lineColor;
  final Color? indicatorColor;
  final double spacing;
  final double itemSpacing;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsets? padding;
  final TimelineItemBuilder? itemBuilder;

  const Timeline({
    Key? key,
    this.items = const [],
    this.direction = Axis.vertical,
    this.alignment = TimelineAlignment.left,
    this.indicatorSize = 12.0,
    this.lineWidth = 2.0,
    this.lineColor,
    this.indicatorColor,
    this.spacing = 16.0,
    this.itemSpacing = 8.0,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.vertical) {
      return ListView.separated(
        padding: padding,
        physics: physics,
        shrinkWrap: shrinkWrap,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: spacing),
        itemBuilder: (ctx, index) {
          final item = items[index];
          return _buildVerticalItem(ctx, item, index);
        },
      );
    }

    return SingleChildScrollView(
      padding: padding,
      physics: physics,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
        children: List.generate(items.length * 2 - 1, (i) {
          if (i.isEven) {
            final idx = i ~/ 2;
            return _buildHorizontalItem(context, items[idx], idx);
          }
          return SizedBox(width: spacing);
        }),
      ),
    );
  }

  Widget _buildVerticalItem(
    BuildContext context,
    TimelineItem item,
    int index,
  ) {
    final color = item.indicatorColor ??
        indicatorColor ??
        Theme.of(context).colorScheme.primary;
    final lineCol =
        lineColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);

    final indicator = item.customIndicator ?? Container(
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    final line = Expanded(
      child: Container(width: lineWidth, color: lineCol),
    );

    final content = itemBuilder != null
        ? itemBuilder!(context, item, index)
        : DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
            child: item.content,
          );

    Widget axisColumn = Column(
      children: [
        indicator,
        if (index != items.length - 1) SizedBox(height: itemSpacing),
        if (index != items.length - 1) line,
      ],
    );

    Widget row;
    if (alignment == TimelineAlignment.center) {
      row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: spacing),
          axisColumn,
          SizedBox(width: itemSpacing),
          Expanded(child: content),
          SizedBox(width: spacing),
        ],
      );
    } else if (alignment == TimelineAlignment.right) {
      row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: content),
          SizedBox(width: itemSpacing),
          axisColumn,
        ],
      );
    } else {
      row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          axisColumn,
          SizedBox(width: itemSpacing),
          Expanded(child: content),
        ],
      );
    }

    return IntrinsicHeight(
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), child: row),
    );
  }

  Widget _buildHorizontalItem(
    BuildContext context,
    TimelineItem item,
    int index,
  ) {
    final color = item.indicatorColor ??
        indicatorColor ??
        Theme.of(context).colorScheme.primary;
    final indicator = item.customIndicator ?? Container(
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    final content = itemBuilder != null
        ? itemBuilder!(context, item, index)
        : DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
            child: item.content,
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        SizedBox(height: itemSpacing),
        SizedBox(width: 160, child: content),
      ],
    );
  }
}