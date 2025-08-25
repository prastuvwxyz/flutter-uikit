import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'package:ui_components/ui_components.dart';
import 'token_extensions.dart';

void main() {
  runApp(const MinimalUIKitDemo());
}

class MinimalUIKitDemo extends StatelessWidget {
  const MinimalUIKitDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal Flutter UI Kit Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        extensions: [UiTokens.standard()],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        extensions: [UiTokens.standard()],
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  bool isLoading = false;

  void _toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minimal UI Kit Demo'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Minimal UI Kit - Button Components',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: MinimalColors.of(context).onSurface,
              ),
            ),
            MinimalSpacing.mdVertical,
            Text(
              'A comprehensive Flutter UI Kit with 60+ production-ready components '
              'following Material Design 3 principles.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: MinimalColors.of(context).onSurfaceVariant,
              ),
            ),
            MinimalSpacing.xlVertical,

            // Button Examples Section
            Text(
              'Button Components',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            MinimalSpacing.mdVertical,

            // Button Variants
            _buildButtonShowcase(),
            MinimalSpacing.xlVertical,

            // Button Sizes
            Text(
              'Button Sizes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            MinimalSpacing.mdVertical,
            _buildButtonSizes(),
            MinimalSpacing.xlVertical,

            // Loading States
            Text(
              'Loading States',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            MinimalSpacing.mdVertical,
            _buildLoadingStates(),
            MinimalSpacing.xlVertical,

            // Color System
            Text(
              'Color System',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            MinimalSpacing.mdVertical,
            _buildColorPalette(),
            MinimalSpacing.xlVertical,

            // Typography
            Text(
              'Typography Scale',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            MinimalSpacing.mdVertical,
            _buildTypographyExamples(),
            MinimalSpacing.xlVertical,

            // Spacing System
            Text(
              'Spacing System',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            MinimalSpacing.mdVertical,
            _buildSpacingExamples(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Minimal UI Kit is awesome! 🚀')),
          );
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }

  Widget _buildButtonShowcase() {
    return Wrap(
      spacing: MinimalSpacing.md,
      runSpacing: MinimalSpacing.md,
      children: [
        MinimalButton(
          variant: ButtonVariant.primary,
          onPressed: () {},
          child: const Text('Primary'),
        ),
        MinimalButton(
          variant: ButtonVariant.secondary,
          onPressed: () {},
          child: const Text('Secondary'),
        ),
        MinimalButton(
          variant: ButtonVariant.danger,
          onPressed: () {},
          child: const Text('Danger'),
        ),
        MinimalButton(
          variant: ButtonVariant.ghost,
          onPressed: () {},
          child: const Text('Ghost'),
        ),
        MinimalButton(
          variant: ButtonVariant.primary,
          leading: const Icon(Icons.add, size: 18),
          onPressed: () {},
          child: const Text('With Icon'),
        ),
      ],
    );
  }

  Widget _buildButtonSizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MinimalButton(
              onPressed: () {},
              size: ButtonSize.sm,
              child: const Text('Small'),
            ),
            MinimalSpacing.mdHorizontal,
            MinimalButton(
              onPressed: () {},
              size: ButtonSize.md,
              child: const Text('Medium'),
            ),
            MinimalSpacing.mdHorizontal,
            MinimalButton(
              onPressed: () {},
              size: ButtonSize.lg,
              child: const Text('Large'),
            ),
          ],
        ),
        MinimalSpacing.mdVertical,
        MinimalButton(
          onPressed: () {},
          fullWidth: true,
          child: const Text('Full Width Button'),
        ),
      ],
    );
  }

  Widget _buildLoadingStates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MinimalButton(
              variant: ButtonVariant.primary,
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() {
                        isLoading = true;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
              isLoading: isLoading,
              child: const Text('Submit'),
            ),
            MinimalSpacing.mdHorizontal,
            MinimalButton(
              variant: ButtonVariant.secondary,
              onPressed: () {},
              isLoading: true,
              child: const Text('Loading'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorPalette() {
    final colors = MinimalColors.of(context);
    return Wrap(
      spacing: MinimalSpacing.sm,
      runSpacing: MinimalSpacing.sm,
      children: [
        _buildColorSwatch('Primary', colors.primary),
        _buildColorSwatch('Secondary', colors.secondary),
        _buildColorSwatch('Tertiary', colors.tertiary),
        _buildColorSwatch('Error', colors.error),
        _buildColorSwatch('Surface', colors.surface),
        _buildColorSwatch('Outline', colors.outline),
      ],
    );
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: MinimalColors.of(context).outline.withValues(alpha: 0.2),
            ),
          ),
        ),
        MinimalSpacing.xsVertical,
        Text(name, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildTypographyExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: Theme.of(context).textTheme.displayLarge),
        Text(
          'Headline Large',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
        Text(
          'Body Large - This is the standard body text used throughout the application.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          'Body Medium - A slightly smaller body text for secondary content.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          'Label Large - Used for buttons and call-to-action text.',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }

  Widget _buildSpacingExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(MinimalSpacing.xs),
          color: MinimalColors.of(context).surfaceContainerHighest,
          child: const Text('XS Padding (4px)'),
        ),
        MinimalSpacing.xsVertical,
        Container(
          padding: const EdgeInsets.all(MinimalSpacing.sm),
          color: MinimalColors.of(context).surfaceContainerHighest,
          child: const Text('SM Padding (8px)'),
        ),
        MinimalSpacing.xsVertical,
        Container(
          padding: const EdgeInsets.all(MinimalSpacing.md),
          color: MinimalColors.of(context).surfaceContainerHighest,
          child: const Text('MD Padding (16px)'),
        ),
        MinimalSpacing.xsVertical,
        Container(
          padding: const EdgeInsets.all(MinimalSpacing.lg),
          color: MinimalColors.of(context).surfaceContainerHighest,
          child: const Text('LG Padding (24px)'),
        ),
      ],
    );
  }
}
