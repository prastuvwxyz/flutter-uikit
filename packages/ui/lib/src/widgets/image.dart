import 'package:flutter/material.dart';

class CustomImage extends StatefulWidget {
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
  final Color? backgroundColor;
  final BoxBorder? border;

  const CustomImage({
    super.key,
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
    this.backgroundColor,
    this.border,
  });

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  bool _loading = true;
  bool _error = false;
  ImageStreamListener? _listener;

  ImageProvider _getProvider(String src) {
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
  void didUpdateWidget(covariant CustomImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src) {
      setState(() {
        _loading = true;
        _error = false;
      });
      _resolveImage();
    }
  }

  void _resolveImage() {
    final provider = _getProvider(widget.src);
    final resolver = provider.resolve(createLocalImageConfiguration(context));

    _listener = ImageStreamListener(
      (info, sync) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = false;
          });
          widget.onLoad?.call();
        }
      },
      onError: (exception, stackTrace) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = true;
          });
          widget.onError?.call();
        }
      },
    );

    resolver.addListener(_listener!);
  }

  @override
  void dispose() {
    if (_listener != null) {
      final provider = _getProvider(widget.src);
      final resolver = provider.resolve(createLocalImageConfiguration(context));
      resolver.removeListener(_listener!);
    }
    super.dispose();
  }

  Widget _buildPlaceholder() {
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 32,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 8),
            Text(
              'Image failed to load',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final image = Image(
      image: _getProvider(widget.src),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      alignment: widget.alignment,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return _buildPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildError();
      },
    );

    if (widget.fadeInDuration != null && !_loading) {
      return AnimatedOpacity(
        opacity: _loading ? 0.0 : 1.0,
        duration: widget.fadeInDuration!,
        child: image,
      );
    }

    return image;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_loading && widget.showLoading) {
      child = _buildPlaceholder();
    } else if (_error && widget.showError) {
      child = _buildError();
    } else {
      child = _buildImage();
    }

    // Apply container with styling
    child = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        border: widget.border,
      ),
      clipBehavior: widget.borderRadius != null ? Clip.antiAlias : Clip.none,
      child: child,
    );

    // Add semantics
    child = Semantics(
      label: widget.alt,
      image: true,
      child: child,
    );

    // Add tap handling
    if (widget.onTap != null) {
      child = GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: child,
      );
    }

    return child;
  }
}