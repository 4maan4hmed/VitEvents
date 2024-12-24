import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final String title;
  final String date;
  final String month;
  final double price;
  final String imageUrl;
  final String distance;

  const Event({
    this.id,
    required this.title,
    required this.date,
    required this.month,
    required this.price,
    required this.imageUrl,
    this.distance = '1.2 km',
  });

  // Create Event from Firestore document
  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      month: data['month'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      distance: data['distance'] ?? '1.2 km',
    );
  }

  // Convert Event to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'date': date,
      'month': month,
      'price': price,
      'imageUrl': imageUrl,
      'distance': distance,
    };
  }
}