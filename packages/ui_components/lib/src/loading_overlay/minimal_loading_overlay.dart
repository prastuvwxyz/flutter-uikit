import 'dart:ui';

import 'package:flutter/material.dart';
import '../spinner/minimal_spinner.dart';
import '../../tokens/color_tokens.dart';

/// Full-screen loading overlay that blocks interaction and shows a centered
/// spinner and optional message.
class MinimalLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget? child;
  final Widget? loadingWidget;
  final String? message;
  final bool showMessage;
  final Color? backgroundColor;
  final double opacity;
  final bool blurEffect;
  final double blurSigma;
  final Duration animationDuration;
  final double spinnerSize;
  final Color? spinnerColor;
  final TextStyle? messageStyle;
  final Alignment alignment;

  const MinimalLoadingOverlay({
    Key? key,
    this.isLoading = false,
    this.child,
    this.loadingWidget,
    this.message,
    this.showMessage = true,
    this.backgroundColor,
    this.opacity = 0.8,
    this.blurEffect = false,
    this.blurSigma = 3.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.spinnerSize = 32.0,
    this.spinnerColor,
    this.messageStyle,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = (backgroundColor ?? Colors.black).withOpacity(opacity);

    final spinner =
        loadingWidget ??
        MinimalSpinner(
          size: spinnerSize,
          color: spinnerColor ?? ColorTokens.primary,
        );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        spinner,
        if (showMessage && (message ?? '').isNotEmpty) ...[
          SizedBox(height: 12),
          DefaultTextStyle(
            style: messageStyle ?? TextStyle(color: Colors.white, fontSize: 14),
            child: Text(message!),
          ),
        ],
      ],
    );

    final overlay = Semantics(
      container: true,
      label: 'Loading',
      // role=progressbar equivalent handled by semantics
      child: ExcludeSemantics(
        excluding: false,
        child: AnimatedOpacity(
          duration: animationDuration,
          opacity: isLoading ? 1.0 : 0.0,
          child: IgnorePointer(
            ignoring: !isLoading,
            child: Container(
              color: bgColor,
              child: Stack(
                children: [
                  if (blurEffect)
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: blurSigma,
                        sigmaY: blurSigma,
                      ),
                      child: Container(color: Colors.transparent),
                    ),
                  Align(
                    alignment: alignment,
                    child: Material(
                      color: Colors.transparent,
                      child: Center(child: content),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        child ?? SizedBox.shrink(),
        // Ensure overlay takes full screen when loading
        Positioned.fill(child: isLoading ? overlay : SizedBox.shrink()),
      ],
    );
  }
}
