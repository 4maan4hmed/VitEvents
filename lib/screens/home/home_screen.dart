import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:flutter_application_2/config/theme/app_typography.dart';
import 'package:flutter_application_2/screens/home/all_event_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/events/event_card.dart';
import '../../models/event.dart';
import '../../services/firebase_event_service.dart';
import '../home/event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  List<Event> eventsList = [];
  bool isLoading = true;
  String? error;

  final FirebaseEventService _eventService = FirebaseEventService();

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

      final events = await _eventService.getEvents(limit: 5);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(145.0), // Extend AppBar height
          child: AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36))),
            title: const Text(
              "VIT EVENTS",
              style: AppTypography.pageTitle,
            ),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SearchBar(
                    hintText: '| Search for events ...',
                    hintStyle: WidgetStateProperty.all(
                      AppTypography.cardTitle.copyWith(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                    ),
                    shadowColor: WidgetStateProperty.all(
                        Colors.transparent), // No shadow
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.gray1
                          .withOpacity(0), // Transparent-like background
                    ),
                    leading: Icon(
                      Icons.search_rounded,
                      color: AppColors.white
                          .withOpacity(1), // Semi-transparent search icon
                    ),
                    trailing: [
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: AppColors.white
                              .withOpacity(1), // Filter icon styling
                        ),
                        onPressed: () {
                          //TODO: Action for the filter button
                        },
                      ),
                    ],
                    onTap: () {
                      // Ensure the search bar remains focused
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ), //TODO : Implement SearchBar widget, add the filter button that will use the bottom drop up for filter page and the seach bar should be transparent
                ),
                const SizedBox(
                    height: 30), // Add some spacing below the search bar
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: fetchEvents,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Upcoming Events",
                        style: AppTypography.listTitle,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllEventScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "See All",
                          style: AppTypography.listTitle,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ),
                const SizedBox(),
                SizedBox(
                  height: 280,
                  child: _buildEventsList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 18, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Nearby You",
                        style: AppTypography.listTitle,
                      ),
                      Spacer(),
                      Text(
                        "See All",
                        style: AppTypography.listTitle,
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ),
                const SizedBox(),
                SizedBox(
                  height: 280,
                  child: _buildEventsList(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GNav(
            tabBorderRadius: 40,
            tabActiveBorder: Border.all(color: AppColors.blueDark, width: 1.5),
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            tabs: const [
              GButton(
                icon: Icons.explore,
                text: 'Explore',
              ),
              GButton(
                icon: Icons.calendar_month,
                text: 'Events',
              ),
              GButton(
                icon: Icons.bookmark,
                text: 'Saved',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ));
  }

  Widget _buildEventsList() {
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

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: eventsList.length,
      itemBuilder: (context, index) {
        String id = const Uuid().v4();
        return EventCard(
          identity: id,
          event: eventsList[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventScreen(
                  event: eventsList[index],
                  identity: id,
                ), //Information from event card is passed to event screen
              ),
            );
          },
        );
      },
    );
  }
}
