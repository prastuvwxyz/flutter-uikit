import 'package:flutter/material.dart';
import '../../../../packages/ui_components/lib/src/radio_group/minimal_radio_group.dart';
import '../../../../packages/ui_components/lib/src/radio_group/radio_option.dart';

class RadioHorizontalExample extends StatefulWidget {
  const RadioHorizontalExample({Key? key}) : super(key: key);

  @override
  State<RadioHorizontalExample> createState() => _RadioHorizontalExampleState();
}

class _RadioHorizontalExampleState extends State<RadioHorizontalExample> {
  int? _value = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Horizontal RadioGroup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MinimalRadioGroup<int>(
          label: 'Numbers',
          direction: RadioDirection.horizontal,
          spacing: 12,
          options: const [
            RadioOption(value: 1, label: 'One'),
            RadioOption(value: 2, label: 'Two'),
            RadioOption(value: 3, label: 'Three'),
          ],
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}
