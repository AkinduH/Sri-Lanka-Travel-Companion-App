import 'package:flutter/material.dart';
import 'widgets/DotProgressIndicator.dart';
import 'services/connections.dart';
import 'widgets/MapMarkerWidget.dart';

class SummaryScreen extends StatelessWidget {
  final List<String> selectedCategories;
  final DateTime startDate;
  final DateTime endDate;
  final int duration;

  final connections connectionService = connections();

  SummaryScreen({
    super.key,
    required this.selectedCategories,
    required this.startDate,
    required this.endDate,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Plan')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: connectionService.sendDataToBackend(
            selectedCategories, startDate, endDate, duration),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hang tight as our AI team\ncurates your unforgettable\njourney!!!',
                    textAlign: TextAlign.center,
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
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final itinerary = snapshot.data!['itinerary'];
            final expandedLoc = snapshot.data!['expanded_loc'] as List<dynamic>;

            // Sort the keys based on the day number
            final sortedKeys = itinerary.keys.toList()
              ..sort((a, b) {
                final dayA = int.parse(a.split(' ')[1].replaceAll(':', ''));
                final dayB = int.parse(b.split(' ')[1].replaceAll(':', ''));
                return dayA.compareTo(dayB);
              });

            return Column(
              children: [
                // Call MapMarkerWidget to display the map
                Expanded(
                  flex: 1,
                  child: MapMarkerWidget(expandedLoc: expandedLoc),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: sortedKeys.length,
                    itemBuilder: (context, index) {
                      String day = sortedKeys[index];
                      Map<String, dynamic> details = itinerary[day];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              day,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Description:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      details['Description'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Activities:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    ...details['Activities']
                                        .map<Widget>((activity) {
                                      return ListTile(
                                        leading: const Icon(
                                            Icons.check_circle_outline),
                                        title: Text(
                                          activity,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                      );
                                    }).toList(),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Accommodation:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    ...details['Accommodation']
                                        .map<Widget>((accommodation) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.home,
                                                color: Colors.blueAccent),
                                            const SizedBox(width: 8),
                                            Text(
                                              accommodation,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
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
          } else {
            return const Center(child: Text('No Plan available'));
          }
        },
      ),
    );
  }
}
