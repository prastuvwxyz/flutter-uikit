import 'package:flutter/material.dart';

/// Direction of shimmer animation
enum ShimmerDirection {
  /// Left to right (default)
  ltr,
  /// Right to left
  rtl,
  /// Top to bottom
  ttb,
  /// Bottom to top
  btt,
}

/// Shape variants for skeleton loading indicators
enum SkeletonShape {
  /// Rectangular shape (default)
  rectangle,
  /// Circular shape
  circle,
  /// Rounded rectangle
  rounded,
}

/// Size variants for skeleton components
enum SkeletonSize {
  /// Small skeleton
  sm,
  /// Medium skeleton (default)
  md,
  /// Large skeleton
  lg,
  /// Extra large skeleton
  xl,
}

/// A flexible skeleton loading component with shimmer animation
class Skeleton extends StatefulWidget {
  /// Width of the skeleton (null for expanding to available width)
  final double? width;

  /// Height of the skeleton
  final double? height;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Whether the skeleton is currently loading
  final bool isLoading;

  /// Child to display when not loading
  final Widget? child;

  /// Whether animation is enabled
  final bool animate;

  /// Duration of the animation
  final Duration animationDuration;

  /// Base color of the skeleton
  final Color? baseColor;

  /// Highlight color for the shimmer effect
  final Color? highlightColor;

  /// Direction of the shimmer animation
  final ShimmerDirection direction;

  /// Shape of the skeleton
  final SkeletonShape shape;

  /// Size variant of the skeleton
  final SkeletonSize size;

  /// Number of lines for text skeletons
  final int lines;

  /// Spacing between lines
  final double lineSpacing;

  /// Semantic label for accessibility
  final String? semanticLabel;

  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.isLoading = true,
    this.child,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
    this.direction = ShimmerDirection.ltr,
    this.shape = SkeletonShape.rectangle,
    this.size = SkeletonSize.md,
    this.lines = 1,
    this.lineSpacing = 8.0,
    this.semanticLabel,
  });

  /// Factory for circular skeleton (avatar placeholder)
  factory Skeleton.circle({
    Key? key,
    double? size,
    bool isLoading = true,
    Widget? child,
    bool animate = true,
    Duration animationDuration = const Duration(milliseconds: 1500),
    Color? baseColor,
    Color? highlightColor,
    ShimmerDirection direction = ShimmerDirection.ltr,
    String? semanticLabel,
  }) {
    final avatarSize = size ?? 40.0;
    return Skeleton(
      key: key,
      width: avatarSize,
      height: avatarSize,
      isLoading: isLoading,
      child: child,
      animate: animate,
      animationDuration: animationDuration,
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: direction,
      shape: SkeletonShape.circle,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory for text skeleton with multiple lines
  factory Skeleton.text({
    Key? key,
    int lines = 3,
    double? width,
    double lineSpacing = 8.0,
    bool isLoading = true,
    Widget? child,
    bool animate = true,
    Duration animationDuration = const Duration(milliseconds: 1500),
    Color? baseColor,
    Color? highlightColor,
    ShimmerDirection direction = ShimmerDirection.ltr,
    SkeletonSize size = SkeletonSize.md,
    String? semanticLabel,
  }) {
    return Skeleton(
      key: key,
      width: width,
      isLoading: isLoading,
      child: child,
      animate: animate,
      animationDuration: animationDuration,
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: direction,
      shape: SkeletonShape.rounded,
      size: size,
      lines: lines,
      lineSpacing: lineSpacing,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory for card skeleton
  factory Skeleton.card({
    Key? key,
    double? width,
    double? height,
    bool isLoading = true,
    Widget? child,
    bool animate = true,
    Duration animationDuration = const Duration(milliseconds: 1500),
    Color? baseColor,
    Color? highlightColor,
    ShimmerDirection direction = ShimmerDirection.ltr,
    String? semanticLabel,
  }) {
    return Skeleton(
      key: key,
      width: width,
      height: height ?? 200.0,
      isLoading: isLoading,
      child: child,
      animate: animate,
      animationDuration: animationDuration,
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: direction,
      shape: SkeletonShape.rounded,
      semanticLabel: semanticLabel,
    );
  }

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.animate && widget.isLoading) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant Skeleton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationDuration != widget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }

    if (widget.animate && widget.isLoading) {
      if (!_animationController.isAnimating) {
        _animationController.repeat();
      }
    } else {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Get default dimensions based on size
  double get _defaultHeight {
    switch (widget.size) {
      case SkeletonSize.sm:
        return 12.0;
      case SkeletonSize.md:
        return 16.0;
      case SkeletonSize.lg:
        return 20.0;
      case SkeletonSize.xl:
        return 24.0;
    }
  }

  /// Get border radius based on shape and size
  BorderRadius? get _borderRadius {
    if (widget.borderRadius != null) return widget.borderRadius;

    switch (widget.shape) {
      case SkeletonShape.rectangle:
        return BorderRadius.zero;
      case SkeletonShape.circle:
        return null; // Handled by BoxDecoration shape
      case SkeletonShape.rounded:
        switch (widget.size) {
          case SkeletonSize.sm:
            return BorderRadius.circular(4.0);
          case SkeletonSize.md:
            return BorderRadius.circular(6.0);
          case SkeletonSize.lg:
            return BorderRadius.circular(8.0);
          case SkeletonSize.xl:
            return BorderRadius.circular(10.0);
        }
    }
  }

  /// Get alignment for shimmer animation start
  Alignment _getBeginAlignment() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return const Alignment(-1.0, 0.0);
      case ShimmerDirection.rtl:
        return const Alignment(1.0, 0.0);
      case ShimmerDirection.ttb:
        return const Alignment(0.0, -1.0);
      case ShimmerDirection.btt:
        return const Alignment(0.0, 1.0);
    }
  }

  /// Get alignment for shimmer animation end
  Alignment _getEndAlignment() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return const Alignment(1.0, 0.0);
      case ShimmerDirection.rtl:
        return const Alignment(-1.0, 0.0);
      case ShimmerDirection.ttb:
        return const Alignment(0.0, 1.0);
      case ShimmerDirection.btt:
        return const Alignment(0.0, -1.0);
    }
  }

  /// Build shimmer effect
  Widget _buildShimmer({required Widget child}) {
    if (!widget.animate || !widget.isLoading) return child;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final colorScheme = Theme.of(context).colorScheme;
        final baseColor = widget.baseColor ??
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.8);
        final highlightColor = widget.highlightColor ??
            colorScheme.surface.withValues(alpha: 0.9);

        final t = _animation.value;

        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: _getBeginAlignment(),
              end: _getEndAlignment(),
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (t - 0.3).clamp(0.0, 1.0),
                t.clamp(0.0, 1.0),
                (t + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Build single skeleton item
  Widget _buildSkeletonItem({
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = widget.baseColor ??
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.8);

    final effectiveHeight = height ?? _defaultHeight;

    return Container(
      width: width,
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: widget.shape == SkeletonShape.circle
            ? null
            : borderRadius ?? _borderRadius,
        shape: widget.shape == SkeletonShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
      ),
    );
  }

  /// Build text skeleton with multiple lines
  Widget _buildTextSkeleton() {
    if (widget.lines == 1) {
      return _buildSkeletonItem(
        width: widget.width,
        height: widget.height,
        borderRadius: _borderRadius,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.lines, (index) {
        final isLastLine = index == widget.lines - 1;
        final lineWidth = isLastLine && widget.width == null
            ? null  // Let last line be shorter naturally
            : widget.width;

        return Column(
          children: [
            _buildSkeletonItem(
              width: lineWidth,
              height: widget.height ?? _defaultHeight,
              borderRadius: _borderRadius,
            ),
            if (!isLastLine) SizedBox(height: widget.lineSpacing),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return child if not loading
    if (!widget.isLoading) {
      return widget.child ?? const SizedBox.shrink();
    }

    Widget skeleton;

    // Build skeleton based on lines
    if (widget.lines > 1 && widget.shape != SkeletonShape.circle) {
      skeleton = _buildTextSkeleton();
    } else {
      skeleton = _buildSkeletonItem(
        width: widget.width,
        height: widget.height,
        borderRadius: _borderRadius,
      );
    }

    // Apply shimmer effect
    skeleton = _buildShimmer(child: skeleton);

    // Add semantics
    return Semantics(
      container: true,
      label: widget.semanticLabel ?? 'Loading content',
      liveRegion: widget.isLoading,
      child: ExcludeSemantics(
        child: skeleton,
      ),
    );
  }
}

/// Utilities for creating common skeleton patterns
class SkeletonUtils {
  /// Create a list item skeleton
  static Widget listItem({
    Key? key,
    bool hasAvatar = true,
    int titleLines = 1,
    int subtitleLines = 2,
    bool isLoading = true,
    Widget? child,
    bool animate = true,
    Duration animationDuration = const Duration(milliseconds: 1500),
    Color? baseColor,
    Color? highlightColor,
    ShimmerDirection direction = ShimmerDirection.ltr,
  }) {
    if (!isLoading && child != null) return child;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (hasAvatar) ...[
            Skeleton.circle(
              size: 40,
              isLoading: isLoading,
              animate: animate,
              animationDuration: animationDuration,
              baseColor: baseColor,
              highlightColor: highlightColor,
              direction: direction,
            ),
            const SizedBox(width: 16.0),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton.text(
                  lines: titleLines,
                  width: hasAvatar ? null : double.infinity,
                  size: SkeletonSize.md,
                  isLoading: isLoading,
                  animate: animate,
                  animationDuration: animationDuration,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  direction: direction,
                ),
                if (subtitleLines > 0) ...[
                  const SizedBox(height: 8.0),
                  Skeleton.text(
                    lines: subtitleLines,
                    width: hasAvatar ? null : double.infinity * 0.7,
                    size: SkeletonSize.sm,
                    isLoading: isLoading,
                    animate: animate,
                    animationDuration: animationDuration,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    direction: direction,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Create a card skeleton
  static Widget card({
    Key? key,
    double? width,
    double? height,
    bool hasImage = true,
    int titleLines = 1,
    int contentLines = 3,
    bool isLoading = true,
    Widget? child,
    bool animate = true,
    Duration animationDuration = const Duration(milliseconds: 1500),
    Color? baseColor,
    Color? highlightColor,
    ShimmerDirection direction = ShimmerDirection.ltr,
  }) {
    if (!isLoading && child != null) return child;

    return Builder(
      builder: (context) => Container(
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          if (hasImage)
            Skeleton.card(
              width: double.infinity,
              height: height != null ? height * 0.6 : 120,
              isLoading: isLoading,
              animate: animate,
              animationDuration: animationDuration,
              baseColor: baseColor,
              highlightColor: highlightColor,
              direction: direction,
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton.text(
                  lines: titleLines,
                  size: SkeletonSize.lg,
                  width: double.infinity * 0.7,
                  isLoading: isLoading,
                  animate: animate,
                  animationDuration: animationDuration,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  direction: direction,
                ),
                const SizedBox(height: 8.0),
                Skeleton.text(
                  lines: contentLines,
                  size: SkeletonSize.sm,
                  width: double.infinity,
                  isLoading: isLoading,
                  animate: animate,
                  animationDuration: animationDuration,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  direction: direction,
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}