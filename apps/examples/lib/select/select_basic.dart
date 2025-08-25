import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Basic select dropdown example screen
class SelectBasic extends StatefulWidget {
  /// Creates a basic select example screen
  const SelectBasic({super.key});

  @override
  State<SelectBasic> createState() => _SelectBasicState();
}

class _SelectBasicState extends State<SelectBasic> {
  String? _selectedValue;

  final List<SelectOption<String>> _options = [
    const SelectOption(label: 'Option 1', value: 'option1'),
    const SelectOption(label: 'Option 2', value: 'option2'),
    const SelectOption(label: 'Option 3', value: 'option3'),
    const SelectOption(
      label: 'Option 4',
      value: 'option4',
      leading: Icon(Icons.star, size: 16),
    ),
    const SelectOption(label: 'Option 5', value: 'option5'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Select')),
      body: Padding(
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
            const SizedBox(height: 32),

            MinimalSelect<String>(
              label: 'With Helper Text',
              helperText: 'This is a helper text',
              placeholder: 'Choose an option',
              options: _options,
              value: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const SizedBox(height: 32),

            MinimalSelect<String>(
              label: 'With Error State',
              errorText: 'This field is required',
              placeholder: 'Choose an option',
              options: _options,
              value: _selectedValue,
              required: true,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const SizedBox(height: 32),

            MinimalSelect<String>(
              label: 'Disabled Select',
              placeholder: 'Cannot interact',
              options: _options,
              value: _selectedValue,
              enabled: false,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const SizedBox(height: 32),

            Text(
              'Selected value: ${_selectedValue ?? 'none'}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
