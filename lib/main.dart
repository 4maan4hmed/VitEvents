import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_2/screens/Login/onboarding.dart';
import 'package:flutter_application_2/screens/Login/user_login.dart';
import 'package:flutter_application_2/screens/Login/user_register.dart';
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return const MainNavigationScreen();
          }

          return const UserLoginPage();
        },
      ),
      routes: {
        '/login': (context) => const UserLoginPage(),
        '/register': (context) => const UserRegisterPage(),
        '/home': (context) => const MainNavigationScreen(),
      },
    );
  }
}
