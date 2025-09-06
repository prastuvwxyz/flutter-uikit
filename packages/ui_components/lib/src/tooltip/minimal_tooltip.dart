import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tooltip_enums.dart';
import 'tooltip_overlay.dart';

class MinimalTooltip extends StatefulWidget {
  final String? message;
  final Widget? child;
  final TooltipPosition position;
  final TooltipVariant variant;
  final Duration showDelay;
  final Duration hideDelay;
  final double? maxWidth;
  final EdgeInsets? padding;
  final bool rich;
  final Widget? content;

  const MinimalTooltip({
    Key? key,
    this.message,
    this.child,
    this.position = TooltipPosition.auto,
    this.variant = TooltipVariant.dark,
    this.showDelay = const Duration(milliseconds: 500),
    this.hideDelay = const Duration(milliseconds: 100),
    this.maxWidth = 200.0,
    this.padding,
    this.rich = false,
    this.content,
  }) : super(key: key);

  @override
  State<MinimalTooltip> createState() => _MinimalTooltipState();
}

class _MinimalTooltipState extends State<MinimalTooltip> {
  OverlayEntry? _entry;
  Timer? _showTimer;
  Timer? _hideTimer;

  void _show() {
    _hideTimer?.cancel();
    if (_entry != null) return;
    _showTimer = Timer(widget.showDelay, () {
      final renderBox = context.findRenderObject() as RenderBox?;
      final overlay = Overlay.of(context);
      final target = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
      final size = renderBox?.size ?? Size.zero;

      _entry = OverlayEntry(
        builder: (ctx) {
          return Positioned(
            left: target.dx,
            top: target.dy + size.height + 8,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(maxWidth: widget.maxWidth ?? 200),
                padding: widget.padding ?? EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.variant == TooltipVariant.light
                      ? Colors.white
                      : Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: widget.variant == TooltipVariant.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 12,
                  ),
                  child: widget.content ?? Text(widget.message ?? ''),
                ),
              ),
            ),
          );
        },
      );

      overlay.insert(_entry!);
    });
  }

  void _hide() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.hideDelay, () {
      _entry?.remove();
      _entry = null;
    });
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _entry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<Intent>(
          onInvoke: (_) {
            _hide();
            return null;
          },
        ),
      },
      child: MouseRegion(
        onEnter: (_) => _show(),
        onExit: (_) => _hide(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {},
          child: widget.child ?? SizedBox.shrink(),
        ),
      ),
    );
  }
}
