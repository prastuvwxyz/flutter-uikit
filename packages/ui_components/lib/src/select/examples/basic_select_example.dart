import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a basic select dropdown
class BasicSelectExample extends StatefulWidget {
  /// Creates a basic select example
  const BasicSelectExample({super.key});

  @override
  State<BasicSelectExample> createState() => _BasicSelectExampleState();
}

class _BasicSelectExampleState extends State<BasicSelectExample> {
  String? _selectedValue;

  final List<SelectOption<String>> _options = [
    const SelectOption(label: 'Option 1', value: 'option1'),
    const SelectOption(label: 'Option 2', value: 'option2'),
    const SelectOption(label: 'Option 3', value: 'option3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MinimalSelect<String>(
            label: 'Basic Select',
            placeholder: 'Choose an option',
            options: _options,
            value: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Text('Selected value: ${_selectedValue ?? 'none'}'),
        ],
      ),
    );
  }
}
