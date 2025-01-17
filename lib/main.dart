import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/home/main_navigation_screen.dart';
import 'config/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Hub',
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      home: const MainNavigationScreen(),
    );
  }
}
