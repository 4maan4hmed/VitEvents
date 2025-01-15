import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import '../../config/utils/screen_size_helper.dart';
import '../../models/event.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback? onTap;
  // Add a unique ID for each card instance
  final String identity;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.identity = "", // Generate unique ID when card is created
  }); // Generate unique ID when card is created

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isSaved = false;
  bool isclicked = false;

  @override
  Widget build(BuildContext context) {
    final sizeHelper = ScreenSizeHelper(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 250,
        child: GestureDetector(
          onTap: widget.onTap ?? () {},
          child: Container(
            width: sizeHelper.width(60),
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Hero(
                          tag: widget
                              .identity, // Use the card's unique ID for hero tag
                          child: Image.network(
                            widget.event.imageUrl,
                            height: 140,
                            width: 280,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const CircularProgressIndicator();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('Failed to load image');
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _buildDateOverlay(),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: _buildBookmarkButton(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style: AppTypography.cardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.event.price.toStringAsFixed(2)}',
                            style: AppTypography.cardPrice,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: AppColors.gray3,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.event.distance,
                                style: const TextStyle(
                                  color: AppColors.gray3,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  // Rest of the methods remain the same
  Widget _buildDateOverlay() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: AppColors.cardDateBackground.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.event.date, style: AppTypography.cardDate),
              Text(widget.event.month, style: AppTypography.cardMonth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              isSaved = !isSaved;
              isclicked = !isclicked;
            });
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
