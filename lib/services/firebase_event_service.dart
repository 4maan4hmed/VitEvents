// firebase_event_service.dart
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
      print('Building Firebase query with the following parameters:');
      print('Limit: $limit, WhereClause: $whereClause');
      if (lastDocument != null)
        print('Pagination from document ID: ${lastDocument.id}');

      Query query = _eventsCollection;

      // Apply filters
      whereClause.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          // Complex filters with operators
          if (value.containsKey('operator') && value.containsKey('value')) {
            print(
                'Applying filter: $key ${value['operator']} ${value['value']}');
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
          print('Applying simple filter: $key = $value');
          query = query.where(key, isEqualTo: value);
        }
      });

      // Pagination
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      print('Executing query with limit $limit');
      final querySnapshot = await query.limit(limit).get();

      print('Query completed. Fetched ${querySnapshot.docs.length} documents.');
      return querySnapshot;
    } catch (e) {
      print('Error in getEventsSnapshot: $e');
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

      print('Mapping Firestore documents to Event models.');
      return querySnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error in getEvents: $e');
      throw Exception('Error fetching events: $e');
    }
  }

  /// Searches for events with a title that starts with the given `searchTerm`.
  Future<List<Event>> searchEventsByTitle(String searchTerm,
      {int limit = 10}) async {
    try {
      final lowerSearchTerm = searchTerm.toLowerCase();

      print(
          'Searching events where title_lowercase starts with: $lowerSearchTerm');

      final querySnapshot = await _eventsCollection
          .where('title', isGreaterThanOrEqualTo: lowerSearchTerm)
          .where('title', isLessThanOrEqualTo: '$lowerSearchTerm\uf8ff')
          .limit(limit)
          .get();

      print(
          'Search query completed. Found ${querySnapshot.docs.length} results.');
      return querySnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error in searchEventsByTitle: $e');
      throw Exception('Error searching events by title: $e');
    }
  }

  /// Adds a new event to Firestore and returns its document ID.
  Future<String> addEvent(Event event) async {
    try {
      final eventMap = event.toFirestore();
      eventMap['title_lowercase'] = event.title.toLowerCase();

      print('Adding event: $eventMap');
      final docRef = await _eventsCollection.add(eventMap);

      print('Event added successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error in addEvent: $e');
      throw Exception('Error adding event: $e');
    }
  }

  /// Updates an existing event in Firestore by its document ID.
  Future<void> updateEvent(String id, Event event) async {
    try {
      final eventMap = event.toFirestore();
      eventMap['title_lowercase'] = event.title.toLowerCase();

      print('Updating event with ID: $id. Data: $eventMap');
      await _eventsCollection.doc(id).update(eventMap);

      print('Event updated successfully for ID: $id');
    } catch (e) {
      print('Error in updateEvent: $e');
      throw Exception('Error updating event: $e');
    }
  }

  /// Deletes an event from Firestore by its document ID.
  Future<void> deleteEvent(String id) async {
    try {
      print('Deleting event with ID: $id');
      await _eventsCollection.doc(id).delete();

      print('Event deleted successfully for ID: $id');
    } catch (e) {
      print('Error in deleteEvent: $e');
      throw Exception('Error deleting event: $e');
    }
  }
}
