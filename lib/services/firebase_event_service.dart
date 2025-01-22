import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class FirebaseEventService {
  final CollectionReference _eventsCollection = 
      FirebaseFirestore.instance.collection('events');

  // Get random events with limit
  Future<List<Event>> getEvents({int limit = 5, required Map<String, bool> whereClause}) async {
    try {
      // Get all documents and shuffle them in memory
      final querySnapshot = await _eventsCollection.get();
      final events = querySnapshot.docs
          .map((doc) => Event.fromFirestore(doc))
          .toList();
      
      // Shuffle the list and return limited items
      events.shuffle();
      return events.take(limit).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  // Get all events
  Future<List<Event>> getAllEvents() async {
    try {
      final querySnapshot = await _eventsCollection.get();
      return querySnapshot.docs
          .map((doc) => Event.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching all events: $e');
    }
  }

  // Add new event
  Future<void> addEvent(Event event) async {
    try {
      await _eventsCollection.add(event.toFirestore());
    } catch (e) {
      throw Exception('Error adding event: $e');
    }
  }

  // Update event
  Future<void> updateEvent(String id, Event event) async {
    try {
      await _eventsCollection.doc(id).update(event.toFirestore());
    } catch (e) {
      throw Exception('Error updating event: $e');
    }
  }

  // Delete event
  Future<void> deleteEvent(String id) async {
    try {
      await _eventsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }

  // Stream of events (real-time updates)
  Stream<List<Event>> eventsStream() {
    return _eventsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    });
  }
}