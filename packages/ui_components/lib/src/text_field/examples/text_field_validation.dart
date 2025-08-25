import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example demonstrating form validation with MinimalTextField
class TextFieldValidationExample extends StatefulWidget {
  /// Constructor
  const TextFieldValidationExample({Key? key}) : super(key: key);

  @override
  State<TextFieldValidationExample> createState() =>
      _TextFieldValidationExampleState();
}

class _TextFieldValidationExampleState
    extends State<TextFieldValidationExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field with required validation
            MinimalTextField(
              controller: _nameController,
              label: 'Full Name',
              placeholder: 'Enter your full name',
              required: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                if (value.split(' ').length < 2) {
                  return 'Please enter your full name (first and last)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email field with email validation
            MinimalTextField(
              controller: _emailController,
              type: TextFieldType.email,
              label: 'Email Address',
              placeholder: 'example@email.com',
              required: true,
              validator: (value) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password field with strength validation
            MinimalTextField(
              controller: _passwordController,
              type: TextFieldType.password,
              label: 'Password',
              placeholder: 'Create a password',
              required: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
                bool hasDigits = value.contains(RegExp(r'[0-9]'));
                bool hasSpecialChars = value.contains(
                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                );

                if (!(hasUppercase && hasDigits && hasSpecialChars)) {
                  return 'Password must include uppercase, number, and special character';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Confirm password field
            MinimalTextField(
              controller: _confirmPasswordController,
              type: TextFieldType.password,
              label: 'Confirm Password',
              placeholder: 'Confirm your password',
              required: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(onPressed: _submitForm, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
