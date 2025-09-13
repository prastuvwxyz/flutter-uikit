import 'package:flutter/material.dart';
import '../widgets/card.dart' as ui_card;
import '../widgets/text_field.dart' as ui_field;
import '../widgets/button.dart' as ui_button;

class AuthForm extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onForgotPassword;
  final bool showForgotPassword;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function(String email, String password) onSignIn;
  final Future<void> Function(String email)? onResetPassword;
  final VoidCallback? onClearError;
  final String? defaultEmail;
  final String? defaultPassword;
  final bool showDemoCredentials;

  const AuthForm({
    super.key,
    this.icon = Icons.speed,
    this.title = 'Sign In',
    this.subtitle = 'Please enter your credentials to continue',
    this.onForgotPassword,
    this.showForgotPassword = true,
    this.isLoading = false,
    this.errorMessage,
    required this.onSignIn,
    this.onResetPassword,
    this.onClearError,
    this.defaultEmail,
    this.defaultPassword,
    this.showDemoCredentials = true,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with provided credentials
    _emailController.text = widget.defaultEmail ?? '';
    _passwordController.text = widget.defaultPassword ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message when provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: widget.onClearError != null
                ? SnackBarAction(
                    label: 'Dismiss',
                    onPressed: widget.onClearError!,
                  )
                : null,
          ),
        );
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        // Make the form responsive based on available space
        final isSmallScreen =
            constraints.maxHeight < 600 || constraints.maxWidth < 500;
        final padding = isSmallScreen ? 16.0 : 32.0;
        final spacing = isSmallScreen ? 16.0 : 24.0;
        final headerSpacing = isSmallScreen ? 24.0 : 32.0;

        return ui_card.Card(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.9,
              maxWidth: constraints.maxWidth * 0.9,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    SizedBox(height: headerSpacing),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    SizedBox(height: spacing),
                    _buildSignInButton(),
                    if (widget.showForgotPassword) ...[
                      const SizedBox(height: 16),
                      _buildForgotPasswordButton(),
                    ],
                    if (widget.showDemoCredentials &&
                        widget.defaultEmail != null &&
                        widget.defaultPassword != null) ...[
                      SizedBox(height: spacing),
                      _buildDemoCredentials(),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          widget.icon,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return ui_field.TextField.email(
      label: 'Email',
      controller: _emailController,
      enabled: !widget.isLoading,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return ui_field.TextField.password(
      label: 'Password',
      controller: _passwordController,
      enabled: !widget.isLoading,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSignInButton() {
    return ui_button.Button.primary(
      onPressed: widget.isLoading ? null : _handleSignIn,
      child: widget.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text('Sign In'),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: widget.onForgotPassword ?? _handleForgotPassword,
      child: const Text('Forgot Password?'),
    );
  }

  Widget _buildDemoCredentials() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Demo Credentials',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${widget.defaultEmail}\nPassword: ${widget.defaultPassword}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.onSignIn(_emailController.text.trim(), _passwordController.text);
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => _ForgotPasswordDialog(
        onResetPassword: widget.onResetPassword ?? (email) async {},
      ),
    );
  }
}

class _ForgotPasswordDialog extends StatefulWidget {
  final Future<void> Function(String email) onResetPassword;

  const _ForgotPasswordDialog({required this.onResetPassword});

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your email address and we\'ll send you instructions to reset your password.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ui_field.TextField.email(
              label: 'Email',
              controller: _emailController,
              enabled: !_isLoading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ui_button.Button.primary(
          onPressed: _isLoading ? null : _handleReset,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send Reset Link'),
        ),
      ],
    );
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widget.onResetPassword(_emailController.text.trim());
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset instructions sent to your email'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}