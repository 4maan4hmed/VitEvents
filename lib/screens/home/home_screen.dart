import 'package:flutter/material.dart';
import '../../widgets/events/event_card.dart';
import '../../models/event.dart';
import '../../services/mock_event_service.dart';

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
  
  final MockEventService _eventService = MockEventService();

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
      
      setState(() {
        eventsList = events;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
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
              if (!isLoading) ...[
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
            print('Event tapped: ${eventsList[index].title}');
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