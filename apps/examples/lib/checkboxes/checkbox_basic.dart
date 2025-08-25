import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Basic usage example of the MinimalCheckbox component
class CheckboxBasicExample extends StatefulWidget {
  /// Creates a CheckboxBasicExample widget
  const CheckboxBasicExample({Key? key}) : super(key: key);

  @override
  State<CheckboxBasicExample> createState() => _CheckboxBasicExampleState();
}

class _CheckboxBasicExampleState extends State<CheckboxBasicExample> {
  bool? _checked = false;
  bool _indeterminate = false;

  void _onChanged(bool? value) {
    setState(() {
      if (_indeterminate) {
        _checked = false;
        _indeterminate = false;
      } else {
        _checked = value;
      }
    });
  }

  void _toggleIndeterminate() {
    setState(() {
      _indeterminate = !_indeterminate;
      if (_indeterminate) {
        _checked = null;
      } else {
        _checked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simple checkbox with label
        MinimalCheckbox(
          value: _checked,
          onChanged: _onChanged,
          label: 'Accept terms and conditions',
        ),
        const SizedBox(height: 16),

        // Checkbox with description
        MinimalCheckbox(
          value: _checked,
          onChanged: _onChanged,
          label: 'Subscribe to newsletter',
          description:
              'We will send you updates about our products and services',
        ),
        const SizedBox(height: 16),

        // Checkbox showing required field
        MinimalCheckbox(
          value: _checked,
          onChanged: _onChanged,
          label: 'I agree to the privacy policy',
          required: true,
        ),
        const SizedBox(height: 16),

        // Button to toggle indeterminate state
        ElevatedButton(
          onPressed: _toggleIndeterminate,
          child: Text(
            _indeterminate ? 'Clear indeterminate' : 'Set indeterminate',
          ),
        ),
      ],
    );
  }
}
