# MinimalAccordion

A lightweight accordion widget for the UI components package.

Usage:

```dart
import 'package:ui_components/ui_components.dart';

MinimalAccordion(
  children: [
    MinimalAccordionPanel(
      headerBuilder: (context, isExpanded) => Text('Section 1'),
      bodyBuilder: (context) => Padding(
        padding: EdgeInsets.all(16),
        child: Text('Content for section 1'),
      ),
    ),
  ],
)
```
