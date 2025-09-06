enum CalendarView { month, week, day, agenda }

extension CalendarViewExtension on CalendarView {
  String get name => toString().split('.').last;
}
