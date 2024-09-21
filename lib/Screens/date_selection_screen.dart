import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'widgets/dialogs.dart';
import 'widgets/date_calendar_widget.dart';
import 'widgets/selected_dates_card.dart';
import 'SummaryScreen.dart';

class DateSelectionScreen extends StatefulWidget {
  final List<String> selectedCategories;

  const DateSelectionScreen({super.key, required this.selectedCategories});

  @override
  // ignore: library_private_types_in_public_api
  _DateSelectionScreenState createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

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
                        child: DateCalendarWidget(
                          startDate: _startDate,
                          endDate: _endDate,
                          onRangeSelected: (start, end, focusedDay) {
                            setState(() {
                              _startDate = start;
                              _endDate = end;
                            });
                          },
                          calendarFormat: _calendarFormat,
                          rangeSelectionMode: _rangeSelectionMode,
                        ),
                      ),
                      if (_startDate != null && _endDate != null)
                        SelectedDatesCard(
                          startDate: _startDate!,
                          endDate: _endDate!,
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
                        showInvalidDateDialog(context);
                      } else if (duration < 5) {
                        showDurationDialog1(context);
                      } else if (duration > 21) {
                        showDurationDialog2(context);
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
                  : () => showDurationDialog3(context),
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
