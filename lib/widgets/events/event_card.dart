import 'dart:ui';
import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import '../../config/utils/screen_size_helper.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String date;
  final String month;
  final double price;
  final String imageUrl;
  final VoidCallback? onTap;

  const EventCard({
    Key? key,
    this.title = "Event Name",
    this.date = "12",
    this.month = "JUNE",
    this.price = 100,
    this.imageUrl = "assets/images/default.jpg",
    this.onTap,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    final sizeHelper = ScreenSizeHelper(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap ?? () {},
        child: Container(
          width: sizeHelper.width(60), // Card width
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
              // Image and overlays container
              Stack(
                children: [
                  // Event Image
                 Padding(
                   padding: const EdgeInsets.all(6.0),
                   child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            widget.imageUrl,
                            height: 140,
                            width: 280,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                 ),
                       
                  // Date overlay
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildDateOverlay(),
                  ),
    
                  // Bookmark button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _buildBookmarkButton(),
                  ),
                ],
              ),
    
              // Event details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.cardTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.price.toStringAsFixed(2)}',
                          style: AppTypography.cardPrice,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 18,
                              color: AppColors.gray3,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '1.2 km',
                              style: TextStyle(
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
    );
  }

  Widget _buildDateOverlay() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          height:50,
          width: 50,          
          decoration: BoxDecoration(
            color: AppColors.cardDateBackground.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.date, style: AppTypography.cardDate),
              
              Text(widget.month, style: AppTypography.cardMonth),
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
        child: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                isSaved = !isSaved;
              });
            },
          ),
        ),
      ),
    );
  }
}