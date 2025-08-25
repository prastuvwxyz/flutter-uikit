import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a multi-select dropdown
class MultiSelectExample extends StatefulWidget {
  /// Creates a multi-select example
  const MultiSelectExample({super.key});

  @override
  State<MultiSelectExample> createState() => _MultiSelectExampleState();
}

class _MultiSelectExampleState extends State<MultiSelectExample> {
  List<String> _selectedValues = [];

  final List<SelectOption<String>> _options = [
    const SelectOption(label: 'Apple', value: 'apple'),
    const SelectOption(label: 'Banana', value: 'banana'),
    const SelectOption(label: 'Cherry', value: 'cherry'),
    const SelectOption(label: 'Date', value: 'date'),
    const SelectOption(label: 'Elderberry', value: 'elderberry'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MinimalSelect<String>(
            label: 'Multi Select',
            placeholder: 'Select fruits',
            multiple: true,
            options: _options,
            value: _selectedValues,
            onChanged: (value) {
              setState(() {
                _selectedValues = List<String>.from(value);
              });
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Selected values: ${_selectedValues.isEmpty ? 'none' : _selectedValues.join(', ')}',
          ),
        ],
      ),
    );
  }
}
