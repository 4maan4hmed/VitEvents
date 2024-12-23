  import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
  import 'config/theme/app_theme.dart';
  import 'screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
  debugPrintHitTestResults = true; // This will help identify touch event issues
}

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Event Hub',
        theme: appTheme(),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      );
    }
  }