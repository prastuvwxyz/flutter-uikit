import 'dart:async';
import 'package:flutter/material.dart';

/// MinimalForm - a lightweight form wrapper that manages field values,
/// validation, submission state and exposes simple callbacks.
///
/// This is a small, well-scoped implementation to satisfy the task-story
/// `UIK-203` used in examples and tests.

typedef FormSubmitCallback =
    FutureOr<void> Function(Map<String, dynamic> values);
typedef FormValidatorCallback =
    Map<String, String?> Function(Map<String, dynamic> values);
typedef FormChangedCallback = void Function(Map<String, dynamic> values);
typedef FieldChangedCallback = void Function(String field, dynamic value);

enum FormLayout { vertical, horizontal, grid }

class MinimalForm extends StatefulWidget {
  final Widget? child;
  final FormSubmitCallback? onSubmit;
  final FormValidatorCallback? validator;
  final AutovalidateMode autovalidateMode;
  final Map<String, dynamic>? initialValues;
  final FormChangedCallback? onChanged;
  final String submitButtonText;
  final bool loading;
  final bool disabled;
  final FormLayout layout;

  const MinimalForm({
    super.key,
    this.child,
    this.onSubmit,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.initialValues,
    this.onChanged,
    this.submitButtonText = 'Submit',
    this.loading = false,
    this.disabled = false,
    this.layout = FormLayout.vertical,
  });

  @override
  State<MinimalForm> createState() => _MinimalFormState();

  /// Helper to access the nearest form state from descendants.
  static _MinimalFormState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MinimalFormState>();
  }
}

class _MinimalFormState extends State<MinimalForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _values;
  Map<String, String?> _errors = {};
  bool _submitting = false;

  bool get loading => widget.loading || _submitting;

  @override
  void initState() {
    super.initState();
    _values = Map<String, dynamic>.from(widget.initialValues ?? {});
    if (widget.autovalidateMode != AutovalidateMode.disabled) {
      _validate();
    }
  }

  void registerField(String name, dynamic initial) {
    if (!_values.containsKey(name)) {
      setState(() {
        _values[name] = initial;
      });
      _emitChange();
    }
  }

  void unregisterField(String name) {
    if (_values.containsKey(name)) {
      setState(() {
        _values.remove(name);
        _errors.remove(name);
      });
      _emitChange();
    }
  }

  void setFieldValue(String name, dynamic value) {
    if (widget.disabled || loading) return;
    setState(() {
      _values[name] = value;
    });
    if (widget.autovalidateMode == AutovalidateMode.always) {
      _validate();
    }
    _emitChange();
  }

  dynamic getFieldValue(String name) => _values[name];

  Map<String, dynamic> get values => Map.unmodifiable(_values);

  Map<String, String?> get errors => Map.unmodifiable(_errors);

  bool validate() {
    final errs = widget.validator?.call(_values) ?? {};
    setState(() {
      _errors = errs.map((k, v) => MapEntry(k, v));
    });
    return _errors.values.every((e) => e == null);
  }

  void _validate() => validate();

  void _emitChange() {
    widget.onChanged?.call(values);
    // Could also dispatch onFieldChanged; keep simple for now.
  }

  Future<void> submit() async {
    if (widget.disabled || loading) return;
    setState(() {
      _submitting = true;
      _errors = {};
    });

    final isValid = validate();

    if (!isValid) {
      setState(() {
        _submitting = false;
      });
      return;
    }

    try {
      final result = widget.onSubmit?.call(values);
      if (result is Future) await result;
      // success state could be handled via other means; keep local.
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child;
    final isDisabled = widget.disabled || loading;

    Widget content = Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode,
      child: AbsorbPointer(
        absorbing: isDisabled,
        child: child ?? const SizedBox.shrink(),
      ),
    );

    // Basic layout handling; real implementation would be richer.
    switch (widget.layout) {
      case FormLayout.horizontal:
        content = Row(children: [Expanded(child: content)]);
        break;
      case FormLayout.grid:
        content = GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: [content],
        );
        break;
      case FormLayout.vertical:
        // keep as-is
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(container: true, child: content),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: (isDisabled || widget.onSubmit == null)
              ? null
              : () => submit(),
          child: widget.loading || _submitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.submitButtonText),
        ),
      ],
    );
  }
}

/// MinimalFormField - a helper to connect a field to the nearest MinimalForm.
class MinimalFormField<T> extends StatefulWidget {
  final String name;
  final T? initialValue;
  final Widget Function(
    BuildContext context,
    T? value,
    void Function(T? v) onChanged,
    String? error,
  )
  builder;

  const MinimalFormField({
    super.key,
    required this.name,
    this.initialValue,
    required this.builder,
  });

  @override
  State<MinimalFormField<T>> createState() => _MinimalFormFieldState<T>();
}

class _MinimalFormFieldState<T> extends State<MinimalFormField<T>> {
  T? _value;
  _MinimalFormState? _formState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formState = MinimalForm.of(context);
    _formState?.registerField(widget.name, widget.initialValue);
    _value =
        (_formState?.getFieldValue(widget.name) ?? widget.initialValue) as T?;
  }

  @override
  void dispose() {
    _formState?.unregisterField(widget.name);
    super.dispose();
  }

  void _setValue(T? v) {
    setState(() {
      _value = v;
    });
    _formState?.setFieldValue(widget.name, v);
  }

  @override
  Widget build(BuildContext context) {
    final error = _formState?.errors[widget.name];
    return widget.builder(context, _value, _setValue, error);
  }
}
