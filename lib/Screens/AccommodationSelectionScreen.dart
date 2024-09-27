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

  Widget _buildAccommodationSelectionUI() {
    return Column(
      children: [
        const SizedBox(height: 60),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What type of accommodations are you interested in?',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Select one or more options',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: accommodationOptions.length,
            itemBuilder: (context, index) {
              final option = accommodationOptions[index];
              final isSelected = selectedAccommodations.contains(option);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedAccommodations.remove(option);
                    } else {
                      selectedAccommodations.add(option);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.white,
                    border: Border.all(
                      color: Colors.blueAccent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: _submitAccommodations,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/continue_button.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccommodationResults() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommended Accommodations',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Based on your preferences, here are the best options for each location on your journey',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: accommodations!.length + 1, // Add 1 for the button
                itemBuilder: (context, index) {
                  if (index < accommodations!.length) {
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
                              title: Text(location['message'] ??
                                  'No accommodations available'),
                            )
                          else
                            ...location['accommodations']
                                .map<Widget>((accommodation) {
                              return ListTile(
                                title: Text(accommodation['name']),
                                subtitle: Text(accommodation['type']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (accommodation['contact']['phone'] !=
                                            null &&
                                        accommodation['contact']['phone']
                                            .toString()
                                            .isNotEmpty)
                                      IconButton(
                                        icon: Icon(Icons.phone),
                                        onPressed: () {
                                          _showContactInfo(
                                              context,
                                              'Phone',
                                              accommodation['contact']
                                                  ['phone']);
                                        },
                                      ),
                                    if (accommodation['contact']['email'] !=
                                            null &&
                                        accommodation['contact']['email']
                                            .toString()
                                            .isNotEmpty)
                                      IconButton(
                                        icon: Icon(Icons.email),
                                        onPressed: () {
                                          _showContactInfo(
                                              context,
                                              'Email',
                                              accommodation['contact']
                                                  ['email']);
                                        },
                                      ),
                                    if (accommodation['contact']['website'] !=
                                            null &&
                                        accommodation['contact']['website']
                                            .toString()
                                            .isNotEmpty)
                                      IconButton(
                                        icon: Icon(Icons.language),
                                        onPressed: () {
                                          _launchURL(accommodation['contact']
                                              ['website']);
                                        },
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    );
                  } else {
                    // This is the last item, so we return the button
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement save functionality
                            print('Journey and Accommodations saved');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save Journey & Accommodations',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
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
            )
          : accommodations == null
              ? _buildAccommodationSelectionUI()
              : _buildAccommodationResults(),
    );
  }
}
