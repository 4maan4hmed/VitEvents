// all_events_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Import your local widgets and services
import 'package:flutter_application_2/widgets/animated_search_bar.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:flutter_application_2/config/theme/app_typography.dart';
import 'package:flutter_application_2/widgets/filter_bottom_sheet.dart';
import 'package:flutter_application_2/services/firebase_event_service.dart';
import 'package:flutter_application_2/models/event.dart';
import 'package:flutter_application_2/screens/home/event_screen.dart';
import 'package:flutter_application_2/widgets/events/event_card_small.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  List<Event> eventsList = [];
  bool isLoading = false;
  String? error;
  final TextEditingController searchController = TextEditingController();
  final FirebaseEventService _eventService = FirebaseEventService();
  bool hasMore = true;
  static const int _pageSize = 10;
  DocumentSnapshot? lastDocument;

  // Filter and search state
  Map<String, dynamic> currentFilters = {};
  String searchQuery = '';
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _initialFetch();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _initialFetch() async {
    await fetchEvents();
  }

  Future<void> refresh() async {
    if (!mounted) return;

    setState(() {
      eventsList.clear();
      lastDocument = null;
      hasMore = true;
      error = null;
    });
    await _initialFetch();
  }

  Future<void> fetchEvents() async {
    if (!hasMore) {
      return;
    }

    if (!mounted) return;

    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Combine search query and filters
      Map<String, dynamic> whereClause = {...currentFilters};
      whereClause.forEach((key, value) {
        print(' Key : $key :: Value : $value');
      });
      // Add search query to where clause if not empty
      if (searchQuery.isNotEmpty) {
        whereClause['name_lowercase'] = {
          'operator': '>=',
          'value': searchQuery.toLowerCase(),
        };
      }


      final QuerySnapshot eventsSnapshot =
          await _eventService.getEventsSnapshot(
        limit: _pageSize,
        whereClause: whereClause,
        lastDocument: lastDocument,
      );

      print('whereClause : $whereClause');
      print('lastDocument : $lastDocument');
      print('searchQuery : $searchQuery');
      print('searchController : ${searchController.text}');

      if (!mounted) return;

      final List<Event> newEvents = eventsSnapshot.docs
          .map((doc) => Event.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

      setState(() {
        if (lastDocument == null) {
          eventsList = newEvents;
        } else {
          eventsList.addAll(newEvents);
        }

        hasMore = newEvents.length == _pageSize;
        lastDocument =
            eventsSnapshot.docs.isNotEmpty ? eventsSnapshot.docs.last : null;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void updateFilters(Map<String, dynamic> newFilters) {
    if (!mounted) return;

    setState(() {
      currentFilters = newFilters;
      eventsList.clear();
      lastDocument = null;
      hasMore = true;
      error = null;
    });
    _initialFetch();
  }

  void handleSearch(String query) {
    if (!mounted) return;

    setState(() {
      searchQuery = query;
      eventsList.clear();
      lastDocument = null;
      hasMore = true;
      error = null;
      isSearching = query.isNotEmpty;
    });
    _initialFetch();
  }

  Widget _buildEventsList() {
    if (isLoading && eventsList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading events...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (eventsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_busy,
              size: 64,
              color: AppColors.gray1,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? 'No events found matching your search'
                  : 'No events available',
              style: AppTypography.bodyMedium,
            ),
            if (isSearching || currentFilters.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    searchQuery = '';
                    currentFilters = {};
                    isSearching = false;
                  });
                  refresh();
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            hasMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          fetchEvents();
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: eventsList.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == eventsList.length) {
              return hasMore
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink();
            }

            final event = eventsList[index];
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
      ),
    );
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
                    if (currentFilters.isNotEmpty)
                      Badge(
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: AppColors.white,
                          ),
                          splashRadius: 24,
                          tooltip: 'Filter events',
                          onPressed: () => _showFilterBottomSheet(),
                        ),
                      )
                    else
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: AppColors.white,
                        ),
                        splashRadius: 24,
                        tooltip: 'Filter events',
                        onPressed: () => _showFilterBottomSheet(),
                      ),
                  ],
                  onSubmitted: handleSearch,
                  onChanged: (value) {
                    if (value.isEmpty && searchQuery.isNotEmpty) {
                      handleSearch('');
                    }
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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: currentFilters,
        onApplyFilters: updateFilters,
      ),
    );
  }
}
