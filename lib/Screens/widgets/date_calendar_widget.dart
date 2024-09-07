import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateCalendarWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime?, DateTime?, DateTime) onRangeSelected;
  final CalendarFormat calendarFormat;
  final RangeSelectionMode rangeSelectionMode;

  const DateCalendarWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onRangeSelected,
    required this.calendarFormat,
    required this.rangeSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2027, 12, 31),
      focusedDay: DateTime.now(),
      calendarFormat: calendarFormat,
      rangeSelectionMode: rangeSelectionMode,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onRangeSelected: onRangeSelected,
      rangeStartDay: startDate,
      rangeEndDay: endDate,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue, width: 2),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        rangeHighlightColor: Colors.blue.shade100,
        rangeStartDecoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        withinRangeDecoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
      ),
    );
  }
}
