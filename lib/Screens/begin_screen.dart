import 'package:flutter/material.dart';

class BeginScreen extends StatelessWidget {
  const BeginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Begin Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Go to Intro Screen'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Go to Chatbot'),
              onPressed: () {
                Navigator.pushNamed(context, '/chatbot');
              },
            ),
          ],
        ),
      ),
    );
  }
}
