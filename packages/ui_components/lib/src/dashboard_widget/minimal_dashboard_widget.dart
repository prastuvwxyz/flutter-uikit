import 'package:flutter/material.dart';

/// A minimal dashboard widget implementing the API described in the task story.
class MinimalDashboardWidget extends StatefulWidget {
  final String title;
  final Widget? content;
  final double? width;
  final double? height;
  final double minWidth;
  final double minHeight;
  final bool isResizable;
  final bool isDraggable;
  final bool isCollapsible;
  final bool isRemovable;
  final bool isCollapsed;
  final ValueChanged<Size>? onResize;
  final ValueChanged<Offset>? onMove;
  final ValueChanged<bool>? onCollapse;
  final VoidCallback? onRemove;
  final VoidCallback? onSettingsTap;
  final List<Widget> headerActions;
  final bool showHeader;
  final bool showBorder;
  final double elevation;

  const MinimalDashboardWidget({
    Key? key,
    this.title = '',
    this.content,
    this.width,
    this.height,
    this.minWidth = 200.0,
    this.minHeight = 150.0,
    this.isResizable = true,
    this.isDraggable = true,
    this.isCollapsible = true,
    this.isRemovable = true,
    this.isCollapsed = false,
    this.onResize,
    this.onMove,
    this.onCollapse,
    this.onRemove,
    this.onSettingsTap,
    this.headerActions = const [],
    this.showHeader = true,
    this.showBorder = true,
    this.elevation = 2.0,
  }) : super(key: key);

  @override
  _MinimalDashboardWidgetState createState() => _MinimalDashboardWidgetState();
}

class _MinimalDashboardWidgetState extends State<MinimalDashboardWidget> {
  late bool _collapsed;

  @override
  void initState() {
    super.initState();
    _collapsed = widget.isCollapsed;
  }

  void _toggleCollapse() {
    if (!widget.isCollapsible) return;
    setState(() {
      _collapsed = !_collapsed;
    });
    widget.onCollapse?.call(_collapsed);
  }

  void _handleRemove() {
    if (!widget.isRemovable) return;
    widget.onRemove?.call();
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.showBorder
        ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
        : null;

    final header = widget.showHeader
        ? Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ...widget.headerActions,
                if (widget.isCollapsible)
                  IconButton(
                    icon: Icon(
                      _collapsed ? Icons.expand_more : Icons.expand_less,
                    ),
                    onPressed: _toggleCollapse,
                    tooltip: _collapsed ? 'Expand' : 'Collapse',
                  ),
                if (widget.isRemovable)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _handleRemove,
                    tooltip: 'Remove',
                  ),
                if (widget.onSettingsTap != null)
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: widget.onSettingsTap,
                    tooltip: 'Settings',
                  ),
              ],
            ),
          )
        : const SizedBox.shrink();

    final content = _collapsed
        ? const SizedBox.shrink()
        : (widget.content ?? const SizedBox.shrink());

    final card = Card(
      elevation: widget.elevation,
      shape: border,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          Flexible(child: content),
        ],
      ),
    );

    final constrained = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth,
        minHeight: widget.minHeight,
        // Honor provided width/height when present by using SizedBox
      ),
      child: SizedBox(width: widget.width, height: widget.height, child: card),
    );

    // For this minimal implementation we don't implement full drag/resize logic.
    // isDraggable and isResizable flags are accepted and can be extended later.

    return Semantics(
      container: true,
      label: widget.title.isNotEmpty ? widget.title : 'Dashboard widget',
      child: constrained,
    );
  }
}
