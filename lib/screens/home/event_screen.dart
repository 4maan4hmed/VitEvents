import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';

class EventScreen extends StatefulWidget {
  final Event event;
  final String identity;
  const EventScreen({
    super.key,
    required this.event,
    required this.identity,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final double _minHeight = 300.0;
  final double _maxHeight = 600.0;
  bool isSaved = false;
  bool isclicked = false;

  // Initialize with default values instead of using late
  DateTime startDate = DateTime.now();
  String day = '';
  String month = '';
  String year = '';
  String time = '';
  String weekday = '';

  @override
  void initState() {
    super.initState();
    try {
      isSaved = widget.event.isSaved;
      Timestamp timestamp = widget.event.datetimeStart;
      startDate = timestamp.toDate();

      List<String> weekdays = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
      ];

      // Make sure to initialize all variables
      weekday = weekdays[startDate.weekday - 1];
      day = DateFormat.d().format(startDate);
      month = DateFormat.MMMM().format(startDate).toUpperCase();
      if (month.length > 3) {
        month = month.substring(0, 3);
      }
      year = DateFormat.y().format(startDate);
      time = DateFormat.jm().format(startDate);
    } catch (e) {
      print('Error initializing date variables: $e');
      // Set default values in case of error
      weekday = 'Monday';
      day = '1';
      month = 'JAN';
      year = '2024';
      time = '12:00 PM';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cardDateBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            child: _buildBookmarkButton(),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            delegate: _StretchableHeaderDelegate(
              minHeight: _minHeight,
              maxHeight: _maxHeight,
              child: Hero(
                tag: widget.identity,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(14), // Adjust the radius as needed
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.event.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.gray,
                            child: const Icon(Icons.error_outline),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color.fromARGB(255, 248, 248, 248)
                                  .withOpacity(0),
                              const Color.fromARGB(255, 248, 248, 248)
                                  .withOpacity(0.3),
                              const Color.fromARGB(255, 248, 248, 248)
                                  .withOpacity(0.6),
                              const Color.fromARGB(255, 248, 248, 248)
                                  .withOpacity(0.8),
                              const Color.fromARGB(255, 248, 248, 248)
                                  .withOpacity(1),
                            ],
                            stops: const [0.5, 0.7, 0.8, 0.9, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: widget.event.title,
            ),
            pinned: false,
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(39)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      Icons.calendar_today,
                      '$day $month $year',
                      subtitle: weekday,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      Icons.location_on,
                      "Location",
                      subtitle: widget.event.distance,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      Icons.access_time,
                      time,
                      subtitle: 'Start Time',
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'About Event',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.event.bio,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.glassDark.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'BUY TICKET \$${widget.event.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.glassDark.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

//TODO::Create data for this organiser later
  Widget _buildOrganizerRow(String name, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.glassDark.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imageUrl),
            onBackgroundImageError: (_, __) {
              return;
            },
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue,
                ),
              ),
              Text(
                'Organizer',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Follow',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: GestureDetector(
          onTap: () async {
            setState(() {
              isSaved = !isSaved;
              isclicked = !isclicked;
            });

            try {
              await widget.event.updateSavedStatus(isSaved);
            } catch (e) {
              // Revert if failed
              setState(() {
                isSaved = !isSaved;
              });
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to update bookmark')),
              );
            }

            Future.delayed(const Duration(milliseconds: 50), () {
              setState(() {
                isclicked = !isclicked;
              });
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOutCubic,
            height: isclicked ? 34 : 36,
            width: isclicked ? 34 : 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _StretchableHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final String title;

  _StretchableHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    required this.title,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double opacity = shrinkOffset / maxExtent;

    // Create an interpolated color between white and grey2
    final Color titleColor = Color.lerp(
          AppColors.blueDark,
          AppColors.gray1, // Replace with your grey2 color
          opacity,
        ) ??
        AppColors.white;

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          bottom: 10 + (20 * (1 - opacity)),
          left: 20,
          right: 20,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: titleColor, // Use the interpolated color
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant _StretchableHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
