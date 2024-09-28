import 'package:flutter/material.dart';
import 'services/connections.dart';
import 'widgets/DotProgressIndicator.dart';
import 'recommendation_results_screen.dart';

class LoadingScreen extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> bucketList;

  const LoadingScreen({
    super.key,
    required this.selectedCategories,
    required this.bucketList,
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final Connections connectionService = Connections();

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    try {
      List<String> recommendations = await connectionService.getRecommendations(
        // Updated method call
        widget.selectedCategories,
        widget.bucketList,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecommendationResultsScreen(
              recommendations: recommendations,
              selectedCategories: widget.selectedCategories,
              bucketList: widget.bucketList,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Error'),
            content: Text('Failed to fetch recommendations: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Go back to BucketListScreen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Fetching Recommendations'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Generating your recommendations...',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            DotProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
