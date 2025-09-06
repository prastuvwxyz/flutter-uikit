import 'package:flutter/material.dart';
import '../../../../packages/ui_components/lib/src/radio_group/minimal_radio_group.dart';
import '../../../../packages/ui_components/lib/src/radio_group/radio_option.dart';

class RadioDescriptionsExample extends StatefulWidget {
  const RadioDescriptionsExample({Key? key}) : super(key: key);

  @override
  State<RadioDescriptionsExample> createState() =>
      _RadioDescriptionsExampleState();
}

class _RadioDescriptionsExampleState extends State<RadioDescriptionsExample> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Radio with descriptions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MinimalRadioGroup<String>(
          label: 'Plans',
          options: const [
            RadioOption(
              value: 'free',
              label: 'Free',
              description: 'Basic access with limits',
            ),
            RadioOption(
              value: 'pro',
              label: 'Pro',
              description: 'Advanced features and support',
            ),
            RadioOption(
              value: 'enterprise',
              label: 'Enterprise',
              description: 'Custom solutions',
            ),
          ],
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}
