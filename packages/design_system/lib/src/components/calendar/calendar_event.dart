class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final bool allDay;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.allDay = false,
  });

  @override
  String toString() => 'CalendarEvent($id, $title, $start -> $end)';
}
