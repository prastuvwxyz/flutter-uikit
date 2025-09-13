import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tokens/tokens.dart' as tokens;

/// Defines the visual variants for the Button
enum ButtonVariant {
  /// Primary action button
  primary,

  /// Secondary action button
  secondary,

  /// Outline/ghost button (minimal styling)
  outline,

  /// Text button (no background)
  text,

  /// Dangerous or destructive action button
  danger,
}

/// Defines the size variants for the Button
enum ButtonSize {
  /// Small button size
  sm,

  /// Medium button size (default)
  md,

  /// Large button size
  lg,
}

/// A pressable button component with multiple variants and sizes.
///
/// The button supports primary, secondary, outline, text, and danger variants,
/// as well as small, medium, and large sizes. It also handles loading states,
/// leading/trailing icons, and full-width options.
class Button extends StatefulWidget {
  /// The visual variant of the button
  final ButtonVariant variant;

  /// The size of the button
  final ButtonSize size;

  /// Optional widget to show before the button content
  final Widget? leading;

  /// Optional widget to show after the button content
  final Widget? trailing;

  /// The content of the button (usually text)
  final Widget? child;

  /// Callback when button is pressed, null means button is disabled
  final VoidCallback? onPressed;

  /// Whether the button should show a loading indicator
  final bool isLoading;

  /// Whether the button should take up the full width of its container
  final bool fullWidth;

  /// Creates a Button with customizable appearance and behavior.
  ///
  /// [child] is the content of the button, typically a Text widget.
  /// [onPressed] is the callback when the button is pressed. If null, the button is disabled.
  /// [variant] controls the visual style of the button (defaults to primary).
  /// [size] controls the size of the button (defaults to md).
  /// [isLoading] shows a loading spinner and disables interaction when true.
  /// [fullWidth] makes the button expand to fill its container width.
  /// [leading] and [trailing] are optional icons/widgets shown before/after the main content.
  const Button({
    super.key,
    this.child,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.leading,
    this.trailing,
    this.isLoading = false,
    this.fullWidth = false,
  });

  /// Creates a primary button
  factory Button.primary({
    Key? key,
    Widget? child,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    Widget? leading,
    Widget? trailing,
    bool isLoading = false,
    bool fullWidth = false,
  }) =>
      Button(
        key: key,
        child: child,
        onPressed: onPressed,
        variant: ButtonVariant.primary,
        size: size,
        leading: leading,
        trailing: trailing,
        isLoading: isLoading,
        fullWidth: fullWidth,
      );

  /// Creates a secondary button
  factory Button.secondary({
    Key? key,
    Widget? child,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    Widget? leading,
    Widget? trailing,
    bool isLoading = false,
    bool fullWidth = false,
  }) =>
      Button(
        key: key,
        child: child,
        onPressed: onPressed,
        variant: ButtonVariant.secondary,
        size: size,
        leading: leading,
        trailing: trailing,
        isLoading: isLoading,
        fullWidth: fullWidth,
      );

  /// Creates an outline button
  factory Button.outline({
    Key? key,
    Widget? child,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    Widget? leading,
    Widget? trailing,
    bool isLoading = false,
    bool fullWidth = false,
  }) =>
      Button(
        key: key,
        child: child,
        onPressed: onPressed,
        variant: ButtonVariant.outline,
        size: size,
        leading: leading,
        trailing: trailing,
        isLoading: isLoading,
        fullWidth: fullWidth,
      );

  /// Creates a text button
  factory Button.text({
    Key? key,
    Widget? child,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    Widget? leading,
    Widget? trailing,
    bool isLoading = false,
    bool fullWidth = false,
  }) =>
      Button(
        key: key,
        child: child,
        onPressed: onPressed,
        variant: ButtonVariant.text,
        size: size,
        leading: leading,
        trailing: trailing,
        isLoading: isLoading,
        fullWidth: fullWidth,
      );

  /// Creates a danger button
  factory Button.danger({
    Key? key,
    Widget? child,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    Widget? leading,
    Widget? trailing,
    bool isLoading = false,
    bool fullWidth = false,
  }) =>
      Button(
        key: key,
        child: child,
        onPressed: onPressed,
        variant: ButtonVariant.danger,
        size: size,
        leading: leading,
        trailing: trailing,
        isLoading: isLoading,
        fullWidth: fullWidth,
      );

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  /// Determines if the button is in a disabled state
  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = tokens.Spacing.of(context);
    final radius = tokens.Radius.of(context);

    // Define styles based on button variant and state
    final styleData = _getButtonStyleData(theme);

    // Define button size properties
    final sizeData = _getButtonSizeData(spacing);

    // Build the button
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown:
              _isDisabled ? null : (_) => setState(() => _isPressed = true),
          onTapUp:
              _isDisabled ? null : (_) => setState(() => _isPressed = false),
          onTapCancel:
              _isDisabled ? null : () => setState(() => _isPressed = false),
          child: SizedBox(
            width: widget.fullWidth ? double.infinity : null,
            height: sizeData.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isDisabled
                    ? null
                    : () {
                        _handleTap();
                      },
                splashFactory:
                    Theme.of(context).platform == TargetPlatform.android
                        ? InkRipple.splashFactory
                        : InkSplash.splashFactory,
                splashColor: styleData.splashColor,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(radius.md),
                child: Ink(
                  decoration: BoxDecoration(
                    color: _getCurrentBackgroundColor(styleData),
                    borderRadius: BorderRadius.circular(radius.md),
                    border: _getBorder(styleData),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizeData.horizontalPadding,
                      vertical: sizeData.verticalPadding,
                    ),
                    child: Center(
                      child: _buildContent(sizeData.textStyle, styleData),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handle tap interaction with haptic feedback based on platform
  void _handleTap() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        HapticFeedback.lightImpact();
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        HapticFeedback.selectionClick();
        break;
      default:
        // No haptic feedback for web/desktop platforms
        break;
    }
    widget.onPressed?.call();
  }

  /// Build the content of the button, including loading state and icons
  Widget _buildContent(TextStyle textStyle, _ButtonStyleData styleData) {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: styleData.foregroundColor,
        ),
      );
    }

    final content = widget.child;
    final leading = widget.leading;
    final trailing = widget.trailing;

    // If we have no content but have icons, center the icons
    if (content == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null)
            _colorFilteredIcon(leading, styleData.foregroundColor),
          if (leading != null && trailing != null) const SizedBox(width: 8),
          if (trailing != null)
            _colorFilteredIcon(trailing, styleData.foregroundColor),
        ],
      );
    }

    // Regular layout with content and optional icons
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          _colorFilteredIcon(leading, styleData.foregroundColor),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: DefaultTextStyle(
            style: textStyle.copyWith(color: styleData.foregroundColor),
            overflow: TextOverflow.ellipsis,
            child: content,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          _colorFilteredIcon(trailing, styleData.foregroundColor),
        ],
      ],
    );
  }

  /// Apply color filter to icon to match button styling
  Widget _colorFilteredIcon(Widget icon, Color color) {
    return IconTheme(
      data: IconThemeData(color: color, size: 20),
      child: icon,
    );
  }

  /// Get the current background color based on state
  Color _getCurrentBackgroundColor(_ButtonStyleData styleData) {
    if (_isDisabled) return styleData.disabledBackgroundColor;
    if (_isPressed) return styleData.pressedBackgroundColor;
    if (_isHovered) return styleData.hoverBackgroundColor;
    if (_isFocused) return styleData.focusBackgroundColor;
    return styleData.backgroundColor;
  }

  /// Get the current border based on variant and state
  Border? _getBorder(_ButtonStyleData styleData) {
    if (widget.variant == ButtonVariant.outline) {
      return Border.all(
        color:
            _isDisabled ? styleData.disabledBorderColor : styleData.borderColor,
        width: 1,
      );
    }
    return null;
  }

  /// Define button style based on variant and theme
  _ButtonStyleData _getButtonStyleData(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (widget.variant) {
      case ButtonVariant.primary:
        final primaryColor = colorScheme.primary;
        final onPrimaryColor = colorScheme.onPrimary;

        return _ButtonStyleData(
          backgroundColor: primaryColor,
          hoverBackgroundColor: primaryColor.withValues(alpha: 0.9),
          pressedBackgroundColor: primaryColor.withValues(alpha: 0.8),
          focusBackgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withValues(alpha: 0.5),
          foregroundColor: onPrimaryColor,
          disabledForegroundColor: onPrimaryColor.withValues(alpha: 0.7),
          borderColor: Colors.transparent,
          disabledBorderColor: Colors.transparent,
          splashColor: onPrimaryColor.withValues(alpha: 0.2),
        );

      case ButtonVariant.secondary:
        final secondaryColor = colorScheme.secondary;
        final onSecondaryColor = colorScheme.onSecondary;

        return _ButtonStyleData(
          backgroundColor: secondaryColor,
          hoverBackgroundColor: secondaryColor.withValues(alpha: 0.9),
          pressedBackgroundColor: secondaryColor.withValues(alpha: 0.8),
          focusBackgroundColor: secondaryColor,
          disabledBackgroundColor: secondaryColor.withValues(alpha: 0.5),
          foregroundColor: onSecondaryColor,
          disabledForegroundColor: onSecondaryColor.withValues(alpha: 0.7),
          borderColor: Colors.transparent,
          disabledBorderColor: Colors.transparent,
          splashColor: onSecondaryColor.withValues(alpha: 0.2),
        );

      case ButtonVariant.danger:
        final errorColor = colorScheme.error;
        final onErrorColor = colorScheme.onError;

        return _ButtonStyleData(
          backgroundColor: errorColor,
          hoverBackgroundColor: errorColor.withValues(alpha: 0.9),
          pressedBackgroundColor: errorColor.withValues(alpha: 0.8),
          focusBackgroundColor: errorColor,
          disabledBackgroundColor: errorColor.withValues(alpha: 0.5),
          foregroundColor: onErrorColor,
          disabledForegroundColor: onErrorColor.withValues(alpha: 0.7),
          borderColor: Colors.transparent,
          disabledBorderColor: Colors.transparent,
          splashColor: onErrorColor.withValues(alpha: 0.2),
        );

      case ButtonVariant.outline:
        final primaryColor = colorScheme.primary;
        final outlineColor = colorScheme.outline;

        return _ButtonStyleData(
          backgroundColor: Colors.transparent,
          hoverBackgroundColor: primaryColor.withValues(alpha: 0.05),
          pressedBackgroundColor: primaryColor.withValues(alpha: 0.1),
          focusBackgroundColor: primaryColor.withValues(alpha: 0.03),
          disabledBackgroundColor: Colors.transparent,
          foregroundColor: primaryColor,
          disabledForegroundColor: primaryColor.withValues(alpha: 0.5),
          borderColor: outlineColor,
          disabledBorderColor: outlineColor.withValues(alpha: 0.3),
          splashColor: primaryColor.withValues(alpha: 0.1),
        );

      case ButtonVariant.text:
        final primaryColor = colorScheme.primary;

        return _ButtonStyleData(
          backgroundColor: Colors.transparent,
          hoverBackgroundColor: primaryColor.withValues(alpha: 0.05),
          pressedBackgroundColor: primaryColor.withValues(alpha: 0.1),
          focusBackgroundColor: primaryColor.withValues(alpha: 0.03),
          disabledBackgroundColor: Colors.transparent,
          foregroundColor: primaryColor,
          disabledForegroundColor: primaryColor.withValues(alpha: 0.5),
          borderColor: Colors.transparent,
          disabledBorderColor: Colors.transparent,
          splashColor: primaryColor.withValues(alpha: 0.1),
        );
    }
  }

  /// Define button size properties based on spacing tokens
  _ButtonSizeData _getButtonSizeData(tokens.Spacing spacing) {
    switch (widget.size) {
      case ButtonSize.sm:
        return _ButtonSizeData(
          height: 32.0,
          horizontalPadding: spacing.sm,
          verticalPadding: spacing.xs / 2,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        );
      case ButtonSize.md:
        return _ButtonSizeData(
          height: 40.0,
          horizontalPadding: spacing.md,
          verticalPadding: spacing.sm / 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
      case ButtonSize.lg:
        return _ButtonSizeData(
          height: 48.0,
          horizontalPadding: spacing.lg,
          verticalPadding: spacing.md / 2,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        );
    }
  }
}

/// Helper class to encapsulate button style properties
class _ButtonStyleData {
  final Color backgroundColor;
  final Color hoverBackgroundColor;
  final Color pressedBackgroundColor;
  final Color focusBackgroundColor;
  final Color disabledBackgroundColor;
  final Color foregroundColor;
  final Color disabledForegroundColor;
  final Color borderColor;
  final Color disabledBorderColor;
  final Color splashColor;

  const _ButtonStyleData({
    required this.backgroundColor,
    required this.hoverBackgroundColor,
    required this.pressedBackgroundColor,
    required this.focusBackgroundColor,
    required this.disabledBackgroundColor,
    required this.foregroundColor,
    required this.disabledForegroundColor,
    required this.borderColor,
    required this.disabledBorderColor,
    required this.splashColor,
  });
}

/// Helper class to encapsulate button size properties
class _ButtonSizeData {
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final TextStyle textStyle;

  const _ButtonSizeData({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.textStyle,
  });
}