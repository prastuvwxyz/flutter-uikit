import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example showing different states of the MinimalCheckbox
class CheckboxStatesExample extends StatefulWidget {
  /// Creates a CheckboxStatesExample widget
  const CheckboxStatesExample({Key? key}) : super(key: key);

  @override
  State<CheckboxStatesExample> createState() => _CheckboxStatesExampleState();
}

class _CheckboxStatesExampleState extends State<CheckboxStatesExample> {
  bool _checked = true;

  void _onChanged(bool? value) {
    setState(() {
      _checked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checkbox States',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Unchecked
          const MinimalCheckbox(value: false, label: 'Unchecked state'),
          const SizedBox(height: 8),

          // Checked
          MinimalCheckbox(
            value: true,
            onChanged: _onChanged,
            label: 'Checked state',
          ),
          const SizedBox(height: 8),

          // Indeterminate
          const MinimalCheckbox(
            value: null,
            onChanged: null,
            label: 'Indeterminate state (also disabled)',
          ),
          const SizedBox(height: 8),

          // Disabled unchecked
          const MinimalCheckbox(
            value: false,
            onChanged: null,
            label: 'Disabled unchecked state',
          ),
          const SizedBox(height: 8),

          // Disabled checked
          const MinimalCheckbox(
            value: true,
            onChanged: null,
            label: 'Disabled checked state',
          ),
          const SizedBox(height: 8),

          // Error state
          MinimalCheckbox(
            value: _checked,
            onChanged: _onChanged,
            label: 'Error state',
            error: 'This field has an error',
          ),
          const SizedBox(height: 16),

          const Text(
            'Checkbox Sizes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Small size
          MinimalCheckbox(
            value: _checked,
            onChanged: _onChanged,
            label: 'Small checkbox',
            size: CheckboxSize.sm,
          ),
          const SizedBox(height: 8),

          // Medium size
          MinimalCheckbox(
            value: _checked,
            onChanged: _onChanged,
            label: 'Medium checkbox (default)',
            size: CheckboxSize.md,
          ),
          const SizedBox(height: 8),

          // Large size
          MinimalCheckbox(
            value: _checked,
            onChanged: _onChanged,
            label: 'Large checkbox',
            size: CheckboxSize.lg,
          ),
          const SizedBox(height: 16),

          const Text(
            'Label Positions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Label right (default)
          MinimalCheckbox(
            value: _checked,
            onChanged: _onChanged,
            label: 'Label on the right (default)',
            labelPosition: CheckboxLabelPosition.right,
          ),
          const SizedBox(height: 8),

          // Label left
          MinimalCheckbox(
            value: _checked,
            onChanged: _onChanged,
            label: 'Label on the left',
            labelPosition: CheckboxLabelPosition.left,
          ),
          const SizedBox(height: 8),

          // Label top
          MinimalCheckbox(
            value: _checked,
            onChanged: _onChanged,
            label: 'Label on top',
            labelPosition: CheckboxLabelPosition.top,
          ),
          const SizedBox(height: 8),

          // Label bottom
          MinimalCheckbox(
            value: _checked,
            onChanged: _onChanged,
            label: 'Label on bottom',
            labelPosition: CheckboxLabelPosition.bottom,
          ),
        ],
      ),
    );
  }
}
