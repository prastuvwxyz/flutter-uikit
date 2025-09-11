MinimalCalendar
================

Basic month view calendar used for examples and tests.

Usage:

Import and place in your widget tree:

```dart
import 'package:ui_components/src/calendar/minimal_calendar.dart';

MinimalCalendar(
  selectedDate: DateTime.now(),
  events: [],
  onDateSelected: (d) => print('selected $d'),
)
```

This implementation currently provides a basic month grid, date selection, long-press, and simple event rendering. It follows the API described in the task story but omits advanced views and features until needed.
