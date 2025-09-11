import 'package:flutter/material.dart';

/// Model class representing an option in a [MinimalSelect] dropdown.
class SelectOption<T> {
  /// The label text displayed to the user
  final String label;

  /// The value associated with this option
  final T value;

  /// Optional icon or widget to display before the label
  final Widget? leading;

  /// Optional data for customizing the option appearance
  final Map<String, dynamic>? data;

  /// Creates a select option with required label and value
  const SelectOption({
    required this.label,
    required this.value,
    this.leading,
    this.data,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectOption<T> &&
        other.value == value &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(label, value);
}
