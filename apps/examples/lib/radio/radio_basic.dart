import 'package:flutter/material.dart';
import '../../../../packages/ui_components/lib/src/radio_group/minimal_radio_group.dart';
import '../../../../packages/ui_components/lib/src/radio_group/radio_option.dart';

class RadioBasicExample extends StatefulWidget {
  const RadioBasicExample({Key? key}) : super(key: key);

  @override
  State<RadioBasicExample> createState() => _RadioBasicExampleState();
}

class _RadioBasicExampleState extends State<RadioBasicExample> {
  String? _value = 'a';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Basic RadioGroup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MinimalRadioGroup<String>(
          label: 'Choose an option',
          description: 'Pick one of the following',
          required: true,
          options: const [
            RadioOption(value: 'a', label: 'Option A'),
            RadioOption(value: 'b', label: 'Option B'),
            RadioOption(value: 'c', label: 'Option C'),
          ],
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}
