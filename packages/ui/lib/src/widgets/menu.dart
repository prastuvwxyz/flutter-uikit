import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuController extends ChangeNotifier {
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void open() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  void close() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  void toggle() {
    _isOpen ? close() : open();
  }
}

class MenuStyle {
  final double? elevation;
  final Color? backgroundColor;
  final Color? outlineColor;
  final double? radius;
  final EdgeInsets? padding;
  final double? maxWidth;
  final double? minWidth;

  const MenuStyle({
    this.elevation,
    this.backgroundColor,
    this.outlineColor,
    this.radius,
    this.padding,
    this.maxWidth,
    this.minWidth,
  });
}

class Menu extends StatefulWidget {
  final List<Widget> children;
  final MenuController? menuController;
  final MenuStyle? style;
  final Clip clipBehavior;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final Widget Function(BuildContext, MenuController)? anchorBuilder;
  final Widget? anchor;
  final Offset alignmentOffset;
  final bool closeOnTapOutside;

  const Menu({
    super.key,
    required this.children,
    this.menuController,
    this.style,
    this.clipBehavior = Clip.none,
    this.onOpen,
    this.onClose,
    this.anchorBuilder,
    this.anchor,
    this.alignmentOffset = Offset.zero,
    this.closeOnTapOutside = true,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with WidgetsBindingObserver {
  late MenuController _controller;
  OverlayEntry? _overlayEntry;
  GlobalKey _anchorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = widget.menuController ?? MenuController();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant Menu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.menuController != widget.menuController &&
        widget.menuController != null) {
      _controller.removeListener(_onControllerChanged);
      if (widget.menuController == null) _controller.dispose();
      _controller = widget.menuController!;
      _controller.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() {
    if (_controller.isOpen && _overlayEntry == null) {
      _showOverlay();
      widget.onOpen?.call();
    } else if (!_controller.isOpen && _overlayEntry != null) {
      _removeOverlay();
      widget.onClose?.call();
    }
    setState(() {});
  }

  void _showOverlay() {
    final renderBox = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _MenuOverlay(
          anchorOffset: offset,
          anchorSize: size,
          alignmentOffset: widget.alignmentOffset,
          style: widget.style,
          clipBehavior: widget.clipBehavior,
          closeOnTapOutside: widget.closeOnTapOutside,
          onClose: () => _controller.close(),
          children: widget.children,
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onControllerChanged);
    if (widget.menuController == null) _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget anchorWidget;

    if (widget.anchorBuilder != null) {
      anchorWidget = widget.anchorBuilder!(context, _controller);
    } else if (widget.anchor != null) {
      anchorWidget = widget.anchor!;
    } else {
      anchorWidget = ElevatedButton(
        onPressed: () => _controller.toggle(),
        child: const Text('Menu'),
      );
    }

    return Container(
      key: _anchorKey,
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: 'Menu',
        child: anchorWidget,
      ),
    );
  }
}

class _MenuOverlay extends StatefulWidget {
  final Offset anchorOffset;
  final Size anchorSize;
  final Offset alignmentOffset;
  final MenuStyle? style;
  final Clip clipBehavior;
  final bool closeOnTapOutside;
  final VoidCallback onClose;
  final List<Widget> children;

  const _MenuOverlay({
    required this.anchorOffset,
    required this.anchorSize,
    required this.alignmentOffset,
    required this.style,
    required this.clipBehavior,
    required this.closeOnTapOutside,
    required this.onClose,
    required this.children,
  });

  @override
  State<_MenuOverlay> createState() => _MenuOverlayState();
}

class _MenuOverlayState extends State<_MenuOverlay> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style ?? MenuStyle();

    // Calculate position
    final left = widget.anchorOffset.dx + widget.alignmentOffset.dx;
    final top = widget.anchorOffset.dy + widget.anchorSize.height + widget.alignmentOffset.dy;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.closeOnTapOutside ? widget.onClose : null,
      child: Stack(
        children: [
          Positioned(
            left: left,
            top: top,
            child: Focus(
              autofocus: true,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.escape) {
                  widget.onClose();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Material(
                elevation: style.elevation ?? 4.0,
                color: style.backgroundColor ?? theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(style.radius ?? 8.0),
                  side: BorderSide(
                    color: style.outlineColor ?? theme.colorScheme.outline,
                    width: 1.0,
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: style.minWidth ?? 160,
                    maxWidth: style.maxWidth ?? 320,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(style.radius ?? 8.0),
                    clipBehavior: widget.clipBehavior,
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: widget.children,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final bool selected;

  const MenuItem({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: selected
          ? colorScheme.primary.withValues(alpha: 0.12)
          : null,
        child: Row(
          children: [
            if (leading != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: enabled
                    ? (selected ? colorScheme.primary : colorScheme.onSurfaceVariant)
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                  size: 20,
                ),
                child: leading!,
              ),
              SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    DefaultTextStyle(
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: enabled
                          ? (selected ? colorScheme.primary : colorScheme.onSurface)
                          : colorScheme.onSurface.withValues(alpha: 0.38),
                      ),
                      child: title!,
                    ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2),
                    DefaultTextStyle(
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: enabled
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                      ),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: 12),
              IconTheme(
                data: IconThemeData(
                  color: enabled
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                  size: 16,
                ),
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MenuDivider extends StatelessWidget {
  final double? height;
  final EdgeInsets? margin;

  const MenuDivider({
    super.key,
    this.height,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1,
      margin: margin ?? EdgeInsets.symmetric(vertical: 4),
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
    );
  }
}