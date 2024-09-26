import 'package:flutter/material.dart';
import 'dart:convert';
import 'services/connections.dart';
import 'widgets/DotProgressIndicator.dart';
import 'package:url_launcher/url_launcher.dart';

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
    'Sri Lanka Tourism Resorts',
    'Boutique Villas',
    'Bungalows',
    'Home Stays',
    'Camping Sites'
  ];
  List<String> selectedAccommodations = [];
  bool isLoading = false;
  List<dynamic>? accommodations;

  void _submitAccommodations() async {
    if (selectedAccommodations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one option.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      accommodations = null;
    });

    try {
      String response = await connectionService.getAccommodations(
        expandedLoc: widget.expandedLoc,
        selectedAccommodations: selectedAccommodations,
      );

      // Remove ```json and ``` if present
      if (response.startsWith('```json')) {
        response = response.substring(7);
      }
      if (response.endsWith('```')) {
        response = response.substring(0, response.length - 3);
      }

      final decodedResponse = json.decode(response);
      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey('locations')) {
        setState(() {
          accommodations = decodedResponse['locations'];
        });
      } else {
        throw Exception('Invalid response format.');
      }
    } catch (e) {
      setState(() {
        accommodations = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error in _submitAccommodations: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showContactInfo(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw 'Could not launch $url';
        }
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error in _launchURL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Could not open the link. Try opening in a browser: $url')),
        );
      }
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
    } else if (accommodations != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: accommodations!.length,
          itemBuilder: (context, index) {
            final location = accommodations![index];
            // Check if the location has a message instead of accommodations
            if (location['accommodations'] != null &&
                location['accommodations'].isNotEmpty &&
                location['accommodations'][0].containsKey('message')) {
              return Card(
                child: ListTile(
                  title: Text(
                    location['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    location['accommodations'][0]['message'] ??
                        'No accommodations available',
                  ),
                ),
              );
            }

            return Card(
              child: ExpansionTile(
                title: Text(
                  location['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  if (location['accommodations'].isEmpty)
                    ListTile(
                      title: Text(
                          location['message'] ?? 'No accommodations available'),
                    )
                  else
                    ...location['accommodations'].map<Widget>((accommodation) {
                      return ListTile(
                        title: Text(accommodation['name']),
                        subtitle: Text(accommodation['type']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (accommodation['contact']['phone'] != null &&
                                accommodation['contact']['phone']
                                    .toString()
                                    .isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.phone),
                                onPressed: () {
                                  _showContactInfo(context, 'Phone',
                                      accommodation['contact']['phone']);
                                },
                              ),
                            if (accommodation['contact']['email'] != null &&
                                accommodation['contact']['email']
                                    .toString()
                                    .isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.email),
                                onPressed: () {
                                  _showContactInfo(context, 'Email',
                                      accommodation['contact']['email']);
                                },
                              ),
                            if (accommodation['contact']['website'] != null &&
                                accommodation['contact']['website']
                                    .toString()
                                    .isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.language),
                                onPressed: () {
                                  _launchURL(
                                      accommodation['contact']['website']);
                                },
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            );
          },
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
                minimumSize: const Size.fromHeight(50),
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
