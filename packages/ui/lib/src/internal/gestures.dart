import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Gesture utilities and helpers for the UI package.
///
/// This library provides helper functions, recognizers, and utilities to handle
/// common gesture patterns across UI components, including multi-touch gestures,
/// custom gesture recognizers, and gesture conflict resolution.

/// Helper class for gesture utilities and custom recognizers
class GestureUtils {
  GestureUtils._();

  /// Create a tap gesture recognizer with debouncing
  static TapGestureRecognizer createDebouncedTap({
    required VoidCallback onTap,
    Duration debounceDelay = const Duration(milliseconds: 300),
  }) {
    DateTime? lastTapTime;

    return TapGestureRecognizer()
      ..onTap = () {
        final now = DateTime.now();
        if (lastTapTime == null ||
            now.difference(lastTapTime!) > debounceDelay) {
          lastTapTime = now;
          onTap();
        }
      };
  }

  /// Create a long press gesture recognizer with custom duration
  static LongPressGestureRecognizer createLongPress({
    required VoidCallback onLongPress,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onLongPressStart,
    VoidCallback? onLongPressEnd,
  }) {
    return LongPressGestureRecognizer()
      ..onLongPress = onLongPress
      ..onLongPressStart = onLongPressStart != null
          ? (details) => onLongPressStart()
          : null
      ..onLongPressEnd = onLongPressEnd != null
          ? (details) => onLongPressEnd()
          : null;
  }

  /// Create a pan gesture recognizer with velocity threshold
  static PanGestureRecognizer createPan({
    required void Function(DragUpdateDetails) onPanUpdate,
    void Function(DragStartDetails)? onPanStart,
    void Function(DragEndDetails)? onPanEnd,
    double minVelocity = 50.0,
  }) {
    return PanGestureRecognizer()
      ..onStart = onPanStart
      ..onUpdate = onPanUpdate
      ..onEnd = (details) {
        if (onPanEnd != null) {
          final velocity = details.velocity.pixelsPerSecond.distance;
          if (velocity >= minVelocity) {
            onPanEnd(details);
          }
        }
      };
  }

  /// Create a scale gesture recognizer for pinch-to-zoom
  static ScaleGestureRecognizer createScale({
    required void Function(ScaleUpdateDetails) onScaleUpdate,
    void Function(ScaleStartDetails)? onScaleStart,
    void Function(ScaleEndDetails)? onScaleEnd,
    double minScale = 0.1,
    double maxScale = 10.0,
  }) {
    return ScaleGestureRecognizer()
      ..onStart = onScaleStart
      ..onUpdate = (details) {
        if (details.scale >= minScale && details.scale <= maxScale) {
          onScaleUpdate(details);
        }
      }
      ..onEnd = onScaleEnd;
  }

  /// Calculate gesture velocity
  static double calculateVelocity(Velocity velocity) {
    return velocity.pixelsPerSecond.distance;
  }

  /// Check if gesture is a swipe based on velocity and distance
  static bool isSwipeGesture({
    required Offset delta,
    required Velocity velocity,
    double minDistance = 50.0,
    double minVelocity = 300.0,
  }) {
    final distance = delta.distance;
    final velocityMagnitude = calculateVelocity(velocity);

    return distance >= minDistance && velocityMagnitude >= minVelocity;
  }

  /// Get swipe direction from delta
  static SwipeDirection getSwipeDirection(Offset delta) {
    final dx = delta.dx.abs();
    final dy = delta.dy.abs();

    if (dx > dy) {
      return delta.dx > 0 ? SwipeDirection.right : SwipeDirection.left;
    } else {
      return delta.dy > 0 ? SwipeDirection.down : SwipeDirection.up;
    }
  }

  /// Combine multiple gesture recognizers with proper conflict resolution
  static Map<Type, GestureRecognizerFactory> combineGestureRecognizers(
    List<GestureRecognizer> recognizers,
  ) {
    final Map<Type, GestureRecognizerFactory> result = {};

    for (final recognizer in recognizers) {
      result[recognizer.runtimeType] = GestureRecognizerFactoryWithHandlers(
        () => recognizer,
        (instance) {},
      );
    }

    return result;
  }
}

/// Enumeration for swipe directions
enum SwipeDirection {
  up,
  down,
  left,
  right,
}

/// Custom gesture recognizer for double tap with timeout
class DoubleTapTimeoutGestureRecognizer extends DoubleTapGestureRecognizer {
  final Duration timeout;
  final VoidCallback? onTimeout;
  bool _hasTimedOut = false;

  DoubleTapTimeoutGestureRecognizer({
    this.timeout = const Duration(milliseconds: 300),
    this.onTimeout,
  });

  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    _hasTimedOut = false;

    if (onTimeout != null) {
      Future.delayed(timeout, () {
        if (!_hasTimedOut) {
          _hasTimedOut = true;
          onTimeout!();
        }
      });
    }
  }

  @override
  void acceptGesture(int pointer) {
    _hasTimedOut = true;
    super.acceptGesture(pointer);
  }

  @override
  void rejectGesture(int pointer) {
    _hasTimedOut = true;
    super.rejectGesture(pointer);
  }
}

/// Custom gesture recognizer for multi-tap detection
class MultiTapGestureRecognizer extends OneSequenceGestureRecognizer {
  final int requiredTaps;
  final Duration timeout;
  final VoidCallback? onMultiTap;
  final void Function(int tapCount)? onTapCountChanged;

  int _tapCount = 0;
  DateTime? _firstTapTime;

  MultiTapGestureRecognizer({
    required this.requiredTaps,
    this.timeout = const Duration(milliseconds: 500),
    this.onMultiTap,
    this.onTapCountChanged,
  });

  @override
  void addAllowedPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer, event.transform);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent) {
      final now = DateTime.now();

      if (_firstTapTime == null) {
        _firstTapTime = now;
        _tapCount = 1;
      } else {
        final timeDiff = now.difference(_firstTapTime!);
        if (timeDiff <= timeout) {
          _tapCount++;
        } else {
          _tapCount = 1;
          _firstTapTime = now;
        }
      }

      onTapCountChanged?.call(_tapCount);

      if (_tapCount >= requiredTaps) {
        resolve(GestureDisposition.accepted);
        onMultiTap?.call();
        _reset();
      } else {
        _scheduleTimeout();
      }

      stopTrackingPointer(event.pointer);
    }
  }

  void _scheduleTimeout() {
    Future.delayed(timeout, () {
      if (_tapCount > 0 && _tapCount < requiredTaps) {
        _reset();
        resolve(GestureDisposition.rejected);
      }
    });
  }

  void _reset() {
    _tapCount = 0;
    _firstTapTime = null;
  }

  @override
  String get debugDescription => 'MultiTap($requiredTaps)';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}

/// Widget for handling swipe gestures with directional callbacks
class SwipeDetector extends StatelessWidget {
  final Widget child;
  final void Function(SwipeDirection direction)? onSwipe;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double sensitivity;
  final double velocityThreshold;

  const SwipeDetector({
    super.key,
    required this.child,
    this.onSwipe,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.sensitivity = 50.0,
    this.velocityThreshold = 300.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond;

        if (GestureUtils.calculateVelocity(details.velocity) < velocityThreshold) {
          return;
        }

        if (velocity.dx.abs() > velocity.dy.abs()) {
          if (velocity.dx > 0) {
            onSwipe?.call(SwipeDirection.right);
            onSwipeRight?.call();
          } else {
            onSwipe?.call(SwipeDirection.left);
            onSwipeLeft?.call();
          }
        } else {
          if (velocity.dy > 0) {
            onSwipe?.call(SwipeDirection.down);
            onSwipeDown?.call();
          } else {
            onSwipe?.call(SwipeDirection.up);
            onSwipeUp?.call();
          }
        }
      },
      child: child,
    );
  }
}

/// Widget for handling pinch-to-zoom gestures
class PinchZoomDetector extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final void Function(double scale)? onScaleChanged;
  final VoidCallback? onScaleStart;
  final VoidCallback? onScaleEnd;

  const PinchZoomDetector({
    super.key,
    required this.child,
    this.minScale = 0.5,
    this.maxScale = 3.0,
    this.onScaleChanged,
    this.onScaleStart,
    this.onScaleEnd,
  });

  @override
  State<PinchZoomDetector> createState() => _PinchZoomDetectorState();
}

class _PinchZoomDetectorState extends State<PinchZoomDetector> {
  double _scale = 1.0;
  double _baseScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _baseScale = _scale;
        widget.onScaleStart?.call();
      },
      onScaleUpdate: (details) {
        final newScale = (_baseScale * details.scale)
            .clamp(widget.minScale, widget.maxScale);

        if (newScale != _scale) {
          setState(() {
            _scale = newScale;
          });
          widget.onScaleChanged?.call(_scale);
        }
      },
      onScaleEnd: (details) {
        widget.onScaleEnd?.call();
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

/// Widget for handling tap with hold gestures
class TapHoldDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onHoldStart;
  final VoidCallback? onHoldEnd;
  final void Function(Duration duration)? onHoldUpdate;
  final Duration holdThreshold;
  final Duration updateInterval;

  const TapHoldDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onHoldStart,
    this.onHoldEnd,
    this.onHoldUpdate,
    this.holdThreshold = const Duration(milliseconds: 500),
    this.updateInterval = const Duration(milliseconds: 100),
  });

  @override
  State<TapHoldDetector> createState() => _TapHoldDetectorState();
}

class _TapHoldDetectorState extends State<TapHoldDetector> {
  bool _isHolding = false;
  DateTime? _pressStartTime;
  Timer? _updateTimer;

  void _startHold() {
    _isHolding = true;
    _pressStartTime = DateTime.now();
    widget.onHoldStart?.call();

    _updateTimer = Timer.periodic(widget.updateInterval, (timer) {
      if (_isHolding && _pressStartTime != null) {
        final duration = DateTime.now().difference(_pressStartTime!);
        widget.onHoldUpdate?.call(duration);
      }
    });
  }

  void _endHold() {
    if (_isHolding) {
      _isHolding = false;
      _updateTimer?.cancel();
      _updateTimer = null;
      widget.onHoldEnd?.call();
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        Future.delayed(widget.holdThreshold, () {
          if (mounted && _pressStartTime != null) {
            _startHold();
          }
        });
      },
      onTapUp: (details) {
        if (!_isHolding && _pressStartTime != null) {
          widget.onTap?.call();
        }
        _endHold();
        _pressStartTime = null;
      },
      onTapCancel: () {
        _endHold();
        _pressStartTime = null;
      },
      child: widget.child,
    );
  }
}

/// Extension methods for easier gesture handling
extension GestureExtensions on Widget {
  /// Add swipe detection to any widget
  Widget withSwipeDetection({
    void Function(SwipeDirection direction)? onSwipe,
    VoidCallback? onSwipeUp,
    VoidCallback? onSwipeDown,
    VoidCallback? onSwipeLeft,
    VoidCallback? onSwipeRight,
    double sensitivity = 50.0,
    double velocityThreshold = 300.0,
  }) {
    return SwipeDetector(
      onSwipe: onSwipe,
      onSwipeUp: onSwipeUp,
      onSwipeDown: onSwipeDown,
      onSwipeLeft: onSwipeLeft,
      onSwipeRight: onSwipeRight,
      sensitivity: sensitivity,
      velocityThreshold: velocityThreshold,
      child: this,
    );
  }

  /// Add pinch-to-zoom detection to any widget
  Widget withPinchZoom({
    double minScale = 0.5,
    double maxScale = 3.0,
    void Function(double scale)? onScaleChanged,
    VoidCallback? onScaleStart,
    VoidCallback? onScaleEnd,
  }) {
    return PinchZoomDetector(
      minScale: minScale,
      maxScale: maxScale,
      onScaleChanged: onScaleChanged,
      onScaleStart: onScaleStart,
      onScaleEnd: onScaleEnd,
      child: this,
    );
  }

  /// Add tap-and-hold detection to any widget
  Widget withTapHold({
    VoidCallback? onTap,
    VoidCallback? onHoldStart,
    VoidCallback? onHoldEnd,
    void Function(Duration duration)? onHoldUpdate,
    Duration holdThreshold = const Duration(milliseconds: 500),
    Duration updateInterval = const Duration(milliseconds: 100),
  }) {
    return TapHoldDetector(
      onTap: onTap,
      onHoldStart: onHoldStart,
      onHoldEnd: onHoldEnd,
      onHoldUpdate: onHoldUpdate,
      holdThreshold: holdThreshold,
      updateInterval: updateInterval,
      child: this,
    );
  }
}