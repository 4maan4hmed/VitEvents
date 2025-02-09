import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/firebase_auth_service.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Screen'),
            const SizedBox(height: 16.0),
            Container(
                child: ElevatedButton(
                    onPressed: () => _authService.signOut(),
                    child: const Text("Sign Out"))),
          ],
        ),
      ),
    );
  }
}
