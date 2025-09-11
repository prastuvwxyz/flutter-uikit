import 'package:flutter/material.dart';
import 'calendar_view.dart';
import 'calendar_event.dart';

typedef EventBuilder = Widget Function(CalendarEvent event);

class MinimalCalendar extends StatefulWidget {
  final CalendarView view;
  final DateTime selectedDate;
  final List<CalendarEvent> events;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<CalendarEvent>? onEventTap;
  final ValueChanged<DateTime>? onDateLongPress;
  final int firstDayOfWeek;
  final bool showWeekNumbers;
  final bool allowPastSelection;
  final DateTime? minDate;
  final DateTime? maxDate;
  final EventBuilder? eventBuilder;

  MinimalCalendar({
    Key? key,
    this.view = CalendarView.month,
    DateTime? selectedDate,
    this.events = const [],
    this.onDateSelected,
    this.onEventTap,
    this.onDateLongPress,
    this.firstDayOfWeek = 1,
    this.showWeekNumbers = false,
    this.allowPastSelection = true,
    this.minDate,
    this.maxDate,
    this.eventBuilder,
  }) : selectedDate = selectedDate ?? DateTime.now(),
       super(key: key);

  @override
  State<MinimalCalendar> createState() => _MinimalCalendarState();
}

class _MinimalCalendarState extends State<MinimalCalendar> {
  late DateTime _visibleMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final sd = widget.selectedDate;
    _selectedDate = DateTime(sd.year, sd.month, sd.day);
    _visibleMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _prevMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  bool _isSelectable(DateTime date) {
    if (!widget.allowPastSelection && date.isBefore(DateTime.now()))
      return false;
    if (widget.minDate != null && date.isBefore(widget.minDate!)) return false;
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) return false;
    return true;
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysBefore = (first.weekday - widget.firstDayOfWeek) % 7;
    final start = first.subtract(Duration(days: daysBefore));
    final last = DateTime(month.year, month.month + 1, 0);
    final daysAfter = (7 - last.weekday + widget.firstDayOfWeek) % 7;
    final end = last.add(Duration(days: daysAfter));
    final days = <DateTime>[];
    for (var d = start; !d.isAfter(end); d = d.add(Duration(days: 1))) {
      days.add(DateTime(d.year, d.month, d.day));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    // Only implement month view for now
    if (widget.view != CalendarView.month) {
      return Center(child: Text('View ${widget.view.name} not implemented'));
    }

    final days = _daysInMonth(_visibleMonth);
    // Slice days into weeks safely
    final weeks = <List<DateTime>>[];
    for (var i = 0; i < days.length; i += 7) {
      final end = (i + 7 <= days.length) ? i + 7 : days.length;
      weeks.add(days.sublist(i, end));
    }

    return Column(
      children: [
        _buildHeader(context),
        _buildWeekDays(context),
        Expanded(
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.4,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final inMonth = day.month == _visibleMonth.month;
              final isSelected =
                  day.year == _selectedDate.year &&
                  day.month == _selectedDate.month &&
                  day.day == _selectedDate.day;
              final selectable = _isSelectable(day);
              final dayEvents = widget.events.where((e) {
                final s = DateTime(e.start.year, e.start.month, e.start.day);
                final en = DateTime(e.end.year, e.end.month, e.end.day);
                return !(day.isBefore(s) || day.isAfter(en));
              }).toList();

              return GestureDetector(
                onTap: selectable
                    ? () {
                        setState(() => _selectedDate = day);
                        widget.onDateSelected?.call(day);
                      }
                    : null,
                onLongPress: selectable
                    ? () => widget.onDateLongPress?.call(day)
                    : null,
                child: Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: inMonth
                                ? Theme.of(context).textTheme.bodyMedium?.color
                                : Theme.of(context).disabledColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (dayEvents.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: dayEvents.take(2).map((e) {
                              final widgetEvent =
                                  widget.eventBuilder?.call(e) ??
                                  _defaultEventTile(e);
                              return GestureDetector(
                                onTap: () => widget.onEventTap?.call(e),
                                child: widgetEvent,
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _defaultEventTile(CalendarEvent e) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        e.title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final monthLabel =
        '${_visibleMonth.year}-${_visibleMonth.month.toString().padLeft(2, '0')}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: _prevMonth, icon: Icon(Icons.chevron_left)),
        Text(monthLabel, style: Theme.of(context).textTheme.titleLarge),
        IconButton(onPressed: _nextMonth, icon: Icon(Icons.chevron_right)),
      ],
    );
  }

  Widget _buildWeekDays(BuildContext context) {
    final weekdayLabels = <String>[];
    for (var i = 0; i < 7; i++) {
      final weekday = ((widget.firstDayOfWeek - 1 + i) % 7) + 1;
      weekdayLabels.add(
        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1],
      );
    }
    return Row(
      children: weekdayLabels
          .map(
            (l) => Expanded(
              child: Center(
                child: Text(l, style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
          )
          .toList(),
    );
  }
}
