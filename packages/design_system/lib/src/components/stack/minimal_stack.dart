import 'package:flutter/material.dart';

/// A minimal, token-friendly Stack replacement with optional spacing between
/// non-positioned children and small API sugar for common Stack props.
class MinimalStack extends StatelessWidget {
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit fit;
  final Clip clipBehavior;
  final double? spacing;

  const MinimalStack({
    Key? key,
    this.children = const <Widget>[],
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If spacing is not provided, just return a normal Stack
    if (spacing == null || children.isEmpty) {
      return Stack(
        alignment: alignment,
        textDirection: textDirection,
        fit: fit,
        clipBehavior: clipBehavior,
        children: children,
      );
    }
    // Wrap non-positioned children with padding to provide spacing between
    // layer content. This keeps Positioned children untouched.
    final spaced = children
        .map<Widget>((w) {
          if (w is Positioned) return w;
          return Padding(padding: EdgeInsets.all(spacing! / 2), child: w);
        })
        .toList(growable: false);

    return Stack(
      alignment: alignment,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
      children: spaced,
    );
  }
}
