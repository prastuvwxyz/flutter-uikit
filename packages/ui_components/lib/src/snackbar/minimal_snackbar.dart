import 'package:flutter/material.dart';

/// Simple, minimal snackbar widget used by examples and tests.
class MinimalSnackbar extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Duration duration;
  final VoidCallback? onDismiss;

  const MinimalSnackbar({
    Key? key,
    required this.message,
    this.backgroundColor,
    this.duration = const Duration(seconds: 4),
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Material(
            color: color,
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      message,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: textColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.close, color: textColor),
                    onPressed: onDismiss ?? () {},
                    tooltip: 'Dismiss',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
