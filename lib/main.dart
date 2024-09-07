import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/date_selection_screen.dart';
import 'screens/SummaryScreen.dart';

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
      home: IntroScreen(),
      routes: {
        '/categories': (context) => const CategoriesScreen(),
        '/date_selection': (context) => DateSelectionScreen(
              selectedCategories: const [],
            ),
        '/summary': (context) => SummaryScreen(
              selectedCategories: const [],
              startDate: DateTime.now(),
              endDate: DateTime.now(),
              duration: 0,
            ),
      },
    );
  }
}
