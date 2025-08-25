import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'tab_item.dart';
import 'tab_variant.dart';

/// A customizable tabs component for horizontal navigation with multiple variants.
///
/// [MinimalTabs] supports three visual styles (underline, pill, segmented),
/// three sizes (sm, md, lg), optional scrolling for many tabs, badges, and icons.
/// It's fully accessible with keyboard navigation and screen reader support.
class MinimalTabs extends StatefulWidget {
  /// List of tab items to display
  final List<TabItem> tabs;

  /// Currently selected tab index
  final int selectedIndex;

  /// Callback triggered when a tab is selected
  final ValueChanged<int>? onTabChanged;

  /// Visual style of tabs (underline, pill, segmented)
  final TabVariant variant;

  /// Size variant for tabs (sm, md, lg)
  final TabSize size;

  /// Whether tabs should horizontally scroll when they don't fit
  final bool scrollable;

  /// Whether tabs should be centered when not scrollable
  final bool centered;

  /// Whether tabs should expand to fill available width
  final bool fullWidth;

  /// Creates a [MinimalTabs] component.
  ///
  /// The [tabs] parameter must not be empty.
  /// The [selectedIndex] must be valid for the provided [tabs] list.
  const MinimalTabs({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.onTabChanged,
    this.variant = TabVariant.underline,
    this.size = TabSize.md,
    this.scrollable = false,
    this.centered = false,
    this.fullWidth = false,
  });

  @override
  State<MinimalTabs> createState() => _MinimalTabsState();
}

class _MinimalTabsState extends State<MinimalTabs>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  late final ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
    _controller.addListener(_handleTabChange);
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedTab();
    });
  }

  @override
  void didUpdateWidget(MinimalTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabs.length != widget.tabs.length) {
      _controller.dispose();
      _controller = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.selectedIndex,
      );
      _controller.addListener(_handleTabChange);
    } else if (oldWidget.selectedIndex != widget.selectedIndex) {
      _controller.animateTo(widget.selectedIndex);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedTab();
      });
    }
  }

  void _handleTabChange() {
    if (_controller.indexIsChanging) {
      widget.onTabChanged?.call(_controller.index);
      _scrollToSelectedTab();
    }
  }

  void _scrollToSelectedTab() {
    if (!widget.scrollable || !mounted) return;

    // Get the rendering box for the selected tab
    final RenderBox? renderBox = _getTabRenderBox(_controller.index);
    if (renderBox == null) return;

    // Calculate scroll position to center the tab
    final tabCenter = renderBox
        .localToGlobal(Offset(renderBox.size.width / 2, 0))
        .dx;

    final screenWidth = MediaQuery.of(context).size.width;
    final scrollTarget = tabCenter - (screenWidth / 2);

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        scrollTarget.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  RenderBox? _getTabRenderBox(int index) {
    // Need a valid index and context to proceed
    if (index < 0 || index >= widget.tabs.length || !mounted) {
      return null;
    }

    // Find the render object for the tab at the given index
    final tabKey = GlobalKey();
    final tabContext = tabKey.currentContext;
    if (tabContext == null) return null;

    return tabContext.findRenderObject() as RenderBox?;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTabChange);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyPress,
      child: Semantics(
        container: true,
        label: 'Tab navigation',
        explicitChildNodes: true,
        child: _buildTabs(context, tokens),
      ),
    );
  }

  Widget _buildTabs(BuildContext context, UiTokens tokens) {
    // Determine the tab bar's layout and styling based on properties
    final EdgeInsets padding = _getPadding(tokens);
    final TextStyle textStyle = _getTextStyle(tokens);

    // Create the tab bar
    final tabBar = TabBar(
      controller: _controller,
      tabs: _buildTabWidgets(textStyle, tokens),
      isScrollable: widget.scrollable,
      labelPadding: padding,
      padding: EdgeInsets.zero,
      tabAlignment: _getTabAlignment(),
      dividerColor: Colors.transparent,
      // Apply variant-specific styling
      indicator: _buildIndicator(tokens),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: tokens.colorTokens.primary.shade500,
      unselectedLabelColor: tokens.colorTokens.neutral.shade500,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.hovered)) {
          return tokens.colorTokens.neutral.shade100;
        }
        return Colors.transparent;
      }),
    );

    // Apply additional styling based on variant
    return switch (widget.variant) {
      TabVariant.underline => tabBar,
      TabVariant.pill => _decorateWithPillStyling(tabBar, tokens),
      TabVariant.segmented => _decorateWithSegmentedStyling(tabBar, tokens),
    };
  }

  TabAlignment _getTabAlignment() {
    if (widget.fullWidth) {
      return TabAlignment.fill;
    } else if (widget.centered && !widget.scrollable) {
      return TabAlignment.center;
    }
    return TabAlignment.start;
  }

  List<Widget> _buildTabWidgets(TextStyle textStyle, UiTokens tokens) {
    return List.generate(widget.tabs.length, (index) {
      final tab = widget.tabs[index];

      // Create the content with icon and/or text
      Widget tabContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tab.icon != null) ...[
            Icon(tab.icon, size: _getIconSize()),
            SizedBox(width: tokens.spacingTokens.sm),
          ],
          Text(tab.label, style: textStyle),
          // Add badge if present
          if (tab.badgeCount != null && tab.badgeCount! > 0) ...[
            SizedBox(width: tokens.spacingTokens.sm),
            _buildBadge(tab.badgeCount!, tokens),
          ],
        ],
      );

      // Apply opacity for disabled state
      if (tab.disabled) {
        tabContent = Opacity(opacity: 0.5, child: tabContent);
      }

      // Wrap in a Semantics widget for accessibility
      return Semantics(
        selected: index == _controller.index,
        enabled: !tab.disabled,
        button: true,
        label: 'Tab ${index + 1}: ${tab.label}',
        child: Tab(child: tabContent),
      );
    });
  }

  Widget _buildBadge(int count, UiTokens tokens) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacingTokens.xs),
      constraints: BoxConstraints(minWidth: _getBadgeSize()),
      decoration: BoxDecoration(
        color: tokens.colorTokens.error,
        borderRadius: BorderRadius.circular(_getBadgeSize() / 2),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        textAlign: TextAlign.center,
        style: tokens.typographyTokens.labelSmall.copyWith(color: Colors.white),
      ),
    );
  }

  Decoration _buildIndicator(UiTokens tokens) {
    return switch (widget.variant) {
      TabVariant.underline => UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2.0,
          color: tokens.colorTokens.primary.shade500,
        ),
      ),
      TabVariant.pill => BoxDecoration(
        borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
        color: tokens.colorTokens.primary.shade100,
      ),
      TabVariant.segmented => BoxDecoration(
        color: tokens.colorTokens.primary.shade500,
        borderRadius: BorderRadius.zero,
      ),
    };
  }

  Widget _decorateWithPillStyling(Widget tabBar, UiTokens tokens) {
    return tabBar;
  }

  Widget _decorateWithSegmentedStyling(Widget tabBar, UiTokens tokens) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: tokens.colorTokens.neutral.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(tokens.radiusTokens.md),
      ),
      child: tabBar,
    );
  }

  EdgeInsets _getPadding(UiTokens tokens) {
    return switch (widget.size) {
      TabSize.sm => EdgeInsets.symmetric(
        vertical: tokens.spacingTokens.xs,
        horizontal: tokens.spacingTokens.sm,
      ),
      TabSize.md => EdgeInsets.symmetric(
        vertical: tokens.spacingTokens.sm,
        horizontal: tokens.spacingTokens.md,
      ),
      TabSize.lg => EdgeInsets.symmetric(
        vertical: tokens.spacingTokens.md,
        horizontal: tokens.spacingTokens.lg,
      ),
    };
  }

  TextStyle _getTextStyle(UiTokens tokens) {
    return switch (widget.size) {
      TabSize.sm => tokens.typographyTokens.labelSmall,
      TabSize.md => tokens.typographyTokens.labelMedium,
      TabSize.lg => tokens.typographyTokens.labelLarge,
    };
  }

  double _getIconSize() {
    return switch (widget.size) {
      TabSize.sm => 16.0,
      TabSize.md => 20.0,
      TabSize.lg => 24.0,
    };
  }

  double _getBadgeSize() {
    return switch (widget.size) {
      TabSize.sm => 16.0,
      TabSize.md => 20.0,
      TabSize.lg => 24.0,
    };
  }

  void _handleKeyPress(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        _moveSelection(
          Directionality.of(context) == TextDirection.rtl ? 1 : -1,
        );
        break;
      case LogicalKeyboardKey.arrowRight:
        _moveSelection(
          Directionality.of(context) == TextDirection.rtl ? -1 : 1,
        );
        break;
      case LogicalKeyboardKey.home:
        _moveToEnd(true);
        break;
      case LogicalKeyboardKey.end:
        _moveToEnd(false);
        break;
      default:
        break;
    }
  }

  void _moveSelection(int delta) {
    final int currentIndex = _controller.index;
    final int nextIndex = (currentIndex + delta).clamp(
      0,
      widget.tabs.length - 1,
    );

    // Skip disabled tabs
    if (widget.tabs[nextIndex].disabled) {
      if (delta > 0 && nextIndex < widget.tabs.length - 1) {
        _moveSelection(delta + 1);
      } else if (delta < 0 && nextIndex > 0) {
        _moveSelection(delta - 1);
      }
      return;
    }

    if (nextIndex != currentIndex) {
      _controller.animateTo(nextIndex);
    }
  }

  void _moveToEnd(bool toStart) {
    final int targetIndex = toStart ? 0 : widget.tabs.length - 1;

    // Find the first enabled tab from the end
    int index = targetIndex;
    final int step = toStart ? 1 : -1;

    while (widget.tabs[index].disabled) {
      index += step;
      if (index < 0 || index >= widget.tabs.length) {
        return; // No enabled tabs found
      }
    }

    if (index != _controller.index) {
      _controller.animateTo(index);
    }
  }
}
