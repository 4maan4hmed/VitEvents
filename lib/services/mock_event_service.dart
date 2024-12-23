import 'dart:math';
import '../models/event.dart';

class MockEventService {
  // List of sample event data
  final List<Event> _mockEvents = [
    Event(
      title: "Summer Music Festival",
      date: "15",
      month: "JUNE",
      price: 99.99,
      imageUrl: "assets/images/cars.jpg",
    ),
    Event(
      title: "Tech Conference 2024",
      date: "22",
      month: "JULY",
      price: 249.99,
      imageUrl: "assets/images/doodhinspecter.jpg",
    ),
    Event(
      title: "Food & Wine Expo",
      date: "10",
      month: "AUG",
      price: 75.00,
      imageUrl: "assets/images/cars.jpg",
    ),
    Event(
      title: "Art Gallery Opening",
      date: "05",
      month: "SEPT",
      price: 25.00,
      imageUrl: "assets/images/doodhinspecter.jpg",
    ),
    Event(
      title: "Comedy Night Special",
      date: "18",
      month: "JUNE",
      price: 45.00,
      imageUrl: "assets/images/cars.jpg",
    ),
    Event(
      title: "Dance Workshop",
      date: "25",
      month: "JULY",
      price: 120.00,
      imageUrl: "assets/images/doodhinspecter.jpg",
    ),
    Event(
      title: "Gaming Tournament",
      date: "30",
      month: "AUG",
      price: 15.00,
      imageUrl: "assets/images/cars.jpg",
    ),
    // Add more events as needed
  ];

  // Simulate fetching events with a delay
  Future<List<Event>> getEvents({int limit = 5}) async {
    // Simulate network delay between 0.5 to 1.5 seconds
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));

    // Simulate random network error (10% chance)
    if (Random().nextDouble() < 0.1) {
      throw Exception('Failed to fetch events: Network error');
    }

    // Return limited number of events
    return _mockEvents.take(limit).toList();
  }

  // Get all events
  Future<List<Event>> getAllEvents() async {
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
    return _mockEvents;
  }

  // Search events
  Future<List<Event>> searchEvents(String query) async {
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
    
    return _mockEvents.where((event) => 
      event.title.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Get events by month
  Future<List<Event>> getEventsByMonth(String month) async {
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
    
    return _mockEvents.where((event) => 
      event.month.toLowerCase() == month.toLowerCase()
    ).toList();
  }
}