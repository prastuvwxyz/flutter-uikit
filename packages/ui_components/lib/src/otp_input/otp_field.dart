import 'package:flutter/material.dart';

class OTPField extends StatelessWidget {
  const OTPField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.enabled,
    required this.width,
    required this.height,
    this.onChanged,
    this.onKeyEvent,
    this.keyboardType,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final bool enabled;
  final double width;
  final double height;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final TextInputType? keyboardType;
  final FocusOnKeyEventCallback? onKeyEvent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Focus(
        focusNode: focusNode,
        onKeyEvent: onKeyEvent,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          readOnly: readOnly,
          textAlign: TextAlign.center,
          keyboardType: keyboardType ?? TextInputType.number,
          obscureText: obscureText,
          maxLength: 1,
          onChanged: onChanged,
          decoration: const InputDecoration(counterText: ''),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
