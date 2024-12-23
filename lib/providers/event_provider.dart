// lib/data/events_data.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';

  const List<Event> eventsList = [
    Event(
      title: "Music Festival",
      date: "15",
      month: "JUNE",
      price: 100.00,
      imageUrl: "assets/images/cars.jpg",
    ),
    Event(
      title: "TechFest",
      date: "10",
      month: "JULY",
      price: 240.00,
      imageUrl: "assets/images/doodhinspecter.jpg",
    ),
    Event(
      title: "Bababoi",
      date: "20",
      month: "JUNE",
      price: 150.00,
      imageUrl: "assets/images/cars.jpg",
    ),
  ];
final event_provide = Provider((ref){
  return eventsList;
});