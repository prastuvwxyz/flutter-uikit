import 'package:flutter/material.dart';

/// Represents a single tab item in the [MinimalTabs] component.
class TabItem {
  /// The label text to display for this tab.
  final String label;

  /// Optional icon to display alongside the label.
  final IconData? icon;

  /// Optional badge count to display on the tab.
  /// When non-null, shows a badge with this number.
  final int? badgeCount;

  /// Whether this tab is disabled.
  final bool disabled;

  /// Creates a [TabItem].
  ///
  /// [label] is the text to display for the tab.
  /// [icon] is an optional icon to display alongside the text.
  /// [badgeCount] is an optional number to show as a badge.
  /// [disabled] determines if the tab is interactive.
  const TabItem({
    required this.label,
    this.icon,
    this.badgeCount,
    this.disabled = false,
  });
}
