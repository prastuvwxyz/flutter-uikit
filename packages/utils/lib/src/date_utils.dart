import 'package:intl/intl.dart';

/// Utility functions for date and time operations
class DateUtils {
  static final DateFormat _defaultFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  /// Format a DateTime to a standard date string
  static String formatDate(DateTime date) {
    return _defaultFormat.format(date);
  }

  /// Format a DateTime to a display-friendly string
  static String formatDisplayDate(DateTime date) {
    return _displayFormat.format(date);
  }

  /// Format a DateTime to time string
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Get the difference in days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
