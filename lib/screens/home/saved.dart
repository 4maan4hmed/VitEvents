import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:flutter_application_2/config/theme/app_typography.dart';
import 'package:flutter_application_2/services/firebase_event_service.dart';
import 'package:flutter_application_2/models/event.dart';
import 'package:flutter_application_2/screens/home/event_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_2/widgets/events/event_card_small.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Event> savedEvents = [];
  bool isLoading = true;
  String? error;
  final FirebaseEventService _eventService = FirebaseEventService();
  bool hasMore = true;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    fetchSavedEvents();
  }

  Future<void> fetchSavedEvents() async {
    if (!hasMore) return;

    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // First get all events
      final events = await _eventService.getEvents(
        whereClause: {},
        limit: _pageSize,
      );

      // Filter locally for saved events
      final filteredEvents = events.where((event) => event.isSaved).toList();

      if (mounted) {
        setState(() {
          savedEvents.addAll(filteredEvents);
          hasMore = events.length == _pageSize && filteredEvents.isNotEmpty;
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
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          title: const Text(
            "Saved Events",
            style: AppTypography.pageTitle,
          ),
        ),
      ),
      body: _buildSavedEventsList(),
    );
  }

  Widget _buildSavedEventsList() {
    if (isLoading && savedEvents.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && savedEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchSavedEvents,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (savedEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border,
              size: 64,
              color: AppColors.gray1,
            ),
            const SizedBox(height: 16),
            Text(
              'No saved events yet',
              style: AppTypography.cardTitle.copyWith(color: AppColors.gray1),
            ),
            const SizedBox(height: 8),
            Text(
              'Events you save will appear here',
              style:
                  AppTypography.cardSubtitle.copyWith(color: AppColors.gray2),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        savedEvents.clear();
        hasMore = true;
        await fetchSavedEvents();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: savedEvents.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == savedEvents.length) {
            if (isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              fetchSavedEvents();
              return const SizedBox.shrink();
            }
          }

          final event = savedEvents[index];
          String id = const Uuid().v4();

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventScreen(
                      event: event,
                      identity: id,
                    ),
                  ),
                );
              },
              child: EventCardSmall(
                event: event,
                identity: id,
              ),
            ),
          );
        },
      ),
    );
  }
}
