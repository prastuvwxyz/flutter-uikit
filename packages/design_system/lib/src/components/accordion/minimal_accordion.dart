import 'package:flutter/material.dart';

typedef HeaderBuilder = Widget Function(BuildContext context, bool isExpanded);
typedef BodyBuilder = Widget Function(BuildContext context);

class MinimalAccordionPanel {
  const MinimalAccordionPanel({
    required this.headerBuilder,
    required this.bodyBuilder,
    this.isExpanded = false,
    this.canTapOnHeader = true,
    this.backgroundColor,
  });

  final HeaderBuilder headerBuilder;
  final BodyBuilder bodyBuilder;
  final bool isExpanded;
  final bool canTapOnHeader;
  final Color? backgroundColor;
}

class MinimalAccordion extends StatefulWidget {
  const MinimalAccordion({
    super.key,
    required this.children,
    this.expandedPanels = const <int>{},
    this.onExpansionChanged,
    this.allowMultipleExpanded = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.elevation = 0.0,
    this.expandIconColor,
    this.dividerColor,
  });

  final List<MinimalAccordionPanel> children;
  final Set<int> expandedPanels;
  final ValueChanged<Set<int>>? onExpansionChanged;
  final bool allowMultipleExpanded;
  final Duration animationDuration;
  final double elevation;
  final Color? expandIconColor;
  final Color? dividerColor;

  @override
  State<MinimalAccordion> createState() => _MinimalAccordionState();
}

class _MinimalAccordionState extends State<MinimalAccordion> {
  void _togglePanel(int index) {
    final newExpanded = Set<int>.from(widget.expandedPanels);

    if (newExpanded.contains(index)) {
      newExpanded.remove(index);
    } else {
      if (!widget.allowMultipleExpanded) newExpanded.clear();
      newExpanded.add(index);
    }

    widget.onExpansionChanged?.call(newExpanded);
  }

  Widget _buildExpandIcon(bool isExpanded) {
    return AnimatedRotation(
      turns: isExpanded ? 0.5 : 0.0,
      duration: widget.animationDuration,
      child: Icon(
        Icons.expand_more,
        color: widget.expandIconColor ?? Colors.black54,
      ),
    );
  }

  Widget _buildPanel(BuildContext context, int idx) {
    final panel = widget.children[idx];
    final isExpanded = widget.expandedPanels.contains(idx);

    final header = panel.headerBuilder(context, isExpanded);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          elevation: widget.elevation,
          color: panel.backgroundColor ?? Colors.transparent,
          child: InkWell(
            onTap: panel.canTapOnHeader ? () => _togglePanel(idx) : null,
            child: Semantics(
              header: true,
              button: panel.canTapOnHeader,
              expanded: isExpanded,
              child: Row(
                children: [
                  Expanded(child: header),
                  _buildExpandIcon(isExpanded),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: widget.animationDuration,
          curve: Curves.easeInOut,
          child: ConstrainedBox(
            constraints: isExpanded
                ? const BoxConstraints()
                : const BoxConstraints(maxHeight: 0.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: isExpanded
                  ? panel.bodyBuilder(context)
                  : const SizedBox.shrink(),
            ),
          ),
        ),
        if (widget.dividerColor != null)
          Divider(height: 1, color: widget.dividerColor)
        else
          const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        widget.children.length,
        (i) => _buildPanel(context, i),
      ),
    );
  }
}
