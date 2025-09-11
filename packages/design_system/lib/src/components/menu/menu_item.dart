import 'package:flutter/material.dart';

/// A simple menu item widget that can be used inside [MinimalMenu].
class MenuItem extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final VoidCallback? onTap;
  final bool enabled;

  const MenuItem({
    super.key,
    this.leading,
    required this.title,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium!,
              child: title,
            ),
          ],
        ),
      ),
    );
  }
}
