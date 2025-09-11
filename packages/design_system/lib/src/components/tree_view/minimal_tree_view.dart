import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show SetEquality;
import 'tree_node.dart';

typedef NodeBuilder = Widget Function(BuildContext context, TreeNode node);

class MinimalTreeView extends StatefulWidget {
  final List<TreeNode> nodes;
  final ValueChanged<TreeNode>? onNodeTap;
  final ValueChanged<TreeNode>? onNodeExpanded;
  final ValueChanged<TreeNode>? onNodeCollapsed;
  final Set<String> expandedNodes;
  final Set<String> selectedNodes;
  final bool multiSelect;
  final bool showConnectingLines;
  final double indentSize;
  final double nodeHeight;
  final double iconSize;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final NodeBuilder? nodeBuilder;

  const MinimalTreeView({
    Key? key,
    this.nodes = const [],
    this.onNodeTap,
    this.onNodeExpanded,
    this.onNodeCollapsed,
    this.expandedNodes = const {},
    this.selectedNodes = const {},
    this.multiSelect = false,
    this.showConnectingLines = true,
    this.indentSize = 20.0,
    this.nodeHeight = 40.0,
    this.iconSize = 18.0,
    this.padding,
    this.physics,
    this.nodeBuilder,
  }) : super(key: key);

  @override
  State<MinimalTreeView> createState() => _MinimalTreeViewState();
}

class _MinimalTreeViewState extends State<MinimalTreeView> {
  late Set<String> _expanded;
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _expanded = Set<String>.from(widget.expandedNodes);
    _selected = Set<String>.from(widget.selectedNodes);
  }

  void _toggleExpand(TreeNode node) {
    setState(() {
      if (_expanded.contains(node.id)) {
        _expanded.remove(node.id);
        widget.onNodeCollapsed?.call(node);
      } else {
        _expanded.add(node.id);
        widget.onNodeExpanded?.call(node);
      }
    });
  }

  void _tapNode(TreeNode node) {
    setState(() {
      if (widget.multiSelect) {
        if (_selected.contains(node.id)) {
          _selected.remove(node.id);
        } else {
          _selected.add(node.id);
        }
      } else {
        _selected
          ..clear()
          ..add(node.id);
      }
      widget.onNodeTap?.call(node);
    });
  }

  Widget _buildRow(TreeNode node, int depth) {
    final bool expanded = _expanded.contains(node.id);
    final bool selected = _selected.contains(node.id);

    Widget content;
    if (widget.nodeBuilder != null) {
      content = widget.nodeBuilder!(context, node);
    } else {
      content = Row(
        children: [
          if (node.hasChildren)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _toggleExpand(node),
              child: SizedBox(
                width: widget.iconSize + 8,
                height: widget.nodeHeight,
                child: Center(
                  child: Icon(
                    expanded ? Icons.expand_more : Icons.chevron_right,
                    size: widget.iconSize,
                  ),
                ),
              ),
            )
          else
            SizedBox(width: widget.iconSize + 8),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _tapNode(node),
              child: Container(
                height: widget.nodeHeight,
                alignment: Alignment.centerLeft,
                child: Text(node.label),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      color: selected ? Theme.of(context).highlightColor : null,
      padding: EdgeInsets.only(left: depth * widget.indentSize),
      child: content,
    );
  }

  Widget _buildTree(List<TreeNode> nodes, int depth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nodes.map((node) {
        final childrenWidgets = <Widget>[];
        childrenWidgets.add(_buildRow(node, depth));
        if (_expanded.contains(node.id) && node.hasChildren) {
          childrenWidgets.add(_buildTree(node.children, depth + 1));
        }
        return Column(children: childrenWidgets);
      }).toList(),
    );
  }

  @override
  void didUpdateWidget(covariant MinimalTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Respect external controlled expanded/selected sets if changed
    if (!const SetEquality<String>().equals(
      oldWidget.expandedNodes,
      widget.expandedNodes,
    )) {
      _expanded = Set<String>.from(widget.expandedNodes);
    }
    if (!const SetEquality<String>().equals(
      oldWidget.selectedNodes,
      widget.selectedNodes,
    )) {
      _selected = Set<String>.from(widget.selectedNodes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: widget.physics,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: _buildTree(widget.nodes, 0),
      ),
    );
  }
}
