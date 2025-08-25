import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Multi-select dropdown example screen
class SelectMulti extends StatefulWidget {
  /// Creates a multi-select example screen
  const SelectMulti({super.key});

  @override
  State<SelectMulti> createState() => _SelectMultiState();
}

class _SelectMultiState extends State<SelectMulti> {
  List<String> _selectedValues = [];

  final List<SelectOption<String>> _fruitOptions = [
    const SelectOption(
      label: 'Apple',
      value: 'apple',
      leading: Icon(Icons.apple, size: 16),
    ),
    const SelectOption(
      label: 'Banana',
      value: 'banana',
      leading: Icon(Icons.emoji_food_beverage, size: 16),
    ),
    const SelectOption(label: 'Cherry', value: 'cherry'),
    const SelectOption(label: 'Date', value: 'date'),
    const SelectOption(label: 'Elderberry', value: 'elderberry'),
    const SelectOption(label: 'Fig', value: 'fig'),
    const SelectOption(label: 'Grape', value: 'grape'),
    const SelectOption(label: 'Honeydew', value: 'honeydew'),
  ];

  final List<String> _tagOptions = [
    'Urgent',
    'Important',
    'Review',
    'Feedback',
    'Bug',
    'Feature',
    'Enhancement',
    'Documentation',
    'Design',
    'Testing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Select')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MinimalSelect<String>(
              label: 'Favorite Fruits',
              placeholder: 'Select fruits',
              multiple: true,
              options: _fruitOptions,
              value: _selectedValues,
              onChanged: (value) {
                setState(() {
                  _selectedValues = List<String>.from(value);
                });
              },
            ),
            const SizedBox(height: 32),

            MinimalSelect<String>(
              label: 'Tags',
              placeholder: 'Select tags',
              multiple: true,
              options: _tagOptions
                  .map(
                    (tag) => SelectOption<String>(
                      label: tag,
                      value: tag.toLowerCase(),
                    ),
                  )
                  .toList(),
              value: const [],
            ),
            const SizedBox(height: 32),

            MinimalSelect<String>(
              label: 'Required Selection',
              placeholder: 'Select at least one',
              errorText: _selectedValues.isEmpty
                  ? 'Please select at least one option'
                  : null,
              multiple: true,
              required: true,
              options: _fruitOptions,
              value: _selectedValues,
              onChanged: (value) {
                setState(() {
                  _selectedValues = List<String>.from(value);
                });
              },
            ),
            const SizedBox(height: 32),

            Text(
              'Selected fruits: ${_selectedValues.isEmpty ? 'none' : _selectedValues.join(', ')}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
