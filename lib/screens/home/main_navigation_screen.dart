import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:flutter_application_2/screens/home/all_event_screen.dart';
import 'package:flutter_application_2/screens/home/home_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'profile.dart';
import 'saved.dart';
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  int _prevIndex = 0;
  String? _searchQuery;

  void handleSearchSubmitted(int index, String searchQuery) {
    setState(() {
      _prevIndex = _selectedIndex;
      _selectedIndex = index;
      _searchQuery = searchQuery;
    });
  }

  // List of screens to display
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onSearchSubmitted: handleSearchSubmitted,
      ),
      AllEventsScreen(
        initialSearchValue: _searchQuery,
      ),
      const SavedScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: GNav(
          selectedIndex: _selectedIndex,
          tabBorderRadius: 40,
          tabActiveBorder: Border.all(color: AppColors.blueDark, width: 1.5),
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTabChange: (index) {
            setState(() {
              _prevIndex = _selectedIndex;
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