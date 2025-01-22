import 'package:flutter_application_2/widgets/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:flutter_application_2/config/theme/app_typography.dart';
import 'package:flutter_application_2/widgets/filter_bottom_sheet.dart';
import 'package:flutter_application_2/services/firebase_event_service.dart';
import 'package:flutter_application_2/models/event.dart';
import 'package:flutter_application_2/screens/home/event_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_2/widgets/events/event_card_small.dart'; // Import your EventCardSmall

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  List<Event> eventsList = [];
  bool isLoading = true;
  String? error;
  final TextEditingController searchController = TextEditingController();
  final FirebaseEventService _eventService = FirebaseEventService();
  bool hasMore = true;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    if (!hasMore) return;

    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final events = await _eventService.getEvents(
        limit: _pageSize,
        whereClause: {},
      );

      if (mounted) {
        setState(() {
          eventsList.addAll(events);
          hasMore = events.length == _pageSize;
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
        preferredSize: const Size.fromHeight(145.0),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          title: const Text(
            "All Events",
            style: AppTypography.pageTitle,
          ),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AnimatedSearchBar(
                  controller: searchController,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      searchController.clear();
                    });
                  },
                  hintText: 'Search for events ...',
                  hintStyle: AppTypography.cardTitle.copyWith(
                    color: AppColors.white.withOpacity(0.3),
                  ),
                  textStyle: AppTypography.cardTitle.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  overlayColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  backgroundColor: AppColors.gray1.withOpacity(0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(
                    Icons.search_rounded,
                    color: AppColors.white,
                    size: 24,
                  ),
                  trailing: [
                    IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        color: AppColors.white,
                      ),
                      splashRadius: 24,
                      tooltip: 'Filter events',
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const FilterBottomSheet(),
                        );
                      },
                    ),
                  ],
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      // Implement search functionality
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      // Update search results in real-time if needed
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      body: _buildEventsList(),
    );
  }

  Widget _buildEventsList() {
    if (isLoading && eventsList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && eventsList.isEmpty) {
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

    return RefreshIndicator(
      onRefresh: () async {
        eventsList.clear();
        hasMore = true;
        await fetchEvents();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: eventsList.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == eventsList.length) {
            if (isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              fetchEvents();
              return const SizedBox.shrink();
            }
          }

          final event = eventsList[index];
          String id = const Uuid().v4();

          return Padding(
            padding: const EdgeInsets.only(bottom: 1),
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
