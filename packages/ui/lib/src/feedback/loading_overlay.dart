import 'package:flutter/material.dart';
import 'package:tokens/tokens.dart' as tokens;
import 'spinner.dart';
import 'backdrop.dart';

/// A loading overlay component that displays a spinner with backdrop.
///
/// The LoadingOverlay component provides a convenient way to display loading
/// states over existing content. It combines a backdrop with a spinner and
/// optional message to indicate that work is in progress.
///
/// Example:
/// ```dart
/// LoadingOverlay(
///   isLoading: isProcessing,
///   message: 'Saving changes...',
///   child: MyContent(),
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  /// Whether the loading overlay should be visible
  final bool isLoading;

  /// The content to display behind the overlay
  final Widget child;

  /// Optional message to display below the spinner
  final String? message;

  /// Optional custom spinner widget
  final Widget? spinner;

  /// Color of the backdrop barrier
  final Color? barrierColor;

  /// Whether to apply blur effect to the backdrop
  final bool blurEffect;

  /// Sigma value for blur effect
  final double blurSigma;

  /// Animation duration for showing/hiding
  final Duration animationDuration;

  /// Custom text style for the message
  final TextStyle? messageStyle;

  /// Spacing between spinner and message
  final double spacing;

  /// Creates a LoadingOverlay component.
  ///
  /// The [isLoading] parameter controls whether the overlay is visible.
  /// The [child] parameter is the content to display behind the overlay.
  /// The [message] parameter is optional text to show below the spinner.
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.spinner,
    this.barrierColor,
    this.blurEffect = false,
    this.blurSigma = 5.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.messageStyle,
    this.spacing = 16.0,
  });

  /// Creates a loading overlay with blur effect
  factory LoadingOverlay.blur({
    required bool isLoading,
    required Widget child,
    String? message,
    Widget? spinner,
    double blurSigma = 5.0,
  }) =>
      LoadingOverlay(
        isLoading: isLoading,
        child: child,
        message: message,
        spinner: spinner,
        blurEffect: true,
        blurSigma: blurSigma,
      );

  /// Creates a simple loading overlay without blur
  factory LoadingOverlay.simple({
    required bool isLoading,
    required Widget child,
    String? message,
  }) =>
      LoadingOverlay(
        isLoading: isLoading,
        child: child,
        message: message,
        blurEffect: false,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        child,

        // Loading overlay
        if (isLoading)
          Backdrop(
            isVisible: isLoading,
            barrierColor: barrierColor,
            blurEffect: blurEffect,
            blurSigma: blurSigma,
            animationDuration: animationDuration,
            barrierDismissible: false,
            child: _buildLoadingContent(context),
          ),
      ],
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = tokens.Spacing.of(context);

    final effectiveSpinner = spinner ?? Spinner.medium();

    final effectiveMessageStyle = messageStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        );

    // If no message, just return the spinner
    if (message == null || message!.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(spacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(spacing.sm),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: effectiveSpinner,
        ),
      );
    }

    // Return spinner with message
    return Center(
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(spacing.sm),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            effectiveSpinner,
            SizedBox(height: this.spacing),
            Text(
              message!,
              style: effectiveMessageStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}