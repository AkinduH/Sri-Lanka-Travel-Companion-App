import 'package:flutter/material.dart';

void showDurationDialog1(BuildContext context) {
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

void showDurationDialog2(BuildContext context) {
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

void showDurationDialog3(BuildContext context) {
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

void showInvalidDateDialog(BuildContext context) {
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
