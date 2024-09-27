import 'package:flutter/material.dart';
import 'loading_screen.dart';
import 'widgets/ErrorPopup.dart';
import 'data/locations.dart';

class BucketListScreen extends StatefulWidget {
  final List<String> selectedCategories;

  const BucketListScreen({super.key, required this.selectedCategories});

  @override
  _BucketListScreenState createState() => _BucketListScreenState();
}

class _BucketListScreenState extends State<BucketListScreen> {
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());

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

  void _navigateToLoading() {
    List<String> bucketList = _controllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (bucketList.isEmpty) {
      _showErrorPopup('Please enter at least one place.');
      return;
    }

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
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildAutoCompleteField(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return allLocations.where((String option) {
            return option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) {
          _controllers[index].text = selection;
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController fieldController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          _controllers[index] = fieldController;
          return TextField(
            controller: fieldController,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: 'Place ${index + 1}',
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              labelStyle: const TextStyle(color: Colors.black),
            ),
            cursorColor: Colors.blueAccent,
          );
        },
      ),
    );
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
                  'Add your bucket list in Sri Lanka',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Select your favorite places',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildAutoCompleteField(index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: _navigateToLoading,
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
