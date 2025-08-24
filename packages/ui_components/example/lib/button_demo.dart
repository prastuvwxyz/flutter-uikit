import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';
import '../../lib/src/button/minimal_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MinimalButton Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        extensions: [
          UiTokens.standard(),
        ],
      ),
      home: const ButtonDemoScreen(),
    );
  }
}

class ButtonDemoScreen extends StatefulWidget {
  const ButtonDemoScreen({super.key});

  @override
  State<ButtonDemoScreen> createState() => _ButtonDemoScreenState();
}

class _ButtonDemoScreenState extends State<ButtonDemoScreen> {
  bool _isLoading = false;
  
  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MinimalButton Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Primary Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                MinimalButton(
                  onPressed: () {},
                  variant: ButtonVariant.primary,
                  size: ButtonSize.sm,
                  child: const Text('Small'),
                ),
                MinimalButton(
                  onPressed: () {},
                  variant: ButtonVariant.primary,
                  child: const Text('Medium'),
                ),
                MinimalButton(
                  onPressed: () {},
                  variant: ButtonVariant.primary,
                  size: ButtonSize.lg,
                  child: const Text('Large'),
                ),
                const MinimalButton(
                  onPressed: null,
                  variant: ButtonVariant.primary,
                  child: Text('Disabled'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text('Secondary Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                MinimalButton(
                  onPressed: () {},
                  variant: ButtonVariant.secondary,
                  child: const Text('Secondary'),
                ),
                const MinimalButton(
                  onPressed: null,
                  variant: ButtonVariant.secondary,
                  child: Text('Disabled'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text('Danger Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                MinimalButton(
                  onPressed: () {},
                  variant: ButtonVariant.danger,
                  child: const Text('Danger'),
                ),
                const MinimalButton(
                  onPressed: null,
                  variant: ButtonVariant.danger,
                  child: Text('Disabled'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text('Ghost Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                MinimalButton(
                  onPressed: () {},
                  variant: ButtonVariant.ghost,
                  child: const Text('Ghost'),
                ),
                const MinimalButton(
                  onPressed: null,
                  variant: ButtonVariant.ghost,
                  child: Text('Disabled'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text('With Icons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                MinimalButton(
                  onPressed: () {},
                  leading: const Icon(Icons.add),
                  child: const Text('Leading Icon'),
                ),
                MinimalButton(
                  onPressed: () {},
                  trailing: const Icon(Icons.arrow_forward),
                  child: const Text('Trailing Icon'),
                ),
                MinimalButton(
                  onPressed: () {},
                  leading: const Icon(Icons.star),
                  trailing: const Icon(Icons.star),
                  child: const Text('Both Icons'),
                ),
                MinimalButton(
                  onPressed: () {},
                  leading: const Icon(Icons.favorite),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text('Loading States', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                MinimalButton(
                  onPressed: _toggleLoading,
                  isLoading: _isLoading,
                  child: Text(_isLoading ? 'Loading...' : 'Click to Load'),
                ),
                MinimalButton(
                  onPressed: () {},
                  variant: ButtonVariant.secondary,
                  isLoading: true,
                  child: const Text('Always Loading'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text('Full Width Button', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            MinimalButton(
              onPressed: () {},
              fullWidth: true,
              child: const Text('Full Width Button'),
            ),
          ],
        ),
      ),
    );
  }
}
