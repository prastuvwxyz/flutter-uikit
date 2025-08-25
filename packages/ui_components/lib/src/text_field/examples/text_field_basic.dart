import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a basic MinimalTextField
class BasicTextFieldExample extends StatelessWidget {
  /// Constructor
  const BasicTextFieldExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Text Field
          const MinimalTextField(
            label: 'Name',
            placeholder: 'Enter your name',
            helperText: 'Your full name',
          ),
          const SizedBox(height: 16),

          // Email Field with validation
          MinimalTextField(
            type: TextFieldType.email,
            label: 'Email',
            placeholder: 'example@email.com',
            helperText: 'Your email address',
            leading: const Icon(Icons.email_outlined),
            validator: (value) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!emailRegex.hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
            required: true,
          ),
          const SizedBox(height: 16),

          // Password Field
          const MinimalTextField(
            type: TextFieldType.password,
            label: 'Password',
            placeholder: 'Enter your password',
            leading: Icon(Icons.lock_outlined),
            maxLength: 20,
          ),
          const SizedBox(height: 16),

          // Number Field
          const MinimalTextField(
            type: TextFieldType.number,
            label: 'Age',
            placeholder: 'Enter your age',
            leading: Icon(Icons.numbers),
            maxLength: 3,
          ),
          const SizedBox(height: 16),

          // Disabled Field
          const MinimalTextField(
            label: 'Company',
            placeholder: 'Enter company name',
            helperText: 'This field is disabled',
            enabled: false,
          ),
          const SizedBox(height: 16),

          // Error State Field
          const MinimalTextField(
            label: 'Username',
            placeholder: 'Enter username',
            errorText: 'This username is already taken',
          ),
          const SizedBox(height: 16),

          // Multiline Field
          const MinimalTextField(
            label: 'Biography',
            placeholder: 'Tell us about yourself',
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
