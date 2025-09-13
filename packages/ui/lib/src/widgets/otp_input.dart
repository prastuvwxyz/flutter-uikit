import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum OTPBorderType { underline, outline, rounded }

class OTPController extends ChangeNotifier {
  OTPController({String? text}) : _text = text ?? '';

  String _text;

  String get text => _text;

  set text(String value) {
    if (_text == value) return;
    _text = value;
    notifyListeners();
  }

  void clear() {
    if (_text.isEmpty) return;
    _text = '';
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class OTPInput extends StatefulWidget {
  const OTPInput({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.autoFocus = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.number,
    this.enabled = true,
    this.readOnly = false,
    this.autoSubmit = true,
    this.fieldWidth = 48.0,
    this.fieldHeight = 56.0,
    this.spacing = 8.0,
    this.borderType = OTPBorderType.underline,
    this.validator,
    this.errorText,
    this.inputFormatters,
  });

  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final OTPController? controller;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final bool readOnly;
  final bool autoSubmit;
  final double fieldWidth;
  final double fieldHeight;
  final double spacing;
  final OTPBorderType borderType;
  final String? Function(String?)? validator;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  late final OTPController _controller;
  late final FocusScopeNode _rootFocus;
  late final List<TextEditingController> _textControllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? OTPController();
    _rootFocus = FocusScopeNode();
    _textControllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_focusNodes.isNotEmpty && mounted) {
          _focusNodes[0].requestFocus();
        }
      });
    }

    _controller.addListener(_onControllerChanged);
    _initializeWithControllerValue();
  }

  void _initializeWithControllerValue() {
    final text = _controller.text;
    for (var i = 0; i < widget.length; i++) {
      _textControllers[i].text = i < text.length ? text[i] : '';
    }
  }

  @override
  void didUpdateWidget(covariant OTPInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      _rebuildControllers();
    }
  }

  void _rebuildControllers() {
    // Dispose old controllers
    for (final c in _textControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }

    // Create new controllers
    _textControllers.clear();
    _focusNodes.clear();
    _textControllers.addAll(
      List.generate(widget.length, (_) => TextEditingController()),
    );
    _focusNodes.addAll(List.generate(widget.length, (_) => FocusNode()));

    _initializeWithControllerValue();
  }

  void _onControllerChanged() {
    final text = _controller.text;
    for (var i = 0; i < widget.length; i++) {
      final newText = i < text.length ? text[i] : '';
      if (_textControllers[i].text != newText) {
        _textControllers[i].text = newText;
      }
    }
    widget.onChanged?.call(text);
    if (text.length == widget.length) {
      widget.onCompleted?.call(text);
    }
  }

  String _collectText() => _textControllers.map((c) => c.text).join();

  void _updateController() {
    final newText = _collectText();
    if (_controller.text != newText) {
      _controller.text = newText;
    }
  }

  void _onFieldChanged(String value, int index) {
    // Ensure only single character
    if (value.length > 1) {
      _textControllers[index].text = value.substring(value.length - 1);
      _textControllers[index].selection = TextSelection.collapsed(offset: 1);
      return;
    }

    _updateController();

    // Move focus when a digit is entered
    if (value.isNotEmpty && index + 1 < _focusNodes.length) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == widget.length - 1) {
      // Last field filled
      if (widget.autoSubmit) {
        final fullText = _collectText();
        if (fullText.length == widget.length) {
          widget.onCompleted?.call(fullText);
        }
      }
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_textControllers[index].text.isEmpty && index > 0) {
          _focusNodes[index - 1].requestFocus();
          _textControllers[index - 1].selection = TextSelection.collapsed(
            offset: _textControllers[index - 1].text.length,
          );
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft && index > 0) {
        _focusNodes[index - 1].requestFocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight && index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  InputBorder _getBorder({required bool hasError, required bool isFocused}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color borderColor;
    if (hasError) {
      borderColor = colorScheme.error;
    } else if (isFocused) {
      borderColor = colorScheme.primary;
    } else {
      borderColor = colorScheme.outline;
    }

    switch (widget.borderType) {
      case OTPBorderType.underline:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: isFocused ? 2 : 1),
        );
      case OTPBorderType.outline:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: borderColor, width: isFocused ? 2 : 1),
        );
      case OTPBorderType.rounded:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: isFocused ? 2 : 1),
        );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    for (final c in _textControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _rootFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return FocusScope(
      node: _rootFocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index == widget.length - 1 ? 0 : widget.spacing,
                ),
                child: SizedBox(
                  width: widget.fieldWidth,
                  height: widget.fieldHeight,
                  child: Focus(
                    onKeyEvent: (node, event) => _onKeyEvent(node, event, index),
                    child: TextField(
                      controller: _textControllers[index],
                      focusNode: _focusNodes[index],
                      obscureText: widget.obscureText,
                      enabled: widget.enabled && !widget.readOnly,
                      readOnly: widget.readOnly,
                      keyboardType: widget.keyboardType,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        ...?(widget.inputFormatters),
                      ],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: _getBorder(hasError: hasError, isFocused: false),
                        enabledBorder: _getBorder(hasError: hasError, isFocused: false),
                        focusedBorder: _getBorder(hasError: hasError, isFocused: true),
                        errorBorder: _getBorder(hasError: true, isFocused: false),
                        focusedErrorBorder: _getBorder(hasError: true, isFocused: true),
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                      ),
                      onChanged: (value) => _onFieldChanged(value, index),
                    ),
                  ),
                ),
              );
            }),
          ),
          if (hasError) ...[
            SizedBox(height: 8),
            Text(
              widget.errorText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}