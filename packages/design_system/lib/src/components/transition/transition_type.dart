/// Describes the supported minimal transition types.
enum TransitionType {
  fade,
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  scale,
  rotate,
}

extension TransitionTypeUtils on TransitionType {
  bool get isSlide {
    return this == TransitionType.slideUp ||
        this == TransitionType.slideDown ||
        this == TransitionType.slideLeft ||
        this == TransitionType.slideRight;
  }
}
