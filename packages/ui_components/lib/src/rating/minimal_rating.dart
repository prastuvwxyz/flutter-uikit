import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

typedef RatingItemBuilder = Widget Function(BuildContext context, int index);

class MinimalRating extends StatefulWidget {
  const MinimalRating({
    super.key,
    this.value = 0.0,
    this.onChanged,
    this.maxRating = 5,
    this.size = 24.0,
    this.color,
    this.unratedColor,
    this.allowHalfRating = false,
    this.itemBuilder,
    this.itemCount,
    this.itemPadding = EdgeInsets.zero,
    this.direction = Axis.horizontal,
    this.showLabel = false,
    this.labelBuilder,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final int maxRating;
  final double size;
  final Color? color;
  final Color? unratedColor;
  final bool allowHalfRating;
  final RatingItemBuilder? itemBuilder;
  final int? itemCount;
  final EdgeInsets itemPadding;
  final Axis direction;
  final bool showLabel;
  final String Function(double)? labelBuilder;

  @override
  State<MinimalRating> createState() => _MinimalRatingState();
}

class _MinimalRatingState extends State<MinimalRating> {
  // hover value not currently used; keep implementation minimal for now

  int get _count => widget.itemCount ?? widget.maxRating;

  bool get _isInteractive => widget.onChanged != null;

  void _setValueFromTap(Offset localPosition, RenderBox box) {
    final size = box.size;
    final totalWidth = widget.direction == Axis.horizontal
        ? size.width
        : size.height;
    final single = totalWidth / _count;
    var pos = widget.direction == Axis.horizontal
        ? localPosition.dx
        : localPosition.dy;
    pos = pos.clamp(0.0, totalWidth);
    double raw = (pos / single);
    double newRating = raw + 1.0; // 0-based to 1-based
    if (widget.allowHalfRating) {
      final frac = raw - raw.floor();
      newRating = raw.floorToDouble() + (frac >= 0.5 ? 1.0 : 0.5);
    } else {
      newRating = raw.floorToDouble() + 1.0;
    }
    newRating = newRating.clamp(0.0, widget.maxRating.toDouble());
    widget.onChanged?.call(newRating);
  }

  Widget _buildItem(BuildContext context, int index) {
    final activeColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final inactiveColor =
        widget.unratedColor ??
        Theme.of(context).colorScheme.onSurface.withOpacity(0.3);

    final curr = widget.value;
    final position = index + 1;
    Widget child;

    if (widget.itemBuilder != null) {
      child = widget.itemBuilder!(context, index);
    } else {
      if (widget.allowHalfRating &&
          (curr + 0.0001) >= (position - 0.5) &&
          curr < position) {
        // render half star using Stack with clipped icon
        child = Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.star_border, size: widget.size, color: inactiveColor),
            ClipRect(
              clipper: _HalfClipper(),
              child: Icon(Icons.star, size: widget.size, color: activeColor),
            ),
          ],
        );
      } else if (curr >= position) {
        child = Icon(Icons.star, size: widget.size, color: activeColor);
      } else {
        child = Icon(
          Icons.star_border,
          size: widget.size,
          color: inactiveColor,
        );
      }
    }

    return Padding(padding: widget.itemPadding, child: child);
  }

  void _onKey(RawKeyEvent event) {
    if (!_isInteractive) return;
    if (event is! RawKeyDownEvent) return;
    final key = event.logicalKey;
    double value = widget.value;
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowUp) {
      value += widget.allowHalfRating ? 0.5 : 1.0;
      value = value.clamp(0.0, widget.maxRating.toDouble());
      widget.onChanged?.call(value);
    } else if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowDown) {
      value -= widget.allowHalfRating ? 0.5 : 1.0;
      value = value.clamp(0.0, widget.maxRating.toDouble());
      widget.onChanged?.call(value);
    } else if (key == LogicalKeyboardKey.home) {
      widget.onChanged?.call(0.0);
    } else if (key == LogicalKeyboardKey.end) {
      widget.onChanged?.call(widget.maxRating.toDouble());
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.space) {
      // noop — selection handled on tap
    }
  }

  @override
  Widget build(BuildContext context) {
    final row = widget.direction == Axis.horizontal;
    final list = List.generate(_count, (i) => _buildItem(context, i));

    Widget result = Focus(
      canRequestFocus: _isInteractive,
      child: Semantics(
        label: 'Rating',
        value: '${widget.value}',
        readOnly: !_isInteractive,
        textDirection: Directionality.of(context),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: _onKey,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: !_isInteractive
                ? null
                : (details) {
                    final box = context.findRenderObject() as RenderBox;
                    _setValueFromTap(details.localPosition, box);
                  },
            child: row
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: Directionality.of(context),
                    children: list,
                  )
                : Column(mainAxisSize: MainAxisSize.min, children: list),
          ),
        ),
      ),
    );

    if (widget.showLabel) {
      final label =
          widget.labelBuilder?.call(widget.value) ?? widget.value.toString();
      result = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          result,
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
    }

    return result;
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
