import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:flutter_application_2/screens/home/all_event_screen.dart';
import 'package:flutter_application_2/screens/home/home_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // List of screens to display
  final List<Widget> _screens = [
    const HomeScreen(),
    const AllEventScreen(),
    const SavedScreen(), // You'll need to create this
    const ProfileScreen(), // You'll need to create this
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: GNav(
          selectedIndex: _selectedIndex, // Add this to control the selected tab
          tabBorderRadius: 40,
          tabActiveBorder: Border.all(color: AppColors.blueDark, width: 1.5),
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.explore,
              text: 'Explore',
            ),
            GButton(
              icon: Icons.calendar_month,
              text: 'Events',
            ),
            GButton(
              icon: Icons.bookmark,
              text: 'Saved',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// Create these screens
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Saved Screen'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
