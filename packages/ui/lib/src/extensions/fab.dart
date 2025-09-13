import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Extended Floating Action Button with additional functionality and styling options
class ExtendedFAB extends StatefulWidget {
  /// The icon to display in the FAB
  final IconData? icon;

  /// The text label to display (for extended FAB)
  final String? label;

  /// Callback when the FAB is pressed
  final VoidCallback? onPressed;

  /// FAB size variant
  final FABSize size;

  /// FAB type (regular, extended, mini)
  final FABType type;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom foreground color (icon/text color)
  final Color? foregroundColor;

  /// Elevation of the FAB
  final double? elevation;

  /// Elevation when pressed
  final double? highlightElevation;

  /// Shape of the FAB
  final ShapeBorder? shape;

  /// Whether the FAB is enabled
  final bool enabled;

  /// Tooltip message
  final String? tooltip;

  /// Hero tag for navigation
  final Object? heroTag;

  /// Custom child widget (overrides icon and label)
  final Widget? child;

  /// Animation duration for state changes
  final Duration animationDuration;

  /// Whether to show the label (for extended FAB)
  final bool showLabel;

  /// Auto-hide functionality
  final bool autoHide;

  /// Scroll controller for auto-hide
  final ScrollController? scrollController;

  /// Custom margin
  final EdgeInsets? margin;

  const ExtendedFAB({
    super.key,
    this.icon,
    this.label,
    this.onPressed,
    this.size = FABSize.regular,
    this.type = FABType.regular,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.highlightElevation,
    this.shape,
    this.enabled = true,
    this.tooltip,
    this.heroTag,
    this.child,
    this.animationDuration = const Duration(milliseconds: 200),
    this.showLabel = true,
    this.autoHide = false,
    this.scrollController,
    this.margin,
  });

  @override
  State<ExtendedFAB> createState() => _ExtendedFABState();
}

class _ExtendedFABState extends State<ExtendedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    if (widget.autoHide && widget.scrollController != null) {
      widget.scrollController!.addListener(_handleScroll);
    }
  }

  @override
  void didUpdateWidget(ExtendedFAB oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.autoHide != widget.autoHide ||
        oldWidget.scrollController != widget.scrollController) {
      if (oldWidget.scrollController != null) {
        oldWidget.scrollController!.removeListener(_handleScroll);
      }
      if (widget.autoHide && widget.scrollController != null) {
        widget.scrollController!.addListener(_handleScroll);
      }
    }
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_handleScroll);
    }
    _animationController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!widget.autoHide) return;

    final controller = widget.scrollController!;
    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() => _isVisible = false);
        _animationController.reverse();
      }
    } else if (controller.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() => _isVisible = true);
        _animationController.forward();
      }
    }
  }

  double _getSize() {
    switch (widget.size) {
      case FABSize.small:
        return 40.0;
      case FABSize.regular:
        return 56.0;
      case FABSize.large:
        return 72.0;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case FABSize.small:
        return 20.0;
      case FABSize.regular:
        return 24.0;
      case FABSize.large:
        return 32.0;
    }
  }

  Widget _buildRegularFAB() {
    return FloatingActionButton(
      onPressed: widget.enabled ? widget.onPressed : null,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      elevation: widget.elevation,
      highlightElevation: widget.highlightElevation,
      shape: widget.shape,
      tooltip: widget.tooltip,
      heroTag: widget.heroTag,
      mini: widget.type == FABType.mini,
      child: widget.child ?? (widget.icon != null
        ? Icon(widget.icon!, size: _getIconSize())
        : null),
    );
  }

  Widget _buildExtendedFAB() {
    return FloatingActionButton.extended(
      onPressed: widget.enabled ? widget.onPressed : null,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      elevation: widget.elevation,
      highlightElevation: widget.highlightElevation,
      shape: widget.shape,
      tooltip: widget.tooltip,
      heroTag: widget.heroTag,
      icon: widget.icon != null ? Icon(widget.icon!, size: _getIconSize()) : null,
      label: widget.showLabel && widget.label != null
        ? Text(widget.label!)
        : const SizedBox.shrink(),
    );
  }

  Widget _buildCustomFAB() {
    final theme = Theme.of(context);

    return Material(
      elevation: widget.elevation ?? 6.0,
      color: widget.backgroundColor ?? theme.colorScheme.primary,
      shape: widget.shape ?? const CircleBorder(),
      child: InkWell(
        onTap: widget.enabled ? widget.onPressed : null,
        customBorder: widget.shape ?? const CircleBorder(),
        child: Container(
          width: _getSize(),
          height: _getSize(),
          alignment: Alignment.center,
          child: widget.child ?? (widget.icon != null
            ? Icon(
                widget.icon!,
                size: _getIconSize(),
                color: widget.foregroundColor ?? theme.colorScheme.onPrimary,
              )
            : null),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget fab;

    switch (widget.type) {
      case FABType.regular:
        fab = _buildRegularFAB();
        break;
      case FABType.extended:
        fab = _buildExtendedFAB();
        break;
      case FABType.mini:
        fab = _buildRegularFAB();
        break;
      case FABType.custom:
        fab = _buildCustomFAB();
        break;
    }

    if (widget.margin != null) {
      fab = Padding(
        padding: widget.margin!,
        child: fab,
      );
    }

    if (widget.autoHide) {
      fab = AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: fab,
          );
        },
      );
    }

    return fab;
  }
}

/// Enumeration for FAB sizes
enum FABSize {
  small,
  regular,
  large,
}

/// Enumeration for FAB types
enum FABType {
  regular,
  extended,
  mini,
  custom,
}

/// Speed dial FAB with multiple action buttons
class SpeedDialFAB extends StatefulWidget {
  /// The main FAB icon
  final IconData icon;

  /// List of speed dial options
  final List<SpeedDialOption> options;

  /// Background color of the main FAB
  final Color? backgroundColor;

  /// Foreground color of the main FAB
  final Color? foregroundColor;

  /// Shape of the main FAB
  final ShapeBorder? shape;

  /// Direction to expand the speed dial
  final SpeedDialDirection direction;

  /// Spacing between options
  final double spacing;

  /// Animation duration
  final Duration animationDuration;

  /// Overlay color when expanded
  final Color? overlayColor;

  /// Whether to close on option tap
  final bool closeOnOptionTap;

  /// Tooltip for the main FAB
  final String? tooltip;

  /// Hero tag
  final Object? heroTag;

  const SpeedDialFAB({
    super.key,
    required this.icon,
    required this.options,
    this.backgroundColor,
    this.foregroundColor,
    this.shape,
    this.direction = SpeedDialDirection.up,
    this.spacing = 16.0,
    this.animationDuration = const Duration(milliseconds: 250),
    this.overlayColor,
    this.closeOnOptionTap = true,
    this.tooltip,
    this.heroTag,
  });

  @override
  State<SpeedDialFAB> createState() => _SpeedDialFABState();
}

class _SpeedDialFABState extends State<SpeedDialFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _close() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _animationController.reverse();
      });
    }
  }

  Widget _buildOption(SpeedDialOption option, int index) {
    final delay = index * 0.1;
    final animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(delay, 1.0, curve: Curves.elasticOut),
    ));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: widget.spacing),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (option.label != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      option.label!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
                FloatingActionButton(
                  mini: true,
                  heroTag: 'speed_dial_${option.hashCode}',
                  backgroundColor: option.backgroundColor,
                  foregroundColor: option.foregroundColor,
                  onPressed: () {
                    if (widget.closeOnOptionTap) {
                      _close();
                    }
                    option.onPressed();
                  },
                  child: Icon(option.icon),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Overlay
        if (_isExpanded)
          GestureDetector(
            onTap: _close,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: widget.overlayColor ?? Colors.black26,
            ),
          ),

        // Options
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = widget.options.length - 1; i >= 0; i--)
              _buildOption(widget.options[i], widget.options.length - 1 - i),
          ],
        ),

        // Main FAB
        AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: FloatingActionButton(
                onPressed: _toggle,
                backgroundColor: widget.backgroundColor,
                foregroundColor: widget.foregroundColor,
                shape: widget.shape,
                tooltip: widget.tooltip,
                heroTag: widget.heroTag,
                child: Icon(widget.icon),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Direction for speed dial expansion
enum SpeedDialDirection {
  up,
  down,
  left,
  right,
}

/// Option for speed dial FAB
class SpeedDialOption {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SpeedDialOption({
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });
}

/// Morphing FAB that can transform between states
class MorphingFAB extends StatefulWidget {
  /// List of FAB states
  final List<FABState> states;

  /// Current state index
  final int currentStateIndex;

  /// Animation duration for morphing
  final Duration morphDuration;

  /// Custom shape for morphing
  final ShapeBorder? shape;

  const MorphingFAB({
    super.key,
    required this.states,
    this.currentStateIndex = 0,
    this.morphDuration = const Duration(milliseconds: 300),
    this.shape,
  });

  @override
  State<MorphingFAB> createState() => _MorphingFABState();
}

class _MorphingFABState extends State<MorphingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentStateIndex;
    _animationController = AnimationController(
      duration: widget.morphDuration,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(MorphingFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStateIndex != widget.currentStateIndex) {
      _morphToState(widget.currentStateIndex);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _morphToState(int newIndex) {
    if (newIndex >= 0 && newIndex < widget.states.length && newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentState = widget.states[_currentIndex];

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FloatingActionButton(
          onPressed: currentState.onPressed,
          backgroundColor: currentState.backgroundColor,
          foregroundColor: currentState.foregroundColor,
          shape: widget.shape,
          tooltip: currentState.tooltip,
          heroTag: currentState.heroTag,
          child: AnimatedSwitcher(
            duration: widget.morphDuration,
            child: Icon(
              currentState.icon,
              key: ValueKey(currentState.icon),
            ),
          ),
        );
      },
    );
  }
}

/// State configuration for morphing FAB
class FABState {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final Object? heroTag;

  const FABState({
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.heroTag,
  });
}

/// Extension for easy FAB creation
extension FABExtensions on Widget {
  /// Wrap with a positioned FAB
  Widget withFAB({
    required VoidCallback onPressed,
    IconData icon = Icons.add,
    String? label,
    FABType type = FABType.regular,
    Alignment alignment = Alignment.bottomRight,
    EdgeInsets margin = const EdgeInsets.all(16.0),
  }) {
    return Stack(
      children: [
        this,
        Positioned.fill(
          child: Align(
            alignment: alignment,
            child: Padding(
              padding: margin,
              child: ExtendedFAB(
                icon: icon,
                label: label,
                onPressed: onPressed,
                type: type,
              ),
            ),
          ),
        ),
      ],
    );
  }
}