import 'package:flutter/material.dart';
import 'date_selection_screen.dart';

class RecommendationResultsScreen extends StatelessWidget {
  static const String routeName = '/recommendationResults';
  final List<String> recommendations;
  final List<String> selectedCategories;
  final List<String> bucketList;

  const RecommendationResultsScreen({
    Key? key,
    required this.recommendations,
    required this.selectedCategories,
    required this.bucketList,
  }) : super(key: key);

  void _navigateToDateSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateSelectionScreen(
          selectedCategories: selectedCategories,
          bucketList: bucketList,
          recommendations: recommendations,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Here are your recommendations:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: recommendations.isNotEmpty
                  ? ListView.builder(
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading:
                              const Icon(Icons.place, color: Colors.blueAccent),
                          title: Text(recommendations[index]),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No recommendations found.'),
                    ),
            ),
            ElevatedButton(
              onPressed: () => _navigateToDateSelection(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
