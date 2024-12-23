import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'screens/home/home_screen.dart';

void main() => runApp(const MyApp());

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