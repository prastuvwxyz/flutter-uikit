import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Visual style variants for tabs
enum TabVariant {
  /// Tabs with underline indicator (default)
  underline,
  /// Pill-shaped tabs with rounded backgrounds
  pill,
  /// Connected segmented tabs with borders
  segmented,
}

/// Size variants for tabs
enum TabSize {
  /// Small tabs
  sm,
  /// Medium tabs (default)
  md,
  /// Large tabs
  lg,
}

/// Model for a tab item
class TabItem {
  /// Label text for the tab
  final String label;

  /// Optional icon to display
  final IconData? icon;

  /// Optional badge count to show
  final int? badgeCount;

  /// Whether this tab is disabled
  final bool disabled;

  /// Optional trailing widget
  final Widget? trailing;

  /// Tooltip text for the tab
  final String? tooltip;

  const TabItem({
    required this.label,
    this.icon,
    this.badgeCount,
    this.disabled = false,
    this.trailing,
    this.tooltip,
  });
}

/// A customizable tabs component for horizontal navigation with multiple variants
class CustomTabs extends StatefulWidget {
  /// List of tab items to display
  final List<TabItem> tabs;

  /// Currently selected tab index
  final int selectedIndex;

  /// Callback triggered when a tab is selected
  final ValueChanged<int>? onTabChanged;

  /// Visual style of tabs
  final TabVariant variant;

  /// Size variant for tabs
  final TabSize size;

  /// Whether tabs should horizontally scroll when they don't fit
  final bool scrollable;

  /// Whether tabs should be centered when not scrollable
  final bool centered;

  /// Whether tabs should expand to fill available width
  final bool fullWidth;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom selected tab color
  final Color? selectedColor;

  /// Custom unselected tab color
  final Color? unselectedColor;

  /// Background color for the tabs
  final Color? backgroundColor;

  /// Whether to show dividers between tabs (for segmented variant)
  final bool showDividers;

  /// Animation duration for tab transitions
  final Duration animationDuration;

  /// Semantic label for the tab bar
  final String? semanticLabel;

  /// Callback for when a tab is long-pressed
  final ValueChanged<int>? onTabLongPress;

  const CustomTabs({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.onTabChanged,
    this.variant = TabVariant.underline,
    this.size = TabSize.md,
    this.scrollable = false,
    this.centered = false,
    this.fullWidth = false,
    this.indicatorColor,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.showDividers = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.semanticLabel,
    this.onTabLongPress,
  });

  /// Factory for underline tabs
  factory CustomTabs.underline({
    Key? key,
    required List<TabItem> tabs,
    int selectedIndex = 0,
    ValueChanged<int>? onTabChanged,
    TabSize size = TabSize.md,
    bool scrollable = false,
    bool centered = false,
    bool fullWidth = false,
    Color? indicatorColor,
    Color? selectedColor,
    Color? unselectedColor,
    Color? backgroundColor,
    Duration animationDuration = const Duration(milliseconds: 200),
    String? semanticLabel,
    ValueChanged<int>? onTabLongPress,
  }) {
    return CustomTabs(
      key: key,
      tabs: tabs,
      selectedIndex: selectedIndex,
      onTabChanged: onTabChanged,
      variant: TabVariant.underline,
      size: size,
      scrollable: scrollable,
      centered: centered,
      fullWidth: fullWidth,
      indicatorColor: indicatorColor,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      backgroundColor: backgroundColor,
      animationDuration: animationDuration,
      semanticLabel: semanticLabel,
      onTabLongPress: onTabLongPress,
    );
  }

  /// Factory for pill tabs
  factory CustomTabs.pill({
    Key? key,
    required List<TabItem> tabs,
    int selectedIndex = 0,
    ValueChanged<int>? onTabChanged,
    TabSize size = TabSize.md,
    bool scrollable = false,
    bool centered = false,
    Color? indicatorColor,
    Color? selectedColor,
    Color? unselectedColor,
    Color? backgroundColor,
    Duration animationDuration = const Duration(milliseconds: 200),
    String? semanticLabel,
    ValueChanged<int>? onTabLongPress,
  }) {
    return CustomTabs(
      key: key,
      tabs: tabs,
      selectedIndex: selectedIndex,
      onTabChanged: onTabChanged,
      variant: TabVariant.pill,
      size: size,
      scrollable: scrollable,
      centered: centered,
      fullWidth: false, // Pills don't fill width
      indicatorColor: indicatorColor,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      backgroundColor: backgroundColor,
      animationDuration: animationDuration,
      semanticLabel: semanticLabel,
      onTabLongPress: onTabLongPress,
    );
  }

  /// Factory for segmented tabs
  factory CustomTabs.segmented({
    Key? key,
    required List<TabItem> tabs,
    int selectedIndex = 0,
    ValueChanged<int>? onTabChanged,
    TabSize size = TabSize.md,
    Color? indicatorColor,
    Color? selectedColor,
    Color? unselectedColor,
    Color? backgroundColor,
    bool showDividers = true,
    Duration animationDuration = const Duration(milliseconds: 200),
    String? semanticLabel,
    ValueChanged<int>? onTabLongPress,
  }) {
    return CustomTabs(
      key: key,
      tabs: tabs,
      selectedIndex: selectedIndex,
      onTabChanged: onTabChanged,
      variant: TabVariant.segmented,
      size: size,
      scrollable: false, // Segmented tabs don't scroll
      centered: false,
      fullWidth: true, // Segmented tabs fill width
      indicatorColor: indicatorColor,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      backgroundColor: backgroundColor,
      showDividers: showDividers,
      animationDuration: animationDuration,
      semanticLabel: semanticLabel,
      onTabLongPress: onTabLongPress,
    );
  }

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late ScrollController _scrollController;
  late FocusNode _focusNode;
  late List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();

    assert(widget.tabs.isNotEmpty, 'tabs cannot be empty');
    assert(widget.selectedIndex >= 0 && widget.selectedIndex < widget.tabs.length, 'selectedIndex out of range');

    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.selectedIndex,
      animationDuration: widget.animationDuration,
    );
    _controller.addListener(_handleTabChange);

    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToSelectedTab();
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabs.length != widget.tabs.length) {
      _controller.dispose();
      _controller = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.selectedIndex.clamp(0, widget.tabs.length - 1),
        animationDuration: widget.animationDuration,
      );
      _controller.addListener(_handleTabChange);
      _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());
    } else if (oldWidget.selectedIndex != widget.selectedIndex) {
      _controller.animateTo(widget.selectedIndex);
    }

  }

  @override
  void dispose() {
    _controller.removeListener(_handleTabChange);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_controller.indexIsChanging) {
      widget.onTabChanged?.call(_controller.index);
      _scrollToSelectedTab();
    }
  }

  void _scrollToSelectedTab() {
    if (!widget.scrollable || !_scrollController.hasClients || !mounted) {
      return;
    }

    final RenderBox? renderBox = _getTabRenderBox(_controller.index);
    if (renderBox == null) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final tabCenter = renderBox.localToGlobal(Offset(renderBox.size.width / 2, 0)).dx;
    final scrollTarget = tabCenter - (screenWidth / 2);

    _scrollController.animateTo(
      scrollTarget.clamp(0, _scrollController.position.maxScrollExtent),
      duration: widget.animationDuration,
      curve: Curves.easeOut,
    );
  }

  RenderBox? _getTabRenderBox(int index) {
    if (index < 0 || index >= _tabKeys.length || !mounted) return null;

    final context = _tabKeys[index].currentContext;
    return context?.findRenderObject() as RenderBox?;
  }

  /// Handle keyboard navigation
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        _moveSelection(Directionality.of(context) == TextDirection.rtl ? 1 : -1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        _moveSelection(Directionality.of(context) == TextDirection.rtl ? -1 : 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.home:
        _moveToEnd(true);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.end:
        _moveToEnd(false);
        return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _moveSelection(int delta) {
    int nextIndex = (_controller.index + delta).clamp(0, widget.tabs.length - 1);

    // Skip disabled tabs
    while (nextIndex != _controller.index && widget.tabs[nextIndex].disabled) {
      nextIndex = (nextIndex + delta).clamp(0, widget.tabs.length - 1);
      if ((delta > 0 && nextIndex >= widget.tabs.length - 1) ||
          (delta < 0 && nextIndex <= 0)) {
        break;
      }
    }

    if (nextIndex != _controller.index && !widget.tabs[nextIndex].disabled) {
      _controller.animateTo(nextIndex);
      widget.onTabChanged?.call(nextIndex);
    }
  }

  void _moveToEnd(bool toStart) {
    final targetIndex = toStart ? 0 : widget.tabs.length - 1;
    int index = targetIndex;
    final step = toStart ? 1 : -1;

    // Find first enabled tab from target end
    while (index >= 0 && index < widget.tabs.length && widget.tabs[index].disabled) {
      index += step;
    }

    if (index >= 0 && index < widget.tabs.length && index != _controller.index) {
      _controller.animateTo(index);
      widget.onTabChanged?.call(index);
    }
  }

  /// Get padding based on size
  EdgeInsets get _tabPadding {
    switch (widget.size) {
      case TabSize.sm:
        return const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0);
      case TabSize.md:
        return const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
      case TabSize.lg:
        return const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0);
    }
  }

  /// Get text style based on size
  TextStyle get _textStyle {
    switch (widget.size) {
      case TabSize.sm:
        return Theme.of(context).textTheme.labelSmall ?? const TextStyle(fontSize: 11);
      case TabSize.md:
        return Theme.of(context).textTheme.labelMedium ?? const TextStyle(fontSize: 12);
      case TabSize.lg:
        return Theme.of(context).textTheme.labelLarge ?? const TextStyle(fontSize: 14);
    }
  }

  /// Get icon size based on tab size
  double get _iconSize {
    switch (widget.size) {
      case TabSize.sm:
        return 16.0;
      case TabSize.md:
        return 20.0;
      case TabSize.lg:
        return 24.0;
    }
  }

  /// Get badge size based on tab size
  double get _badgeSize {
    switch (widget.size) {
      case TabSize.sm:
        return 16.0;
      case TabSize.md:
        return 20.0;
      case TabSize.lg:
        return 24.0;
    }
  }

  /// Build badge widget
  Widget _buildBadge(int count) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      constraints: BoxConstraints(minWidth: _badgeSize),
      decoration: BoxDecoration(
        color: colorScheme.error,
        borderRadius: BorderRadius.circular(_badgeSize / 2),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onError,
        ) ?? TextStyle(
          fontSize: 10,
          color: colorScheme.onError,
        ),
      ),
    );
  }

  /// Build tab indicator based on variant
  Decoration _buildIndicator() {
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = widget.indicatorColor ?? colorScheme.primary;

    switch (widget.variant) {
      case TabVariant.underline:
        return UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 2.0,
            color: indicatorColor,
          ),
        );
      case TabVariant.pill:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: indicatorColor.withValues(alpha: 0.1),
        );
      case TabVariant.segmented:
        return BoxDecoration(
          color: indicatorColor,
          borderRadius: BorderRadius.circular(6.0),
        );
    }
  }

  /// Get tab alignment
  TabAlignment _getTabAlignment() {
    if (widget.fullWidth) return TabAlignment.fill;
    if (widget.centered && !widget.scrollable) return TabAlignment.center;
    if (!widget.scrollable) return TabAlignment.fill;
    return TabAlignment.start;
  }

  /// Build individual tab widget
  Widget _buildTabWidget(TabItem tab, int index) {
    Widget tabContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tab.icon != null) ...[
          Icon(tab.icon, size: _iconSize),
          const SizedBox(width: 8.0),
        ],
        Text(tab.label, style: _textStyle),
        if (tab.badgeCount != null && tab.badgeCount! > 0) ...[
          const SizedBox(width: 8.0),
          _buildBadge(tab.badgeCount!),
        ],
        if (tab.trailing != null) ...[
          const SizedBox(width: 8.0),
          tab.trailing!,
        ],
      ],
    );

    if (tab.disabled) {
      tabContent = Opacity(opacity: 0.5, child: tabContent);
    }

    Widget tabWidget = Tab(
      key: _tabKeys[index],
      child: IgnorePointer(
        ignoring: tab.disabled,
        child: tabContent,
      ),
    );

    if (tab.tooltip != null) {
      tabWidget = Tooltip(
        message: tab.tooltip!,
        child: tabWidget,
      );
    }

    return Semantics(
      selected: index == _controller.index,
      enabled: !tab.disabled,
      button: true,
      label: 'Tab ${index + 1}: ${tab.label}',
      child: tabWidget,
    );
  }

  /// Build tab bar with variant-specific styling
  Widget _buildTabBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = widget.selectedColor ?? colorScheme.primary;
    final unselectedColor = widget.unselectedColor ?? colorScheme.onSurfaceVariant;

    final tabBar = TabBar(
      controller: _controller,
      tabs: widget.tabs.asMap().entries.map((entry) {
        return _buildTabWidget(entry.value, entry.key);
      }).toList(),
      isScrollable: widget.scrollable,
      labelPadding: _tabPadding,
      padding: EdgeInsets.zero,
      onTap: (index) {
        if (widget.tabs[index].disabled) {
          // Revert to previous index for disabled tabs
          if (_controller.index != _controller.previousIndex) {
            _controller.animateTo(_controller.previousIndex);
          }
          return;
        }
        _controller.animateTo(index);
        widget.onTabChanged?.call(index);
        HapticFeedback.selectionClick();
      },
      tabAlignment: _getTabAlignment(),
      dividerColor: Colors.transparent,
      indicator: _buildIndicator(),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: selectedColor,
      unselectedLabelColor: unselectedColor,
      overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.hovered)) {
          return selectedColor.withValues(alpha: 0.08);
        }
        return Colors.transparent;
      }),
    );

    // Apply variant-specific container styling
    switch (widget.variant) {
      case TabVariant.underline:
        return tabBar;
      case TabVariant.pill:
        return Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: tabBar,
        );
      case TabVariant.segmented:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
            color: widget.backgroundColor ?? colorScheme.surface,
          ),
          child: tabBar,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tabsWidget = _buildTabBar();

    // Add keyboard navigation
    tabsWidget = Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: tabsWidget,
    );

    // Add overall semantics
    tabsWidget = Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.semanticLabel ?? 'Tab navigation',
      child: tabsWidget,
    );

    return tabsWidget;
  }
}

/// A complete tabs component with content area
class TabsWithContent extends StatefulWidget {
  /// List of tab items
  final List<TabItem> tabs;

  /// List of content widgets for each tab
  final List<Widget> contents;

  /// Currently selected tab index
  final int selectedIndex;

  /// Callback when tab changes
  final ValueChanged<int>? onTabChanged;

  /// Tab variant style
  final TabVariant variant;

  /// Tab size
  final TabSize size;

  /// Whether tabs are scrollable
  final bool scrollable;

  /// Whether tabs are centered
  final bool centered;

  /// Whether tabs fill width
  final bool fullWidth;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom selected tab color
  final Color? selectedColor;

  /// Custom unselected tab color
  final Color? unselectedColor;

  /// Background color for the tabs
  final Color? backgroundColor;

  /// Animation duration
  final Duration animationDuration;

  /// Semantic label
  final String? semanticLabel;

  const TabsWithContent({
    super.key,
    required this.tabs,
    required this.contents,
    this.selectedIndex = 0,
    this.onTabChanged,
    this.variant = TabVariant.underline,
    this.size = TabSize.md,
    this.scrollable = false,
    this.centered = false,
    this.fullWidth = false,
    this.indicatorColor,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.semanticLabel,
  });

  @override
  State<TabsWithContent> createState() => _TabsWithContentState();
}

class _TabsWithContentState extends State<TabsWithContent>
    with TickerProviderStateMixin {
  late TabController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    assert(widget.tabs.length == widget.contents.length, 'tabs and contents must have the same length');

    _currentIndex = widget.selectedIndex;
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
  }

  @override
  void didUpdateWidget(covariant TabsWithContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _currentIndex = widget.selectedIndex;
      _controller.animateTo(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTabs(
          tabs: widget.tabs,
          selectedIndex: _currentIndex,
          onTabChanged: _handleTabChange,
          variant: widget.variant,
          size: widget.size,
          scrollable: widget.scrollable,
          centered: widget.centered,
          fullWidth: widget.fullWidth,
          indicatorColor: widget.indicatorColor,
          selectedColor: widget.selectedColor,
          unselectedColor: widget.unselectedColor,
          backgroundColor: widget.backgroundColor,
          animationDuration: widget.animationDuration,
          semanticLabel: widget.semanticLabel,
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.contents,
          ),
        ),
      ],
    );
  }
}