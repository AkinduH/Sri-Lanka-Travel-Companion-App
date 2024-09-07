import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedDatesCard extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const SelectedDatesCard({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
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
                'Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Duration: ${endDate.difference(startDate).inDays + 1} days',
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
    );
  }
}
