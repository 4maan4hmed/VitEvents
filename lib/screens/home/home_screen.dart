import 'package:flutter/material.dart';
import '../../widgets/events/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens for each navigation item
  final List<Widget> _screens = [
    // Explore Screen
    ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        EventCard(),
        EventCard(
          title: "TechFest",
          date: "10",
          month: "July",
          price: 240,
          imageUrl: "assets/doodhinspecter.jpg",
        ),
        EventCard(
          title: "mama mia",
        ),
      ],
    ),
    // Events Screen
    const Center(child: Text('Events Calendar')),
    // Saved Screen
    const Center(child: Text('Saved Events')),
    // Profile Screen
    const Center(child: Text('Profile')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Navigation tapped: $index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Required for more than 3 items
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Events"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Saved"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile"
          ),
        ],
      ),
    );
  }
}

// You might want to extract this into a separate screen later
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        EventCard(),
        EventCard(
          title: "TechFest",
          date: "10",
          month: "July",
          price: 240,
          imageUrl: "assets/doodhinspecter.jpg",
        ),
        EventCard(
          title: "Baller",
        ),
      ],
    );
  }
}