import 'package:flutter/material.dart';

/// A media gallery widget for displaying images and videos with zoom, pagination, and grid view
class MediaGallery extends StatefulWidget {
  /// List of media items to display
  final List<MediaItem> items;

  /// Initial index to display
  final int initialIndex;

  /// Callback when a media item is selected
  final Function(MediaItem item, int index)? onItemSelected;

  /// Whether to show thumbnails
  final bool showThumbnails;

  /// Gallery view mode (fullscreen, grid, carousel)
  final MediaGalleryMode mode;

  /// Whether to allow zoom in fullscreen mode
  final bool allowZoom;

  /// Whether to show item counter
  final bool showCounter;

  /// Whether to show share button
  final bool showShareButton;

  /// Whether to show download button
  final bool showDownloadButton;

  /// Whether to show delete button
  final bool showDeleteButton;

  /// Custom app bar builder for fullscreen mode
  final PreferredSizeWidget Function(MediaItem item, int index)? appBarBuilder;

  /// Custom thumbnail builder
  final Widget Function(MediaItem item, int index)? thumbnailBuilder;

  /// Grid settings for grid mode
  final MediaGridSettings? gridSettings;

  /// Callback when item is shared
  final Function(MediaItem item)? onShare;

  /// Callback when item is downloaded
  final Function(MediaItem item)? onDownload;

  /// Callback when item is deleted
  final Function(MediaItem item)? onDelete;

  /// Background color for fullscreen mode
  final Color? backgroundColor;

  /// Loading widget
  final Widget? loadingWidget;

  /// Error widget
  final Widget Function(Object error)? errorBuilder;

  const MediaGallery({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.onItemSelected,
    this.showThumbnails = true,
    this.mode = MediaGalleryMode.fullscreen,
    this.allowZoom = true,
    this.showCounter = true,
    this.showShareButton = false,
    this.showDownloadButton = false,
    this.showDeleteButton = false,
    this.appBarBuilder,
    this.thumbnailBuilder,
    this.gridSettings,
    this.onShare,
    this.onDownload,
    this.onDelete,
    this.backgroundColor,
    this.loadingWidget,
    this.errorBuilder,
  });

  @override
  State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _thumbnailAnimationController;
  late Animation<double> _thumbnailAnimation;
  int _currentIndex = 0;
  bool _showThumbnails = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _showThumbnails = widget.showThumbnails;

    _pageController = PageController(initialPage: widget.initialIndex);

    _thumbnailAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _thumbnailAnimation = CurvedAnimation(
      parent: _thumbnailAnimationController,
      curve: Curves.easeInOut,
    );

    if (_showThumbnails) {
      _thumbnailAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbnailAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onItemSelected?.call(widget.items[index], index);
  }

  void _toggleThumbnails() {
    setState(() {
      _showThumbnails = !_showThumbnails;
      if (_showThumbnails) {
        _thumbnailAnimationController.forward();
      } else {
        _thumbnailAnimationController.reverse();
      }
    });
  }

  void _goToItem(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildFullscreenView() {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.black,
      appBar: widget.appBarBuilder?.call(widget.items[_currentIndex], _currentIndex) ??
             _buildDefaultAppBar(),
      body: Stack(
        children: [
          // Main image/video viewer
          PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return _MediaViewer(
                item: widget.items[index],
                allowZoom: widget.allowZoom,
                loadingWidget: widget.loadingWidget,
                errorBuilder: widget.errorBuilder,
              );
            },
          ),

          // Thumbnail strip
          if (widget.showThumbnails)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _thumbnailAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 80 * (1 - _thumbnailAnimation.value)),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                      child: _buildThumbnailStrip(),
                    ),
                  );
                },
              ),
            ),

          // Counter
          if (widget.showCounter)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.items.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildDefaultAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        if (widget.showThumbnails)
          IconButton(
            icon: Icon(_showThumbnails ? Icons.visibility_off : Icons.visibility),
            onPressed: _toggleThumbnails,
          ),
        if (widget.showShareButton)
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => widget.onShare?.call(widget.items[_currentIndex]),
          ),
        if (widget.showDownloadButton)
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => widget.onDownload?.call(widget.items[_currentIndex]),
          ),
        if (widget.showDeleteButton)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(widget.items[_currentIndex]),
          ),
      ],
    );
  }

  Widget _buildThumbnailStrip() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final isSelected = index == _currentIndex;
        return GestureDetector(
          onTap: () => _goToItem(index),
          child: Container(
            width: 60,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: widget.thumbnailBuilder?.call(widget.items[index], index) ??
                   _buildDefaultThumbnail(widget.items[index]),
          ),
        );
      },
    );
  }

  Widget _buildDefaultThumbnail(MediaItem item) {
    if (item.type == MediaType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: item.thumbnailUrl != null
            ? Image.network(
                item.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  );
                },
              )
            : Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.play_arrow, color: Colors.white),
      );
    }
  }

  Widget _buildGridView() {
    final settings = widget.gridSettings ?? MediaGridSettings.defaultSettings();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: settings.crossAxisCount,
        mainAxisSpacing: settings.mainAxisSpacing,
        crossAxisSpacing: settings.crossAxisSpacing,
        childAspectRatio: settings.childAspectRatio,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return GestureDetector(
          onTap: () => widget.onItemSelected?.call(item, index),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.thumbnailBuilder?.call(item, index) ??
                _buildGridThumbnail(item),
                if (item.type == MediaType.video)
                  const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                if (item.duration != null)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatDuration(item.duration!),
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridThumbnail(MediaItem item) {
    if (item.thumbnailUrl != null) {
      return Image.network(
        item.thumbnailUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return widget.loadingWidget ?? const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return widget.errorBuilder?.call(error) ??
                 Container(
                   color: Colors.grey[300],
                   child: const Icon(Icons.broken_image, size: 32),
                 );
        },
      );
    } else {
      return Container(
        color: Colors.grey[300],
        child: Icon(
          item.type == MediaType.image ? Icons.image : Icons.videocam,
          size: 32,
        ),
      );
    }
  }

  Widget _buildCarouselView() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _MediaViewer(
                  item: widget.items[index],
                  allowZoom: widget.allowZoom,
                  loadingWidget: widget.loadingWidget,
                  errorBuilder: widget.errorBuilder,
                ),
              );
            },
          ),
        ),
        if (widget.showThumbnails)
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _buildThumbnailStrip(),
          ),
      ],
    );
  }

  void _showDeleteDialog(MediaItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Media'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete?.call(item);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No media items'),
          ],
        ),
      );
    }

    switch (widget.mode) {
      case MediaGalleryMode.fullscreen:
        return _buildFullscreenView();
      case MediaGalleryMode.grid:
        return _buildGridView();
      case MediaGalleryMode.carousel:
        return _buildCarouselView();
    }
  }
}

/// Individual media viewer widget with zoom and pan capabilities
class _MediaViewer extends StatefulWidget {
  final MediaItem item;
  final bool allowZoom;
  final Widget? loadingWidget;
  final Widget Function(Object error)? errorBuilder;

  const _MediaViewer({
    required this.item,
    required this.allowZoom,
    this.loadingWidget,
    this.errorBuilder,
  });

  @override
  State<_MediaViewer> createState() => __MediaViewerState();
}

class __MediaViewerState extends State<_MediaViewer> with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    if (!widget.allowZoom) return;

    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    const maxScale = 3.0;

    if (currentScale > 1.0) {
      // Zoom out
      _transformationController.value = Matrix4.identity();
    } else {
      // Zoom in
      final matrix = Matrix4.identity();
      matrix.setEntry(0, 0, maxScale);
      matrix.setEntry(1, 1, maxScale);
      _transformationController.value = matrix;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.type == MediaType.video) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Video Player',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    Widget imageWidget = widget.item.url != null
        ? Image.network(
            widget.item.url!,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return widget.loadingWidget ??
                     const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return widget.errorBuilder?.call(error) ??
                     const Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.broken_image, size: 64, color: Colors.grey),
                           SizedBox(height: 16),
                           Text('Failed to load image'),
                         ],
                       ),
                     );
            },
          )
        : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No image available'),
              ],
            ),
          );

    if (!widget.allowZoom) {
      return imageWidget;
    }

    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        maxScale: 5.0,
        minScale: 1.0,
        child: imageWidget,
      ),
    );
  }
}

/// Represents a media item (image or video)
class MediaItem {
  final String id;
  final String? url;
  final String? thumbnailUrl;
  final MediaType type;
  final String? title;
  final String? description;
  final Duration? duration;
  final DateTime? createdAt;
  final Map<String, dynamic>? metadata;

  const MediaItem({
    required this.id,
    this.url,
    this.thumbnailUrl,
    required this.type,
    this.title,
    this.description,
    this.duration,
    this.createdAt,
    this.metadata,
  });

  @override
  bool operator ==(Object other) {
    return other is MediaItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Media types
enum MediaType {
  image,
  video,
}

/// Gallery view modes
enum MediaGalleryMode {
  fullscreen,
  grid,
  carousel,
}

/// Grid settings for media gallery
class MediaGridSettings {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  const MediaGridSettings({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childAspectRatio,
  });

  static MediaGridSettings defaultSettings() => const MediaGridSettings(
    crossAxisCount: 3,
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,
    childAspectRatio: 1.0,
  );

  static MediaGridSettings compact() => const MediaGridSettings(
    crossAxisCount: 4,
    mainAxisSpacing: 2.0,
    crossAxisSpacing: 2.0,
    childAspectRatio: 1.0,
  );

  static MediaGridSettings large() => const MediaGridSettings(
    crossAxisCount: 2,
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
    childAspectRatio: 1.0,
  );
}

/// Pre-built media gallery configurations
class MediaGalleryPresets {
  /// Image gallery
  static MediaGallery imageGallery({
    required List<MediaItem> images,
    int initialIndex = 0,
    Function(MediaItem, int)? onItemSelected,
  }) {
    return MediaGallery(
      items: images,
      initialIndex: initialIndex,
      onItemSelected: onItemSelected,
      mode: MediaGalleryMode.fullscreen,
      allowZoom: true,
      showThumbnails: true,
    );
  }

  /// Grid gallery
  static MediaGallery gridGallery({
    required List<MediaItem> items,
    Function(MediaItem, int)? onItemSelected,
    MediaGridSettings? gridSettings,
  }) {
    return MediaGallery(
      items: items,
      onItemSelected: onItemSelected,
      mode: MediaGalleryMode.grid,
      gridSettings: gridSettings,
      showThumbnails: false,
    );
  }

  /// Carousel gallery
  static MediaGallery carouselGallery({
    required List<MediaItem> items,
    int initialIndex = 0,
    Function(MediaItem, int)? onItemSelected,
  }) {
    return MediaGallery(
      items: items,
      initialIndex: initialIndex,
      onItemSelected: onItemSelected,
      mode: MediaGalleryMode.carousel,
      allowZoom: true,
      showThumbnails: true,
    );
  }

  /// Photo viewer with actions
  static MediaGallery photoViewer({
    required List<MediaItem> images,
    int initialIndex = 0,
    Function(MediaItem)? onShare,
    Function(MediaItem)? onDownload,
    Function(MediaItem)? onDelete,
  }) {
    return MediaGallery(
      items: images,
      initialIndex: initialIndex,
      mode: MediaGalleryMode.fullscreen,
      allowZoom: true,
      showShareButton: onShare != null,
      showDownloadButton: onDownload != null,
      showDeleteButton: onDelete != null,
      onShare: onShare,
      onDownload: onDownload,
      onDelete: onDelete,
    );
  }
}

/// Extension for easy media gallery integration
extension MediaGalleryExtension on List<MediaItem> {
  /// Convert list of media items to a gallery widget
  Widget toGallery({
    MediaGalleryMode mode = MediaGalleryMode.grid,
    int initialIndex = 0,
    Function(MediaItem, int)? onItemSelected,
    MediaGridSettings? gridSettings,
  }) {
    return MediaGallery(
      items: this,
      initialIndex: initialIndex,
      onItemSelected: onItemSelected,
      mode: mode,
      gridSettings: gridSettings,
    );
  }

  /// Create a fullscreen image gallery
  Widget toImageGallery({
    int initialIndex = 0,
    Function(MediaItem, int)? onItemSelected,
  }) {
    return MediaGalleryPresets.imageGallery(
      images: this,
      initialIndex: initialIndex,
      onItemSelected: onItemSelected,
    );
  }
}