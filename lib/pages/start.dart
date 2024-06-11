import 'package:flipnmatch/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StartPage extends StatelessWidget {
  // Constructor for StartPage widget
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const HomePage(column: 3, multiply: 4),
                  ),
                );
              },
              child: const Text('Easy'),
            ),
            Gap(16.0),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const HomePage(column: 4, multiply: 8),
                  ),
                );
              },
              child: const Text('Normal'),
            ),
            Gap(16.0),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const HomePage(column: 5, multiply: 10),
                  ),
                );
              },
              child: const Text('Hard'),
            ),
            Gap(16.0),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const HomePage(column: 6, multiply: 12),
                  ),
                );
              },
              child: const Text('Very Hard'),
            ),
          ],
        ),
      ),
    );
  }
}
