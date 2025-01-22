import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final String title;
  final String date;
  final String month;
  final double price;
  final String imageUrl;
  final String distance;
  final String bio;
  final bool isSaved;
  final Timestamp datetimeStart;

  const Event({
    this.id,
    required this.title,
    required this.date,
    required this.month,
    required this.price,
    required this.imageUrl,
    required this.distance,
    required this.bio,
    required this.isSaved,
    required this.datetimeStart,
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
        distance: data['location'] ?? 'N/A',
        bio: data['bio'] ??
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        isSaved: data['is_saved'] ?? false,
        datetimeStart: data['start_time'] ?? Timestamp(123, 123));
  }

  
  Future<List<Event>> getEvents({
    int? limit,
    Map<String, dynamic>? whereClause,
  }) async {
    Query query = FirebaseFirestore.instance.collection('events');

    if (whereClause != null) {
      whereClause.forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }

  // Convert Event to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'is_saved': isSaved,
    };
  }

  Future<void> updateSavedStatus(bool newStatus) async {
    if (id == null) {
      throw Exception('Cannot update document without an ID');
    }

    try {
      await FirebaseFirestore.instance
          .collection('events') // Replace with your collection name
          .doc(id)
          .update({'is_saved': newStatus});
    } catch (e) {
      throw Exception('Failed to update saved status: $e');
    }
  }
}
