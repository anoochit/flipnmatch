import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flipnmatch/pages/start.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());

  // Check if the platform is Windows, Linux, or MacOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Wait until the window is ready
    doWhenWindowReady(() {
      // Set the initial size of the window
      const initialSize = Size(405, 720);
      // Set the maximum size of the window
      appWindow.maxSize = initialSize;
      // Set the minimum size of the window
      appWindow.minSize = initialSize;
      // Set the initial size of the window
      appWindow.size = initialSize;
      // Show the window
      appWindow.show();
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip N Match',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StartPage(),
    );
  }
}
