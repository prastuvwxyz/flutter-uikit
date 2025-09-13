import 'package:flutter/material.dart';

/// A customizable calendar widget with month/week views and date selection
class Calendar extends StatefulWidget {
  /// Currently selected date
  final DateTime? selectedDate;

  /// Currently selected date range (for range selection)
  final DateRange? selectedRange;

  /// Callback when a date is selected
  final Function(DateTime date)? onDateSelected;

  /// Callback when a date range is selected
  final Function(DateRange range)? onRangeSelected;

  /// Selection mode (single, range, multiple)
  final CalendarSelectionMode selectionMode;

  /// Calendar view type (month, week, agenda)
  final CalendarViewType viewType;

  /// Minimum selectable date
  final DateTime? minDate;

  /// Maximum selectable date
  final DateTime? maxDate;

  /// Disabled dates
  final Set<DateTime> disabledDates;

  /// Special dates with custom styling
  final Map<DateTime, CalendarDateStyle> specialDates;

  /// Custom header builder
  final Widget Function(DateTime displayedMonth)? headerBuilder;

  /// Custom day builder
  final Widget Function(DateTime date, bool isSelected, bool isDisabled)? dayBuilder;

  /// Whether to show week numbers
  final bool showWeekNumbers;

  /// First day of week (0 = Sunday, 1 = Monday, etc.)
  final int firstDayOfWeek;

  /// Whether to show other month dates
  final bool showOtherMonthDates;

  /// Animation duration for view changes
  final Duration animationDuration;

  /// Initial date to display
  final DateTime initialDate;

  /// Multiple selected dates (for multiple selection mode)
  final Set<DateTime> selectedDates;

  /// Callback for multiple date selection
  final Function(Set<DateTime> dates)? onMultipleSelected;

  Calendar({
    super.key,
    this.selectedDate,
    this.selectedRange,
    this.onDateSelected,
    this.onRangeSelected,
    this.selectionMode = CalendarSelectionMode.single,
    this.viewType = CalendarViewType.month,
    this.minDate,
    this.maxDate,
    this.disabledDates = const {},
    this.specialDates = const {},
    this.headerBuilder,
    this.dayBuilder,
    this.showWeekNumbers = false,
    this.firstDayOfWeek = 0,
    this.showOtherMonthDates = true,
    this.animationDuration = const Duration(milliseconds: 200),
    DateTime? initialDate,
    this.selectedDates = const {},
    this.onMultipleSelected,
  }) : initialDate = initialDate ?? DateTime.now();

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with SingleTickerProviderStateMixin {
  late DateTime _displayedMonth;
  late PageController _pageController;
  late AnimationController _animationController;
  late Set<DateTime> _selectedDates;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
    _pageController = PageController(initialPage: 12000); // Start at middle for infinite scroll
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _selectedDates = Set<DateTime>.from(widget.selectedDates);

    if (widget.selectedRange != null) {
      _rangeStart = widget.selectedRange!.start;
      _rangeEnd = widget.selectedRange!.end;
    }
  }

  @override
  void didUpdateWidget(Calendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDates != widget.selectedDates) {
      _selectedDates = Set<DateTime>.from(widget.selectedDates);
    }
    if (oldWidget.selectedRange != widget.selectedRange) {
      if (widget.selectedRange != null) {
        _rangeStart = widget.selectedRange!.start;
        _rangeEnd = widget.selectedRange!.end;
      } else {
        _rangeStart = null;
        _rangeEnd = null;
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool _isDateDisabled(DateTime date) {
    if (widget.minDate != null && date.isBefore(widget.minDate!)) return true;
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) return true;
    return widget.disabledDates.contains(_dateOnly(date));
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isDateSelected(DateTime date) {
    final dateOnly = _dateOnly(date);

    switch (widget.selectionMode) {
      case CalendarSelectionMode.single:
        return widget.selectedDate != null &&
               _dateOnly(widget.selectedDate!) == dateOnly;
      case CalendarSelectionMode.multiple:
        return _selectedDates.contains(dateOnly);
      case CalendarSelectionMode.range:
        if (_rangeStart == null) return false;
        if (_rangeEnd == null) return _dateOnly(_rangeStart!) == dateOnly;
        return dateOnly.isAtSameMomentAs(_dateOnly(_rangeStart!)) ||
               dateOnly.isAtSameMomentAs(_dateOnly(_rangeEnd!)) ||
               (dateOnly.isAfter(_dateOnly(_rangeStart!)) &&
                dateOnly.isBefore(_dateOnly(_rangeEnd!)));
    }
  }

  void _onDateTapped(DateTime date) {
    if (_isDateDisabled(date)) return;

    setState(() {
      final dateOnly = _dateOnly(date);

      switch (widget.selectionMode) {
        case CalendarSelectionMode.single:
          widget.onDateSelected?.call(date);
          break;
        case CalendarSelectionMode.multiple:
          if (_selectedDates.contains(dateOnly)) {
            _selectedDates.remove(dateOnly);
          } else {
            _selectedDates.add(dateOnly);
          }
          widget.onMultipleSelected?.call(_selectedDates);
          break;
        case CalendarSelectionMode.range:
          if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
            // Start new range
            _rangeStart = dateOnly;
            _rangeEnd = null;
          } else {
            // Complete range
            if (dateOnly.isBefore(_rangeStart!)) {
              _rangeEnd = _rangeStart;
              _rangeStart = dateOnly;
            } else {
              _rangeEnd = dateOnly;
            }
            widget.onRangeSelected?.call(DateRange(start: _rangeStart!, end: _rangeEnd!));
          }
          break;
      }
    });
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);

    // Calculate the start of the calendar grid
    int daysFromMonday = (firstDay.weekday - widget.firstDayOfWeek) % 7;
    final startDate = firstDay.subtract(Duration(days: daysFromMonday));

    // Generate 42 days (6 weeks)
    return List.generate(42, (index) => startDate.add(Duration(days: index)));
  }

  Widget _buildHeader(DateTime month) {
    if (widget.headerBuilder != null) {
      return widget.headerBuilder!(month);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
              });
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Text(
              '${_monthNames[month.month - 1]} ${month.year}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
              });
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final reorderedWeekdays = [
      ...weekdays.sublist(widget.firstDayOfWeek),
      ...weekdays.sublist(0, widget.firstDayOfWeek)
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: reorderedWeekdays.map((day) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.center,
              child: Text(
                day,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isSelected = _isDateSelected(date);
    final isDisabled = _isDateDisabled(date);
    final isToday = _dateOnly(date) == _dateOnly(DateTime.now());
    final isOtherMonth = date.month != _displayedMonth.month;
    final specialStyle = widget.specialDates[_dateOnly(date)];

    if (widget.dayBuilder != null) {
      return widget.dayBuilder!(date, isSelected, isDisabled);
    }

    final theme = Theme.of(context);

    if (!widget.showOtherMonthDates && isOtherMonth) {
      return const SizedBox();
    }

    Color? backgroundColor;
    Color? textColor;

    if (isSelected) {
      backgroundColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onPrimary;
    } else if (isToday) {
      backgroundColor = theme.colorScheme.primary.withValues(alpha: 0.12);
      textColor = theme.colorScheme.primary;
    } else if (specialStyle?.backgroundColor != null) {
      backgroundColor = specialStyle!.backgroundColor;
      textColor = specialStyle.textColor;
    }

    if (isDisabled) {
      textColor = theme.colorScheme.onSurface.withValues(alpha: 0.38);
      backgroundColor = null;
    } else if (isOtherMonth) {
      textColor = theme.colorScheme.onSurface.withValues(alpha: 0.38);
    }

    return GestureDetector(
      onTap: () => _onDateTapped(date),
      child: Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: specialStyle?.borderColor != null
            ? Border.all(color: specialStyle!.borderColor!, width: 1)
            : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: isToday || isSelected ? FontWeight.w600 : null,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthView() {
    final days = _getDaysInMonth(_displayedMonth);

    return Column(
      children: [
        _buildHeader(_displayedMonth),
        _buildWeekdayHeaders(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) => _buildDayCell(days[index]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.viewType) {
      case CalendarViewType.month:
        return _buildMonthView();
      case CalendarViewType.week:
        // Simplified week view - can be expanded
        return _buildMonthView();
      case CalendarViewType.agenda:
        // Simplified agenda view - can be expanded
        return _buildMonthView();
    }
  }

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
}

/// Selection modes for the calendar
enum CalendarSelectionMode {
  single,
  multiple,
  range,
}

/// View types for the calendar
enum CalendarViewType {
  month,
  week,
  agenda,
}

/// Date range model
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({
    required this.start,
    required this.end,
  });

  Duration get duration => end.difference(start);

  bool contains(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day);

    return dateOnly.isAtSameMomentAs(startOnly) ||
           dateOnly.isAtSameMomentAs(endOnly) ||
           (dateOnly.isAfter(startOnly) && dateOnly.isBefore(endOnly));
  }

  @override
  bool operator ==(Object other) {
    return other is DateRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  @override
  String toString() => 'DateRange(start: $start, end: $end)';
}

/// Style configuration for special dates
class CalendarDateStyle {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final String? label;

  const CalendarDateStyle({
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.label,
  });
}

/// Pre-built calendar configurations
class CalendarPresets {
  /// Simple date picker calendar
  static Calendar datePicker({
    DateTime? selectedDate,
    Function(DateTime)? onDateSelected,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? initialDate,
  }) {
    return Calendar(
      selectedDate: selectedDate,
      onDateSelected: onDateSelected,
      minDate: minDate,
      maxDate: maxDate,
      initialDate: initialDate ?? DateTime.now(),
      selectionMode: CalendarSelectionMode.single,
    );
  }

  /// Date range picker calendar
  static Calendar rangePicker({
    DateRange? selectedRange,
    Function(DateRange)? onRangeSelected,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? initialDate,
  }) {
    return Calendar(
      selectedRange: selectedRange,
      onRangeSelected: onRangeSelected,
      minDate: minDate,
      maxDate: maxDate,
      initialDate: initialDate ?? DateTime.now(),
      selectionMode: CalendarSelectionMode.range,
    );
  }

  /// Event calendar with special dates
  static Calendar eventCalendar({
    DateTime? selectedDate,
    Function(DateTime)? onDateSelected,
    Map<DateTime, CalendarDateStyle> specialDates = const {},
    DateTime? initialDate,
  }) {
    return Calendar(
      selectedDate: selectedDate,
      onDateSelected: onDateSelected,
      specialDates: specialDates,
      initialDate: initialDate ?? DateTime.now(),
      selectionMode: CalendarSelectionMode.single,
      showWeekNumbers: true,
    );
  }
}

/// Extension for DateTime convenience methods
extension CalendarDateTimeExtension on DateTime {
  /// Get date without time component
  DateTime get dateOnly => DateTime(year, month, day);

  /// Check if this date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if this date is in the same month as another date
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Get the first day of the month for this date
  DateTime get firstDayOfMonth => DateTime(year, month, 1);

  /// Get the last day of the month for this date
  DateTime get lastDayOfMonth => DateTime(year, month + 1, 0);
}