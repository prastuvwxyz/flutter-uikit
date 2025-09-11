import 'dart:async';

import 'package:flutter/material.dart';
import 'models.dart';
import '../image/minimal_image.dart';

/// A compact, minimal implementation of a media gallery.
class MinimalMediaGallery extends StatefulWidget {
  final List<MediaItem> items;
  final int initialIndex;
  final ValueChanged<int>? onItemChanged;
  final ValueChanged<MediaItem>? onItemTap;
  final GalleryLayout layout;
  final double aspectRatio;
  final int crossAxisCount;
  final double spacing;
  final bool enableLightbox;
  final bool enableSlideshow;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const MinimalMediaGallery({
    Key? key,
    this.items = const [],
    this.initialIndex = 0,
    this.onItemChanged,
    this.onItemTap,
    this.layout = GalleryLayout.grid,
    this.aspectRatio = 1.0,
    this.crossAxisCount = 3,
    this.spacing = 4.0,
    this.enableLightbox = true,
    this.enableSlideshow = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<MinimalMediaGallery> createState() => _MinimalMediaGalleryState();
}

class _MinimalMediaGalleryState extends State<MinimalMediaGallery> {
  late int _current;
  PageController? _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex.clamp(
      0,
      widget.items.length > 0 ? widget.items.length - 1 : 0,
    );
    _pageController = PageController(initialPage: _current);
    _maybeStartAutoplay();
  }

  @override
  void didUpdateWidget(covariant MinimalMediaGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlay != widget.autoPlay ||
        oldWidget.autoPlayInterval != widget.autoPlayInterval) {
      _maybeStartAutoplay();
    }
  }

  void _maybeStartAutoplay() {
    _timer?.cancel();
    if (widget.enableSlideshow && widget.autoPlay && widget.items.length > 1) {
      _timer = Timer.periodic(widget.autoPlayInterval, (_) {
        final next = (_current + 1) % widget.items.length;
        _goTo(next);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.items.length) return;
    setState(() => _current = index);
    widget.onItemChanged?.call(index);
    _pageController?.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _openLightbox(int index) {
    if (!widget.enableLightbox) return;
    showDialog(
      context: context,
      builder: (context) {
        return _Lightbox(
          dialogIndex: index,
          items: widget.items,
          initialIndex: index,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    if (widget.layout == GalleryLayout.grid) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: widget.spacing,
          crossAxisSpacing: widget.spacing,
          childAspectRatio: widget.aspectRatio,
        ),
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return GestureDetector(
            onTap: () {
              widget.onItemTap?.call(item);
              _openLightbox(index);
            },
            child: Semantics(
              label: item.caption,
              image: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: MinimalImage(src: item.src, alt: item.caption),
              ),
            ),
          );
        },
      );
    }

    // carousel layout
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (i) {
              setState(() => _current = i);
              widget.onItemChanged?.call(i);
            },
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return GestureDetector(
                onTap: () {
                  widget.onItemTap?.call(item);
                  _openLightbox(index);
                },
                child: MinimalImage(
                  src: item.src,
                  alt: item.caption,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
        if (widget.items.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (i) {
                return GestureDetector(
                  onTap: () => _goTo(i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _current ? Colors.black87 : Colors.black26,
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _Lightbox extends StatefulWidget {
  final List<MediaItem> items;
  final int initialIndex;
  final int dialogIndex;

  const _Lightbox({
    Key? key,
    required this.items,
    required this.initialIndex,
    required this.dialogIndex,
  }) : super(key: key);

  @override
  State<_Lightbox> createState() => _LightboxState();
}

class _LightboxState extends State<_Lightbox> {
  late int _index;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.items.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return InteractiveViewer(
                  child: Center(
                    child: MinimalImage(
                      src: item.src,
                      alt: item.caption,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.items[_index].caption != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.items[_index].caption!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
