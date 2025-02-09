import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class FirebaseEventService {
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection('events');

  /// Fetches a paginated snapshot of events from Firestore.
  /// Applies filters from `whereClause` and supports pagination.
  Future<QuerySnapshot> getEventsSnapshot({
    int limit = 10,
    required Map<String, dynamic> whereClause,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _eventsCollection;

      // Apply filters
      whereClause.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          // Complex filters with operators
          if (value.containsKey('operator') && value.containsKey('value')) {
            switch (value['operator']) {
              case '>=':
                query =
                    query.where(key, isGreaterThanOrEqualTo: value['value']);
                break;
              case '<=':
                query = query.where(key, isLessThanOrEqualTo: value['value']);
                break;
              case '==':
                query = query.where(key, isEqualTo: value['value']);
                break;
              case 'array-contains':
                query = query.where(key, arrayContains: value['value']);
                break;
            }
          }
        } else {
          // Simple equality filters
          query = query.where(key, isEqualTo: value);
        }
      });

      // Pagination
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.limit(limit).get();

      return querySnapshot;
    } catch (e) {
      throw Exception('Error fetching events snapshot: $e');
    }
  }

  /// Fetches a list of events based on `whereClause` and limit.
  /// Supports pagination using `lastDocument`.
  Future<List<Event>> getEvents({
    int limit = 10,
    required Map<String, dynamic> whereClause,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final querySnapshot = await getEventsSnapshot(
        limit: limit,
        whereClause: whereClause,
        lastDocument: lastDocument,
      );

      return querySnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  /// Searches for events with a title that starts with the given `searchTerm`.
  Future<List<Event>> searchEventsByTitle(String searchTerm,
      {int limit = 10}) async {
    try {
      final lowerSearchTerm = searchTerm.toLowerCase();
      final querySnapshot = await _eventsCollection
          .where('title', isGreaterThanOrEqualTo: lowerSearchTerm)
          .where('title', isLessThanOrEqualTo: '$lowerSearchTerm\uf8ff')
          .limit(limit)
          .get();
      return querySnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error searching events by title: $e');
    }
  }

  /// Adds a new event to Firestore and returns its document ID.
  Future<String> addEvent(Event event) async {
    try {
      final eventMap = event.toFirestore();
      eventMap['title_lowercase'] = event.title.toLowerCase();
      final docRef = await _eventsCollection.add(eventMap);

      return docRef.id;
    } catch (e) {
      throw Exception('Error adding event: $e');
    }
  }

  /// Updates an existing event in Firestore by its document ID.
  Future<void> updateEvent(String id, Event event) async {
    try {
      final eventMap = event.toFirestore();
      eventMap['title_lowercase'] = event.title.toLowerCase();

      await _eventsCollection.doc(id).update(eventMap);
    } catch (e) {
      throw Exception('Error updating event: $e');
    }
  }

  /// Deletes an event from Firestore by its document ID.
  Future<void> deleteEvent(String id) async {
    try {
      await _eventsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }
}
