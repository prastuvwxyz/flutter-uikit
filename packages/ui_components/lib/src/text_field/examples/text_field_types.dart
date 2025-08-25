import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example demonstrating different field types of MinimalTextField
class TextFieldTypesExample extends StatefulWidget {
  /// Constructor
  const TextFieldTypesExample({Key? key}) : super(key: key);

  @override
  State<TextFieldTypesExample> createState() => _TextFieldTypesExampleState();
}

class _TextFieldTypesExampleState extends State<TextFieldTypesExample> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Standard text field
          const MinimalTextField(
            type: TextFieldType.text,
            label: 'Standard Text',
            placeholder: 'Enter any text',
            leading: Icon(Icons.text_fields),
          ),
          const SizedBox(height: 16),

          // Email field
          const MinimalTextField(
            type: TextFieldType.email,
            label: 'Email',
            placeholder: 'your@email.com',
            leading: Icon(Icons.email_outlined),
          ),
          const SizedBox(height: 16),

          // Password field
          const MinimalTextField(
            type: TextFieldType.password,
            label: 'Password',
            placeholder: 'Enter password',
            leading: Icon(Icons.lock_outlined),
            helperText: 'Password shows visibility toggle icon',
          ),
          const SizedBox(height: 16),

          // Number field
          const MinimalTextField(
            type: TextFieldType.number,
            label: 'Number',
            placeholder: '123',
            leading: Icon(Icons.numbers),
            helperText: 'Only accepts numerical input',
          ),
          const SizedBox(height: 16),

          // Search field
          MinimalTextField(
            type: TextFieldType.search,
            label: 'Search',
            placeholder: 'Search for something',
            leading: const Icon(Icons.search),
            trailing: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onSubmitted: (value) {
              // Handle search submit
              debugPrint('Search for: $value');
            },
          ),
          const SizedBox(height: 16),

          // Multiline text field
          const MinimalTextField(
            type: TextFieldType.text,
            label: 'Multiline Text',
            placeholder: 'Enter multiple lines of text',
            maxLines: 3,
            helperText: 'This field can have multiple lines',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
