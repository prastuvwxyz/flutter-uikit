import 'package:flutter/material.dart';

/// A customizable transition wrapper for animating child widgets.
class Transition extends StatelessWidget {
  const Transition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.type = TransitionType.fade,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final TransitionType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TransitionType.fade:
        return AnimatedSwitcher(
          duration: duration,
          switchInCurve: curve,
          switchOutCurve: curve,
          child: child,
        );
      case TransitionType.slide:
        return AnimatedSwitcher(
          duration: duration,
          switchInCurve: curve,
          switchOutCurve: curve,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 0.3),
                  end: Offset.zero,
                ).chain(CurveTween(curve: curve)),
              ),
              child: child,
            );
          },
          child: child,
        );
      case TransitionType.scale:
        return AnimatedSwitcher(
          duration: duration,
          switchInCurve: curve,
          switchOutCurve: curve,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: child,
        );
    }
  }
}

/// Types of transitions available.
enum TransitionType {
  fade,
  slide,
  scale,
}