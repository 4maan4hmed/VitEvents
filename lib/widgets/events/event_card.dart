import 'dart:ui';
import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import '../../config/utils/screen_size_helper.dart';
import '../../models/event.dart'; // Add this import for the Event model

class EventCard extends StatefulWidget {
  final Event event;  // Changed to use Event model
  final VoidCallback? onTap;

  const EventCard({
    Key? key,
    required this.event,  // Made required since we need event data
    this.onTap,
  }) : super(key: key);

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
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                        child: Image.network(
                          widget.event.imageUrl,  // Updated to use event model
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
                        widget.event.title,  // Updated to use event model
                        style: AppTypography.cardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.event.price.toStringAsFixed(2)}',  // Updated to use event model
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
                                widget.event.distance,  // Updated to use event model
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
              Text(widget.event.date, style: AppTypography.cardDate),  // Updated to use event model
              Text(widget.event.month, style: AppTypography.cardMonth),  // Updated to use event model
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