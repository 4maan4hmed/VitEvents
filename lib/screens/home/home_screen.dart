import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:flutter_application_2/config/theme/app_typography.dart';
import 'package:flutter_application_2/screens/home/all_event_screen.dart';
import 'package:flutter_application_2/widgets/animated_search_bar.dart';
import 'package:flutter_application_2/widgets/filter_bottom_sheet.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/events/event_card.dart';
import '../../models/event.dart';
import '../../services/firebase_event_service.dart';
import '../home/event_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int, String)? onSearchSubmitted;
  const HomeScreen({
    super.key,
    this.onSearchSubmitted,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> eventsList = [];
  bool isLoading = true;
  String? error;
  final TextEditingController searchController = TextEditingController();
  final FirebaseEventService _eventService = FirebaseEventService();

  // Fixed seeds for consistent shuffling between rebuilds
  final int upcomingEventsSeed = Random().nextInt(1000);
  final int nearbyEventsSeed = Random().nextInt(1000);
  final int popularEventsSeed = Random().nextInt(1000);

  Map<String, dynamic> currentFilters = {};

  void updateFilters(Map<String, dynamic> newFilters) {
    setState(() {
      currentFilters = newFilters;
      fetchEvents();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final events = await _eventService.getEvents(limit: 5, whereClause: {});

      if (mounted) {
        setState(() {
          eventsList = events;
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

  Widget _buildSectionHeader({
    required String title,
    bool showSeeAll = true,
    VoidCallback? onSeeAllPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.listTitle,
          ),
          if (showSeeAll) ...[
            const Spacer(),
            GestureDetector(
              onTap: onSeeAllPressed ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllEventsScreen(),
                      ),
                    );
                  },
              child: const Row(
                children: [
                  Text(
                    "See All",
                    style: AppTypography.listTitle,
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventsList(int fixedSeed) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
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

    // Use the fixed seed for shuffling
    final shuffledEvents = List<Event>.from(eventsList)
      ..shuffle(Random(fixedSeed));

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: shuffledEvents.length,
      itemBuilder: (context, index) {
        String id = const Uuid().v4();
        return EventCard(
          identity: id,
          event: shuffledEvents[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventScreen(
                  event: shuffledEvents[index],
                  identity: id,
                ),
              ),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(145.0),
      child: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
        ),
        title: const Text(
          "VIT EVENTS",
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
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => FilterBottomSheet(
                            currentFilters: currentFilters,
                            onApplyFilters: updateFilters,
                          ),
                        );
                      },
                    ),
                  ],
                  onSubmitted: (value) {
                    if (value.isNotEmpty && widget.onSearchSubmitted != null) {
                      widget.onSearchSubmitted!(
                          1, value); // 1 is the index for AllEventsScreen
                    }
                  },
                )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: fetchEvents,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Upcoming Events Section
              _buildSectionHeader(title: "Upcoming Events"),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: _buildEventsList(upcomingEventsSeed),
              ),
              const SizedBox(height: 40),
              // Nearby Events Section
              _buildSectionHeader(title: "Nearby You"),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: _buildEventsList(nearbyEventsSeed),
              ),
              const SizedBox(height: 40),
              // Popular Events Section
              _buildSectionHeader(title: "Popular Events"),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: _buildEventsList(popularEventsSeed),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
