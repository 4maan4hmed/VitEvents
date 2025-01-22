import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';
import 'package:flutter_application_2/models/event.dart';
import 'package:intl/intl.dart';

class EventCardSmall extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final String? identity;
  late String time;
  EventCardSmall({
    super.key,
    required this.event,
    this.onTap,
    this.identity,
    this.time = "",
  });


  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = event.datetimeStart;
    DateTime startDate = timestamp.toDate(); // Converts Timestamp to DateTime
    startDate = timestamp.toDate();
    // Extract components
    String day = DateFormat.d().format(startDate); // e.g., "15"
    String month = DateFormat.MMMM().format(startDate);
    month = month.substring(0, 3);

    String year = DateFormat.y().format(startDate); // e.g., "2024"
    time = DateFormat.jm().format(startDate); // e.g., "2:54 PM"
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: identity.toString(),
                    child: Image.network(
                      event.imageUrl,
                      height: 124,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Event Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and Time
                      Text(
                        "$month, $day,  $time",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray2,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Title
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.gray,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.distance,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.gray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Optional: Add more event details here
                      if (event.bio != " null") ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gray1.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            event.bio,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.gray2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
