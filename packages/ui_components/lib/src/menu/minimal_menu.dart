import 'package:flutter/material.dart' hide MenuController, MenuStyle;

import 'menu_controller.dart';
import 'menu_style.dart';

/// A minimal, accessible menu widget supporting keyboard navigation,
/// basic styling via [MenuStyle], and an external [MenuController].
class MinimalMenu extends StatefulWidget {
  final List<Widget> children;
  final MenuController? menuController;
  final MenuStyle? style;
  final Clip clipBehavior;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final Widget Function(BuildContext, MenuController, Widget?)?
  anchorChildBuilder;
  final Offset alignmentOffset;

  const MinimalMenu({
    super.key,
    required this.children,
    this.menuController,
    this.style,
    this.clipBehavior = Clip.none,
    this.onOpen,
    this.onClose,
    this.anchorChildBuilder,
    this.alignmentOffset = Offset.zero,
  });

  @override
  State<MinimalMenu> createState() => _MinimalMenuState();
}

class _MinimalMenuState extends State<MinimalMenu> with WidgetsBindingObserver {
  late MenuController _controller;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = widget.menuController ?? MenuController();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant MinimalMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.menuController != widget.menuController &&
        widget.menuController != null) {
      _controller.removeListener(_onControllerChanged);
      _controller.dispose();
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
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _controller.close(),
          child: Stack(
            children: [
              Positioned(
                left: widget.alignmentOffset.dx,
                top: widget.alignmentOffset.dy,
                child: Material(
                  elevation: widget.style?.elevation ?? 4.0,
                  color:
                      widget.style?.backgroundColor ??
                      Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      widget.style?.radius ?? 6.0,
                    ),
                    side: BorderSide(
                      color: widget.style?.outlineColor ?? Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 160, maxWidth: 320),
                    child: ClipRect(
                      clipBehavior: widget.clipBehavior,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        shrinkWrap: true,
                        children: widget.children,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    final anchor =
        widget.anchorChildBuilder?.call(context, _controller, null) ??
        ElevatedButton(
          onPressed: () => _controller.toggle(),
          child: const Text('Open'),
        );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Menu',
      child: FocusScope(
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {}, // keep anchor responsive
              child: anchor,
            );
          },
        ),
      ),
    );
  }
}
