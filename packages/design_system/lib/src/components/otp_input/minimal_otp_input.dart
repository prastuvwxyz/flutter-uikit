import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'otp_controller.dart';
import 'otp_field.dart';

enum OTPBorderType { underline, outline, rounded }

class MinimalOTPInput extends StatefulWidget {
  const MinimalOTPInput({
    Key? key,
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
  }) : super(key: key);

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

  @override
  State<MinimalOTPInput> createState() => _MinimalOTPInputState();
}

class _MinimalOTPInputState extends State<MinimalOTPInput> {
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
        if (_focusNodes.isNotEmpty) _focusNodes[0].requestFocus();
      });
    }

    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant MinimalOTPInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      // rebuild controllers
      for (final c in _textControllers) {
        c.dispose();
      }
      for (final f in _focusNodes) {
        f.dispose();
      }
      _textControllers.clear();
      _focusNodes.clear();
      _textControllers.addAll(
        List.generate(widget.length, (_) => TextEditingController()),
      );
      _focusNodes.addAll(List.generate(widget.length, (_) => FocusNode()));
    }
  }

  void _onControllerChanged() {
    final text = _controller.text;
    for (var i = 0; i < widget.length; i++) {
      _textControllers[i].text = i < text.length ? text[i] : '';
    }
    widget.onChanged?.call(text);
    if (text.length == widget.length) {
      widget.onCompleted?.call(text);
    }
  }

  String _collect() => _textControllers.map((c) => c.text).join();

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    for (final c in _textControllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _rootFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _rootFocus,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index == widget.length - 1 ? 0 : widget.spacing,
            ),
            child: OTPField(
              controller: _textControllers[index],
              focusNode: _focusNodes[index],
              obscureText: widget.obscureText,
              enabled: widget.enabled && !widget.readOnly,
              readOnly: widget.readOnly,
              keyboardType: widget.keyboardType,
              width: widget.fieldWidth,
              height: widget.fieldHeight,
              onChanged: (val) {
                // set controller aggregate
                _controller.text = _collect();
                // move focus when a digit entered
                if (val.isNotEmpty) {
                  if (index + 1 < _focusNodes.length) {
                    _focusNodes[index + 1].requestFocus();
                  } else {
                    // last field
                    if (widget.autoSubmit) {
                      widget.onCompleted?.call(_collect());
                    }
                  }
                }
              },
              onKeyEvent: (node, event) {
                // use HardwareKeyboard to check pressed keys (non-deprecated)
                if (HardwareKeyboard.instance.logicalKeysPressed.contains(
                  LogicalKeyboardKey.backspace,
                )) {
                  if (_textControllers[index].text.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                    _textControllers[index - 1].selection =
                        TextSelection.collapsed(
                          offset: _textControllers[index - 1].text.length,
                        );
                  }
                }
                return KeyEventResult.ignored;
              },
            ),
          );
        }),
      ),
    );
  }
}
