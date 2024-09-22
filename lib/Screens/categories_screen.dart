import 'package:flutter/material.dart';
import 'bucket_list_screen.dart';
import 'widgets/ErrorPopup.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<String> categories = [
    'Amusement Parks',
    'Animal Encounters',
    'Archaeological Sites',
    'Architecture Photography',
    'Architecture Tours',
    'Art Classes',
    'Arts and Culture',
    'Ayurvedic Spa Treatments',
    'Beach Visits',
    'Beachfront Dining',
    'Bird Watching',
    'Boat Safaris',
    'Botanical Gardens',
    'Butterfly Watching',
    'Camping',
    'Caving',
    'City Tours',
    'Craft Workshops',
    'Cultural Experiences',
    'Cultural Festivals',
    'Cycling',
    'Elephant Rides',
    'Fishing',
    'Golfing',
    'Hiking',
    'Historic Sites',
    'Historic Walks',
    'Historical Monuments',
    'History Tours',
    'Horse Shows',
    'Horseback Riding',
    'Hot Air Ballooning',
    'Hot Springs',
    'Kayaking',
    'Landscape Photography',
    'Literary Tours',
    'Local Crafts',
    'Mountain Biking',
    'Museum Visits',
    'Outdoor Adventures',
    'Paddleboarding',
    'Photography',
    'Planetarium Visits',
    'Public Art Installations',
    'River Cruises',
    'Rock Climbing',
    'Safaris',
    'Sailing',
    'Sailing Lessons',
    'Scuba Diving',
    'Sea Cruises',
    'Sightseeing',
    'Snorkeling',
    'Spiritual Retreats',
    'Surfing',
    'Tea Tasting',
    'Temple Pilgrimages',
    'Theater',
    'Themed Parks',
    'Traditional Ceremonies',
    'Turtle Watching',
    'Village Homestays',
    'Water Parks',
    'Waterfalls',
    'Whale Watching',
    'Wildlife Viewing',
    'Yoga Retreats',
    'Zip-lining'
  ];
  List<String> selectedCategories = [];

  void _showErrorPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ErrorPopup(
          message: 'Please select exactly 3 categories.',
        );
      },
    );
  }

  void _navigateToBucketList() {
    if (selectedCategories.length == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BucketListScreen(
            selectedCategories: selectedCategories,
          ),
        ),
      );
    } else {
      _showErrorPopup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What type of activities are you interested in?',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Select exactly 3 categories',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategories.contains(category);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedCategories.remove(category);
                      } else if (selectedCategories.length < 3) {
                        selectedCategories.add(category);
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
                      category,
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
                onTap: _navigateToBucketList,
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
      ),
    );
  }
}
