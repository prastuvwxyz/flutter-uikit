import 'package:flutter/material.dart';

/// A collapsible accordion widget for organizing content into expandable sections.
class Accordion extends StatefulWidget {
  /// List of accordion items
  final List<AccordionItem> items;

  /// Whether multiple sections can be expanded at once
  final bool allowMultipleExpanded;

  /// Initially expanded items (by index)
  final Set<int> initiallyExpanded;

  /// Callback when an item is expanded/collapsed
  final Function(int index, bool isExpanded)? onExpansionChanged;

  /// Padding around the accordion
  final EdgeInsets? padding;

  /// Spacing between accordion items
  final double spacing;

  /// Whether to show dividers between items
  final bool showDividers;

  /// Animation duration for expand/collapse
  final Duration animationDuration;

  const Accordion({
    super.key,
    required this.items,
    this.allowMultipleExpanded = false,
    this.initiallyExpanded = const {},
    this.onExpansionChanged,
    this.padding,
    this.spacing = 0.0,
    this.showDividers = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> with TickerProviderStateMixin {
  late Set<int> _expandedItems;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _expandedItems = Set<int>.from(widget.initiallyExpanded);

    _animationControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _animations = _animationControllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    }).toList();

    // Initialize expanded states
    for (int i = 0; i < widget.items.length; i++) {
      if (_expandedItems.contains(i)) {
        _animationControllers[i].value = 1.0;
      }
    }
  }

  @override
  void didUpdateWidget(Accordion oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items.length != widget.items.length) {
      // Dispose old controllers
      for (var controller in _animationControllers) {
        controller.dispose();
      }

      // Create new controllers
      _animationControllers = List.generate(
        widget.items.length,
        (index) => AnimationController(
          duration: widget.animationDuration,
          vsync: this,
        ),
      );

      _animations = _animationControllers.map((controller) {
        return CurvedAnimation(parent: controller, curve: Curves.easeInOut);
      }).toList();

      // Reset expanded state
      _expandedItems.clear();
      _expandedItems.addAll(widget.initiallyExpanded);

      for (int i = 0; i < widget.items.length; i++) {
        if (_expandedItems.contains(i)) {
          _animationControllers[i].value = 1.0;
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpansion(int index) {
    setState(() {
      final isExpanded = _expandedItems.contains(index);

      if (isExpanded) {
        _expandedItems.remove(index);
        _animationControllers[index].reverse();
      } else {
        if (!widget.allowMultipleExpanded) {
          // Collapse all other items
          for (int i = 0; i < widget.items.length; i++) {
            if (i != index && _expandedItems.contains(i)) {
              _expandedItems.remove(i);
              _animationControllers[i].reverse();
            }
          }
        }
        _expandedItems.add(index);
        _animationControllers[index].forward();
      }

      widget.onExpansionChanged?.call(index, !isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget accordion = ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      separatorBuilder: (context, index) {
        if (widget.showDividers) {
          return Divider(
            height: widget.spacing,
            thickness: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          );
        }
        return SizedBox(height: widget.spacing);
      },
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final isExpanded = _expandedItems.contains(index);

        return _AccordionItemWidget(
          item: item,
          isExpanded: isExpanded,
          animation: _animations[index],
          onTap: () => _toggleExpansion(index),
        );
      },
    );

    if (widget.padding != null) {
      accordion = Padding(
        padding: widget.padding!,
        child: accordion,
      );
    }

    return accordion;
  }
}

/// Data model for accordion items
class AccordionItem {
  /// Header content (always visible)
  final Widget header;

  /// Body content (shown when expanded)
  final Widget body;

  /// Whether this item is disabled
  final bool disabled;

  /// Optional leading widget for the header
  final Widget? leading;

  /// Optional trailing widget for the header (besides the expand icon)
  final Widget? trailing;

  /// Custom header padding
  final EdgeInsets? headerPadding;

  /// Custom body padding
  final EdgeInsets? bodyPadding;

  /// Background color for the item
  final Color? backgroundColor;

  /// Text style for the header
  final TextStyle? headerTextStyle;

  const AccordionItem({
    required this.header,
    required this.body,
    this.disabled = false,
    this.leading,
    this.trailing,
    this.headerPadding,
    this.bodyPadding,
    this.backgroundColor,
    this.headerTextStyle,
  });
}

/// Internal widget for rendering individual accordion items
class _AccordionItemWidget extends StatelessWidget {
  final AccordionItem item;
  final bool isExpanded;
  final Animation<double> animation;
  final VoidCallback onTap;

  const _AccordionItemWidget({
    required this.item,
    required this.isExpanded,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: item.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.disabled ? null : onTap,
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                padding: item.headerPadding ??
                         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    if (item.leading != null) ...[
                      item.leading!,
                      const SizedBox(width: 12.0),
                    ],
                    Expanded(
                      child: DefaultTextStyle(
                        style: item.headerTextStyle ??
                               theme.textTheme.titleMedium ??
                               const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        child: item.header,
                      ),
                    ),
                    if (item.trailing != null) ...[
                      const SizedBox(width: 12.0),
                      item.trailing!,
                    ],
                    const SizedBox(width: 8.0),
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.chevron_right,
                        color: item.disabled
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                          : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Body
          SizeTransition(
            sizeFactor: animation,
            child: Container(
              width: double.infinity,
              padding: item.bodyPadding ??
                       const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: item.body,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pre-built accordion types for common use cases
class AccordionTypes {
  /// Simple text accordion
  static AccordionItem text({
    required String title,
    required String content,
    Widget? leading,
    Widget? trailing,
    bool disabled = false,
  }) {
    return AccordionItem(
      header: Text(title),
      body: Text(content),
      leading: leading,
      trailing: trailing,
      disabled: disabled,
    );
  }

  /// FAQ-style accordion
  static AccordionItem faq({
    required String question,
    required String answer,
    bool disabled = false,
  }) {
    return AccordionItem(
      header: Text(question),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          answer,
          style: const TextStyle(height: 1.5),
        ),
      ),
      disabled: disabled,
      leading: const Icon(Icons.help_outline, size: 20),
    );
  }

  /// Card-style accordion with custom content
  static AccordionItem card({
    required Widget header,
    required Widget body,
    Widget? leading,
    Widget? trailing,
    Color? backgroundColor,
    bool disabled = false,
  }) {
    return AccordionItem(
      header: header,
      body: body,
      leading: leading,
      trailing: trailing,
      backgroundColor: backgroundColor,
      disabled: disabled,
      headerPadding: const EdgeInsets.all(16.0),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    );
  }
}

/// Extension for easier accordion creation
extension AccordionExtension on List<AccordionItem> {
  /// Convert list of accordion items to an Accordion widget
  Widget toAccordion({
    bool allowMultipleExpanded = false,
    Set<int> initiallyExpanded = const {},
    Function(int index, bool isExpanded)? onExpansionChanged,
    EdgeInsets? padding,
    double spacing = 0.0,
    bool showDividers = true,
    Duration animationDuration = const Duration(milliseconds: 200),
  }) {
    return Accordion(
      items: this,
      allowMultipleExpanded: allowMultipleExpanded,
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
      padding: padding,
      spacing: spacing,
      showDividers: showDividers,
      animationDuration: animationDuration,
    );
  }
}