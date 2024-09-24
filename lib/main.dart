import 'package:flutter/material.dart';
import 'Screens/begin_screen.dart';
import 'Screens/chatbot_screen.dart';
import 'Screens/intro_screen.dart';
import 'Screens/categories_screen.dart';
import 'Screens/bucket_list_screen.dart';
import 'Screens/loading_screen.dart';
import 'Screens/recommendation_results_screen.dart';
import 'Screens/date_selection_screen.dart';
import 'Screens/SummaryScreen.dart';
import 'Screens/AccommodationSelectionScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sri Lanka Travel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/begin',
      routes: {
        '/begin': (context) => const BeginScreen(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/': (context) => const IntroScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/bucket_list': (context) => const BucketListScreen(
              selectedCategories: [],
            ),
        '/loading': (context) =>
            const LoadingScreen(selectedCategories: [], bucketList: []),
        '/recommendation_results': (context) =>
            const RecommendationResultsScreen(
                recommendations: [], selectedCategories: [], bucketList: []),
        '/date_selection': (context) => const DateSelectionScreen(
            selectedCategories: [], bucketList: [], recommendations: []),
        '/summary': (context) => SummaryScreen(
            selectedCategories: [],
            bucketList: [],
            recommendations: [],
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            duration: 0),
        '/accommodation_selection': (context) => AccommodationSelectionScreen(
              expandedLoc: ModalRoute.of(context)!.settings.arguments
                  as List<dynamic>, // Receive expandedLoc
            ),
      },
    );
  }
}
