/// Enum defining the available sizes for the MinimalCheckbox component
enum CheckboxSize {
  /// Small checkbox
  sm,

  /// Medium checkbox (default)
  md,

  /// Large checkbox
  lg,
}

/// Enum defining the available positions for the MinimalCheckbox label
enum CheckboxLabelPosition {
  /// Label appears to the left of the checkbox
  left,

  /// Label appears to the right of the checkbox (default)
  right,

  /// Label appears above the checkbox
  top,

  /// Label appears below the checkbox
  bottom,
}

/// Extension on CheckboxLabelPosition to determine if the position is horizontal
extension CheckboxLabelPositionExt on CheckboxLabelPosition {
  /// Returns true if the label position is horizontal (left or right)
  bool get isHorizontal =>
      this == CheckboxLabelPosition.left || this == CheckboxLabelPosition.right;

  /// Returns true if the label position is vertical (top or bottom)
  bool get isVertical =>
      this == CheckboxLabelPosition.top || this == CheckboxLabelPosition.bottom;
}
