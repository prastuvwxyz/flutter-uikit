/// Model for a radio option
class RadioOption<T> {
  final T value;
  final String label;
  final String? description;
  final bool disabled;

  const RadioOption({
    required this.value,
    required this.label,
    this.description,
    this.disabled = false,
  });
}
