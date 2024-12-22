import 'dart:ui'; // Required for the ImageFilter class
import 'package:flutter/material.dart'; // Required for Flutter UI widgets

void main() => runApp(const CardExampleApp());

class CardExampleApp extends StatelessWidget  {
  const CardExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Card Sample')),
        body:  ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            CardExample(),
            CardExample(
              cardName: "TechFest",
              cardDate: "10 July",
              cardPrice: 240,
              imgSrc: "assets/doodhinspecter.jpg",
            ),
            CardExample(cardName: "Baller",)
          ],
        ),
      ),
    );
  }
}

class CardExample extends StatefulWidget {
  final String cardDate;
  final int cardPrice;
  final String cardName;
  final String imgSrc;
  final bool cardSaved;

  const CardExample({Key? key, 
  this.cardName = "Event Name", 
  this.cardDate = "05 April 1978", 
  this.cardPrice = 100,
  this.imgSrc = "assets/cars.jpg", 
  this.cardSaved = false,
  }):super(key: key);

  @override
  _CardExampleState createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  bool cardSaved = false;
  _CardExampleState();

  @override
  Widget build(BuildContext context) {
    final sizeHelper = ScreenSizeHelper(context);

    return Center(
      child: Container(
        height: sizeHelper.height(29),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: const Color.fromARGB(255, 74, 92, 106).withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
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
                          height:
                              sizeHelper.height(18), // Half the desired height
                          width: sizeHelper.width(58), // 80% of screen width
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter, // Crop to top half
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 5.0, sigmaY: 5.0), // Blur effect
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(165, 255, 255, 255)
                                    .withOpacity(0.3), // Translucent white
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "12", // Placeholder for date
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 17, 33, 45),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "JUNE", // Placeholder for date
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 17, 33, 45),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.5),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 5.0, sigmaY: 5.0), // Blur effect
                            child: Container(
                              height: 34.5,
                              width: 34.5,
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(0.9), // Translucent white
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    cardSaved
                                        ? Icons.bookmark
                                        : Icons
                                            .bookmark_add_outlined, // Toggle icon based on isSaved
                                    color: const Color.fromARGB(255, 17, 33, 45),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      cardSaved =
                                          !cardSaved; // Toggle the saved state when pressed
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.cardName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold), // Replace TextScaler with TextStyle
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.cardPrice.toString(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 25, 25, 117),
                      fontSize: 16, // Adjust size as needed
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenSizeHelper {
  final BuildContext context;

  ScreenSizeHelper(this.context);

  double height(double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  double width(double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }
}
