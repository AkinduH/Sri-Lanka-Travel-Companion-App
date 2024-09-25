import 'package:flutter/material.dart';
import 'services/connections.dart';
import 'widgets/DotProgressIndicator.dart';

class AccommodationSelectionScreen extends StatefulWidget {
  final List<dynamic> expandedLoc;

  const AccommodationSelectionScreen({super.key, required this.expandedLoc});

  @override
  _AccommodationSelectionScreenState createState() =>
      _AccommodationSelectionScreenState();
}

class _AccommodationSelectionScreenState
    extends State<AccommodationSelectionScreen> {
  final Connections connectionService = Connections();
  final List<String> accommodationOptions = [
    'Star Hotels',
    'Normal Hotels',
    'Boutique Villas',
    'Hostels',
    'Luxury Resorts',
  ];
  List<String> selectedAccommodations = [];
  bool isLoading = false;
  String? responseMessage;

  void _submitAccommodations() async {
    if (selectedAccommodations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one option.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      responseMessage = null;
    });

    try {
      final response = await connectionService.getAccommodations(
        expandedLoc: widget.expandedLoc,
        selectedAccommodations: selectedAccommodations,
      );

      setState(() {
        responseMessage =
            response['message'] ?? 'Accommodations retrieved successfully!';
      });
    } catch (e) {
      setState(() {
        responseMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Fetching accommodations...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DotProgressIndicator(
              totalDots: 4,
              dotSize: 10,
              activeColor: Colors.blue,
              inactiveColor: Colors.grey.shade300,
              animationDuration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      );
    } else if (responseMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            responseMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Select Accommodation Types:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: accommodationOptions.map((option) {
                  return CheckboxListTile(
                    title: Text(option),
                    value: selectedAccommodations.contains(option),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedAccommodations.add(option);
                        } else {
                          selectedAccommodations.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _submitAccommodations,
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Full-width button
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Accommodations'),
      ),
      body: _buildBody(),
    );
  }
}
