import 'package:flipnmatch/pages/home.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  // Constructor for StartPage widget
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          // Handles button press and navigates to HomePage
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          child: const Text('Start new Game'),
        ),
      ),
    );
  }
}
