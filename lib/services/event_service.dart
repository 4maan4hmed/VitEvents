import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventService {
  static const String baseUrl = 'YOUR_API_BASE_URL';

  Future<List<Event>> getEvents({int limit = 5}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          // Add any required headers (e.g., authentication)
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }
}