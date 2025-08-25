/// The type of the text field which determines the keyboard type
/// and validation behavior.
enum TextFieldType {
  /// Regular text input
  text,

  /// Email input with email keyboard and optional validation
  email,

  /// Password input with obscured text
  password,

  /// Number input with numeric keyboard
  number,

  /// Search input with search keyboard
  search,
}
