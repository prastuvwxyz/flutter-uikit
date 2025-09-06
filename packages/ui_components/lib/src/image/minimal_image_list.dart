import 'package:flutter/material.dart';
import '../image/minimal_image.dart';

/// MinimalImageList: Displays a responsive grid of images with consistent
/// aspect ratio, spacing and lazy loading behavior.
class MinimalImageList extends StatelessWidget {
  const MinimalImageList({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.aspectRatio = 1.0,
    this.spacing = 4.0,
    this.physics,
    this.shrinkWrap = false,
  });

  final List<Widget> children;
  final int crossAxisCount;
  final double aspectRatio;
  final double spacing;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    // Use GridView.builder to enable lazy building for performance
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        // Wrap children into AspectRatio to enforce consistent ratio when
        // children are plain images or widgets that do not size themselves.
        final child = children[index];
        return Semantics(
          container: true,
          child: ClipRect(
            child: AspectRatio(aspectRatio: aspectRatio, child: child),
          ),
        );
      },
    );
  }
}
