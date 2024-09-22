import 'package:flutter/material.dart';
import 'loading_screen.dart';
import 'widgets/ErrorPopup.dart';

class BucketListScreen extends StatefulWidget {
  final List<String> selectedCategories;

  const BucketListScreen({super.key, required this.selectedCategories});

  @override
  _BucketListScreenState createState() => _BucketListScreenState();
}

class _BucketListScreenState extends State<BucketListScreen> {
  final List<String> bucketList = [];
  final List<String> availablePlaces = [
    'Sigiriya Rock Fortress',
    'Galle Fort',
    'Yala National Park',
    'Ella',
    'Kandy Lake',
    'Nuwara Eliya',
    'Hikkaduwa Beach',
    'Anuradhapura',
    'Polonnaruwa',
    'Bentota River',
    // Add more places as needed
  ];

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(
          message: message,
        );
      },
    );
  }

  void _addBucketListItem(String item) {
    if (bucketList.length >= 5) {
      _showErrorPopup('You can select up to 5 places.');
      return;
    }
    if (!bucketList.contains(item)) {
      setState(() {
        bucketList.add(item);
      });
    }
  }

  void _removeBucketListItem(String item) {
    setState(() {
      bucketList.remove(item);
    });
  }

  void _navigateToLoading() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          selectedCategories: widget.selectedCategories,
          bucketList: bucketList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Your Bucket List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Select up to 5 places for your bucket list:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: availablePlaces.length,
                  itemBuilder: (context, index) {
                    final place = availablePlaces[index];
                    final isSelected = bucketList.contains(place);

                    return ListTile(
                      title: Text(place),
                      trailing: isSelected
                          ? IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () => _removeBucketListItem(place),
                            )
                          : IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green),
                              onPressed: () => _addBucketListItem(place),
                            ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _navigateToLoading,
                child: const Text('Continue'),
              ),
            ],
          ),
        ));
  }
}
