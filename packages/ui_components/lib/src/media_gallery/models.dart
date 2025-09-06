/// Simple model representing an image or video item for MinimalMediaGallery.
class MediaItem {
  final String src;
  final String? caption;
  final bool isVideo;

  const MediaItem({required this.src, this.caption, this.isVideo = false});
}

enum GalleryLayout { grid, carousel }
