import 'dart:ui';
import 'package:flutter/material.dart';

/// Application color palette definition
class AppColors {
  // Base colors
  static const white = Color(0xFFFFFFFF);
  static const gray1 = Color(0xFFF5F5F5);
  static const gray2 = Color(0xFFE0E0E0);
  static const gray3 = Color(0xFF9E9E9E);
  static const blue1 = Color(0xFF2C3E50);
  static const blue2 = Color(0xFF34495E);
  
  // Semantic colors
  static const primary = blue1;
  static const secondary = blue2;
  static const background = gray1;
  static const surface = white;
  static const onBackground = blue1;
  static const onSurface = blue1;
  
  // Additional semantic colors
  static const cardDateBackground = Color.fromARGB(165, 0, 0, 0);
  static const cardDateText = Color(0xFFFFFFFF);
  static const priceText = Color(0xFF191975);
}

/// Application typography definition
class AppTypography {
  static const displayLarge = TextStyle(
    color: AppColors.blue1,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );
  
  static const bodyLarge = TextStyle(
    color: AppColors.blue1,
    fontSize: 16.0,
  );
  
  static const bodyMedium = TextStyle(
    color: AppColors.blue2,
    fontSize: 14.0,
  );
  
  static const cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.blue1,
  );
  
  static const cardPrice = TextStyle(
    color: AppColors.priceText,
    fontSize: 16,
  );
  
  static const cardDate = TextStyle(
    color: AppColors.cardDateText,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  
  static const cardMonth = TextStyle(
    color: AppColors.cardDateText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}

/// Main application theme
ThemeData appTheme() {
  return ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
      surface: AppColors.surface,
      onBackground: AppColors.onBackground,
      onSurface: AppColors.onSurface,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.gray3,
    ),
  );
}

/// Main application entry point
void main() => runApp(const CardExampleApp());

/// Root application widget
class CardExampleApp extends StatelessWidget {
  const CardExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(),
      home: Scaffold(
        appBar: AppBar(title: const Text('Event Cards')),
        
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Events"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: "Saved"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"
            ),
          ],
        ),
        
        body: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            CardExample(),
            CardExample(
              cardName: "TechFest",
              cardDate: "10 July",
              cardPrice: 240,
              imgSrc: "assets/doodhinspecter.jpg",
            ),
            CardExample(
              cardName: "Baller",
            ),
          ],
        ),
      ),
    );
  }
}

/// Event card widget with image, date, and save functionality
class CardExample extends StatefulWidget {
  final String cardDate;
  final int cardPrice;
  final String cardName;
  final String imgSrc;
  final bool cardSaved;

  const CardExample({
    Key? key,
    this.cardName = "Event Name",
    this.cardDate = "05 April 1978",
    this.cardPrice = 100,
    this.imgSrc = "assets/cars.jpg",
    this.cardSaved = false,
  }) : super(key: key);

  @override
  _CardExampleState createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  bool cardSaved = false;

  @override
  Widget build(BuildContext context) {
    final sizeHelper = ScreenSizeHelper(context);

    return Center(
      child: SizedBox(
        height: sizeHelper.height(29),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: AppColors.gray2.withAlpha(30),
            onTap: () => debugPrint('Card tapped.'),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          widget.imgSrc,
                          height: sizeHelper.height(18),
                          width: sizeHelper.width(58),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
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
                  
                  const SizedBox(height: 14),
                  
                  Text(widget.cardName, style: AppTypography.cardTitle),
                  const SizedBox(height: 4),
                  Text(
                    "\$${widget.cardPrice}",
                    style: AppTypography.cardPrice,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateOverlay() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.cardDateBackground.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("12", style: AppTypography.cardDate),
              Text("JUNE", style: AppTypography.cardMonth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          height: 34.5,
          width: 34.5,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: IconButton(
              icon: Icon(
                cardSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                color: AppColors.white,
              ),
              onPressed: () => setState(() => cardSaved = !cardSaved),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper class for responsive sizing
class ScreenSizeHelper {
  final BuildContext context;

  ScreenSizeHelper(this.context);

  double height(double percentage) =>
      MediaQuery.of(context).size.height * (percentage / 100);

  double width(double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);
}