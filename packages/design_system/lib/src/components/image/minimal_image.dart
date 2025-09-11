import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// MinimalImage: lightweight image widget with loading, error, caching and
/// simple accessibility and interaction hooks.
class MinimalImage extends StatefulWidget {
  final String src;
  final String? alt;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showLoading;
  final bool showError;
  final bool cacheEnabled;
  final Duration? fadeInDuration;
  final VoidCallback? onLoad;
  final VoidCallback? onError;
  final VoidCallback? onTap;

  const MinimalImage({
    Key? key,
    required this.src,
    this.alt,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.showLoading = true,
    this.showError = true,
    this.cacheEnabled = true,
    this.fadeInDuration,
    this.onLoad,
    this.onError,
    this.onTap,
  }) : super(key: key);

  @override
  State<MinimalImage> createState() => _MinimalImageState();
}

class _MinimalImageState extends State<MinimalImage> {
  bool _loading = true;
  bool _error = false;

  ImageProvider _provider(String src) {
    if (src.startsWith('http://') || src.startsWith('https://')) {
      return NetworkImage(src);
    }
    return AssetImage(src);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(covariant MinimalImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src) {
      _loading = true;
      _error = false;
      _resolveImage();
    }
  }

  void _resolveImage() {
    final provider = _provider(widget.src);
    final resolver = provider.resolve(ImageConfiguration.empty);
    resolver.addListener(
      ImageStreamListener(
        (info, sync) {
          if (mounted) {
            setState(() {
              _loading = false;
              _error = false;
            });
            widget.onLoad?.call();
          }
        },
        onError: (dynamic _, __) {
          if (mounted) {
            setState(() {
              _loading = false;
              _error = true;
            });
            widget.onError?.call();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = Image(
      image: _provider(widget.src),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      alignment: widget.alignment,
      gaplessPlayback: true,
    );

    Widget child;

    if (_loading && widget.showLoading) {
      child =
          widget.placeholder ??
          Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
    } else if (_error && widget.showError) {
      child = widget.errorWidget ?? Center(child: Icon(Icons.broken_image));
    } else {
      final fade = widget.fadeInDuration != null
          ? AnimatedOpacity(
              opacity: _loading ? 0.0 : 1.0,
              duration: widget.fadeInDuration!,
              child: image,
            )
          : image;
      child = fade;
    }

    Widget clipped = ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Semantics(
        label: widget.alt,
        image: true,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: child,
          ),
        ),
      ),
    );

    return clipped;
  }
}
