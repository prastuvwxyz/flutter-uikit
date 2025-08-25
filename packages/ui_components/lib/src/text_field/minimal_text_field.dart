import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'text_field_type.dart';

/// A text input field with validation, error states, and support for
/// text/email/password/number input types.
///
/// This component follows the design specifications outlined in PRD:§2.1,
/// PRD:§4.2, and PRD:§6.2.
class MinimalTextField extends StatefulWidget {
  /// Type of text field (text, email, password, number, search)
  final TextFieldType type;

  /// Floating label text
  final String? label;

  /// Hint text shown when the field is empty
  final String? placeholder;

  /// Helper text displayed below the field
  final String? helperText;

  /// Error message, when non-null shows error state
  final String? errorText;

  /// Icon or widget displayed before text
  final Widget? leading;

  /// Icon or widget displayed after text
  final Widget? trailing;

  /// Text editing controller
  final TextEditingController? controller;

  /// Focus node for managing focus state
  final FocusNode? focusNode;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is required
  final bool required;

  /// Maximum number of lines (null for multiline)
  final int? maxLines;

  /// Maximum character limit
  final int? maxLength;

  /// Callback for text changes
  final ValueChanged<String>? onChanged;

  /// Callback for field submission (Enter key)
  final ValueChanged<String>? onSubmitted;

  /// Form field validator function
  final FormFieldValidator<String>? validator;

  /// Creates a [MinimalTextField] component.
  ///
  /// The [type] defaults to [TextFieldType.text].
  const MinimalTextField({
    Key? key,
    this.type = TextFieldType.text,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.leading,
    this.trailing,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.required = false,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.validator,
  }) : super(key: key);

  @override
  State<MinimalTextField> createState() => _MinimalTextFieldState();
}

class _MinimalTextFieldState extends State<MinimalTextField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _passwordVisible = false;
  bool _hasInteracted = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();

    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }

    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && _hasInteracted) {
      _validate();
    }
    // Force rebuild to update focus styling
    setState(() {});
  }

  void _onTextChanged() {
    _hasInteracted = true;
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }

    // Clear validation error when the user starts typing again
    if (_validationError != null) {
      setState(() {
        _validationError = null;
      });
    }
  }

  void _validate() {
    if (widget.validator != null) {
      setState(() {
        _validationError = widget.validator!(_controller.text);
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _onSubmitted(String value) {
    _validate();
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<UiTokens>() ?? UiTokens.standard();
    final colors = tokens.colorTokens;
    final typography = tokens.typographyTokens;
    final spacing = tokens.spacingTokens;
    final radius = tokens.radiusTokens;

    final hasError = widget.errorText != null || _validationError != null;
    final isPasswordType = widget.type == TextFieldType.password;
    final showPasswordVisibilityIcon =
        isPasswordType && _controller.text.isNotEmpty;

    // Keyboard type selection based on field type
    TextInputType keyboardType;
    switch (widget.type) {
      case TextFieldType.email:
        keyboardType = TextInputType.emailAddress;
        break;
      case TextFieldType.number:
        keyboardType = TextInputType.number;
        break;
      case TextFieldType.search:
        keyboardType = TextInputType.text;
        break;
      case TextFieldType.password:
      case TextFieldType.text:
        keyboardType = TextInputType.text;
        break;
    }

    // Determine colors based on state
    final Color borderColor;
    final Color labelColor;
    final Color textColor;

    if (!widget.enabled) {
      // Disabled state
      borderColor = colors.neutral.shade300;
      labelColor = colors.neutral.shade400;
      textColor = colors.neutral.shade400;
    } else if (hasError) {
      // Error state
      borderColor = colors.error;
      labelColor = colors.error;
      textColor = colors.neutral.shade900;
    } else if (_focusNode.hasFocus) {
      // Focused state
      borderColor = colors.primary.shade500;
      labelColor = colors.primary.shade500;
      textColor = colors.neutral.shade900;
    } else {
      // Default state
      borderColor = colors.neutral.shade400;
      labelColor = colors.neutral.shade500;
      textColor = colors.neutral.shade900;
    }

    final inputFormatters = <TextInputFormatter>[];
    if (widget.type == TextFieldType.number) {
      inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (widget.maxLength != null) {
      inputFormatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }

    // Build the text field widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1.0),
            borderRadius: BorderRadius.circular(radius.md),
          ),
          child: Row(
            children: [
              if (widget.leading != null)
                Padding(
                  padding: EdgeInsets.only(left: spacing.md),
                  child: IconTheme(
                    data: IconThemeData(
                      color: widget.enabled
                          ? colors.neutral.shade600
                          : colors.neutral.shade400,
                      size: 20,
                    ),
                    child: widget.leading!,
                  ),
                ),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  keyboardType: keyboardType,
                  obscureText: isPasswordType && !_passwordVisible,
                  maxLines: widget.maxLines,
                  onFieldSubmitted: _onSubmitted,
                  inputFormatters: inputFormatters,
                  style: typography.bodyMedium.copyWith(
                    color: widget.enabled ? textColor : colors.neutral.shade400,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing.md,
                      vertical: spacing.sm,
                    ),
                    hintText: widget.placeholder,
                    hintStyle: typography.bodyMedium.copyWith(
                      color: colors.neutral.shade400,
                    ),
                    labelText: widget.label,
                    labelStyle: typography.labelMedium.copyWith(
                      color: labelColor,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    suffixIcon: showPasswordVisibilityIcon
                        ? IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: colors.neutral.shade600,
                              size: 20,
                            ),
                            onPressed: _togglePasswordVisibility,
                            tooltip: _passwordVisible
                                ? 'Hide password'
                                : 'Show password',
                          )
                        : widget.trailing != null
                        ? IconTheme(
                            data: IconThemeData(
                              color: widget.enabled
                                  ? colors.neutral.shade600
                                  : colors.neutral.shade400,
                              size: 20,
                            ),
                            child: widget.trailing!,
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    counterText: widget.maxLength != null
                        ? '${_controller.text.length}/${widget.maxLength}'
                        : null,
                    counterStyle: typography.labelSmall.copyWith(
                      color: colors.neutral.shade500,
                    ),
                    errorText: null, // We handle error display ourselves
                    errorMaxLines: 2,
                  ),
                ),
              ),
              if (widget.trailing != null && !showPasswordVisibilityIcon)
                Padding(
                  padding: EdgeInsets.only(right: spacing.md),
                  child: widget.trailing!,
                ),
            ],
          ),
        ),
        if ((widget.helperText != null || hasError) ||
            (widget.required && !_hasInteracted))
          Padding(
            padding: EdgeInsets.only(left: spacing.md, top: spacing.sm / 2),
            child: Text(
              hasError
                  ? (widget.errorText ?? _validationError!)
                  : widget.required && !_hasInteracted
                  ? '* Required'
                  : widget.helperText!,
              style: typography.labelSmall.copyWith(
                color: hasError
                    ? colors.error
                    : widget.required && !_hasInteracted
                    ? colors.error
                    : colors.neutral.shade500,
              ),
            ),
          ),
      ],
    );
  }
}
