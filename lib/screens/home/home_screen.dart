import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:flutter_application_2/config/theme/app_typography.dart';
import '../../widgets/events/event_card.dart';
import '../../models/event.dart';
import '../../services/firebase_event_service.dart';
import '../home/event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Event> eventsList = [];
  bool isLoading = true;
  String? error;

  final FirebaseEventService _eventService = FirebaseEventService();

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final events = await _eventService.getEvents(limit: 5);

      if (mounted) {
        setState(() {
          eventsList = events;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0), // Extend AppBar height
        child: AppBar(
          title: const Text("VIT EVENTS", style: AppTypography.pageTitle),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchBar(
                  hintText: '| Search for events ...',

                  shadowColor:
                      WidgetStateProperty.all(Colors.transparent), // No shadow
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.gray1
                        .withOpacity(0.2), // Transparent-like background
                  ),
                  leading: Icon(
                    Icons.search,
                    color: AppColors.gray1
                        .withOpacity(0.6), // Semi-transparent search icon
                  ),
                  trailing: [
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: AppColors.gray1
                            .withOpacity(0.6), // Filter icon styling
                      ),
                      onPressed: () {
                        // Action for the filter button
                        print("Filter button pressed!");
                      },
                    ),
                  ],
                  onTap: () {
                    // Ensure the search bar remains focused
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ), //TODO : Implement SearchBar widget, add the filter button that will use the bottom drop up for filter page and the seach bar should be transparent
              ),
              const SizedBox(
                  height: 10), // Add some spacing below the search bar
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchEvents,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 280,
                child: _buildEventsList(),
              ),
              if (!isLoading && error == null) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to all events page
                    },
                    child: const Text('View All Events'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchEvents,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (eventsList.isEmpty) {
      return const Center(child: Text('No events available'));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: eventsList.length,
      itemBuilder: (context, index) {
        return EventCard(
          event: eventsList[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EventScreen(title: eventsList[index].title),
              ),
            );
          },
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
