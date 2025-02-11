import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/firebase_auth_service.dart';
import 'package:flutter_application_2/screens/Login/user_login.dart'; // Import the login page

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> _signOut(BuildContext context) async {
    await _authService.signOut();
    // Navigate to the login screen after signing out
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const UserLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Profile Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
