import 'package:flutter/widgets.dart';

/// Simple data model representing a timeline event.
class TimelineItem {
  final Widget? leading; // optional icon/avatar for the event
  final Widget content; // main content of the event
  final DateTime? timestamp;
  final String? status; // optional status like active/completed

  TimelineItem({
    this.leading,
    required this.content,
    this.timestamp,
    this.status,
  });
}
