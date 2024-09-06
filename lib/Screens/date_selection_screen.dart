import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'SummaryScreen.dart';

class DateSelectionScreen extends StatefulWidget {
  final List<String> selectedCategories;

  DateSelectionScreen({required this.selectedCategories});

  @override
  // ignore: library_private_types_in_public_api
  _DateSelectionScreenState createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  void _showDurationDialog1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Minimum Duration Required',
            style: TextStyle(color: Colors.red),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Oops! It looks like your trip is a bit short.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'To create a comprehensive plan, we recommend:',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                '• A minimum duration of 5 days',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Adjust My Dates'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDurationDialog2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Premium plan needed'),
          content: const Text(
              'To plan trips longer than 3 weeks, you\'ll need our Premium features.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Got It'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDurationDialog3() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Please select your travel dates'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text(
                '1. Tap on your starting date.',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                '2. Tap again on your returning date.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'You can adjust your selection anytime.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInvalidDateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Invalid Start Date',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
              'The selected start date is in the past. Please choose a valid date which is after today.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Adjust My Dates'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.1,
                    bottom: screenHeight * 0.02,
                    left: screenWidth * 0.05),
                child: const Text(
                  'What are your preferred travel dates?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: TableCalendar(
                          firstDay: DateTime.utc(2024, 1, 1),
                          lastDay: DateTime.utc(2027, 12, 31),
                          focusedDay: DateTime.now(),
                          calendarFormat: _calendarFormat,
                          rangeSelectionMode: _rangeSelectionMode,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          onRangeSelected: (start, end, focusedDay) {
                            setState(() {
                              _startDate = start;
                              _endDate = end;
                            });
                          },
                          rangeStartDay: _startDate,
                          rangeEndDay: _endDate,
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
                        ),
                      ),
                      if (_startDate != null && _endDate != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1,
                              vertical: screenHeight * 0.06),
                          child: Card(
                            color: const Color.fromARGB(238, 255, 255, 255),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(screenHeight * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start Date: ${DateFormat('yyyy-MM-dd').format(_startDate!)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'End Date: ${DateFormat('yyyy-MM-dd').format(_endDate!)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'Duration: ${_endDate!.difference(_startDate!).inDays + 1} days',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: _startDate != null && _endDate != null
                  ? () {
                      DateTime today = DateTime.now();
                      int duration =
                          _endDate!.difference(_startDate!).inDays + 1;

                      if (_startDate!.isBefore(today)) {
                        _showInvalidDateDialog();
                      } else if (duration < 5) {
                        _showDurationDialog1();
                      } else if (duration > 21) {
                        _showDurationDialog2();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SummaryScreen(
                              selectedCategories: widget.selectedCategories,
                              startDate: _startDate!,
                              endDate: _endDate!,
                              duration: duration,
                            ),
                          ),
                        );
                      }
                    }
                  : _showDurationDialog3,
              child: Image.asset(
                'assets/continue_button.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
