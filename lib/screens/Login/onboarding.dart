import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/home/main_navigation_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<Onboarding> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: _onPageChanged,
              children: const [
                OnboardingPage(
                  image: 'assets/cars.jpg',
                  title: 'Discover Upcoming Campus Events — Never Miss Out!',
                  subtitle: 'Up to date catalogue of ongoing events on campus',
                ),
                OnboardingPage(
                  image: 'assets/Ghoda.jpg',
                  title: 'Save interesting events to share with your friends',
                  subtitle: 'You can save events and mark them for later',
                ),
                OnboardingPage(
                  image: 'assets/doodhinspecter.jpg',
                  title: 'Never miss an event',
                  subtitle:
                      'Select clubs to get notified every time they post a new event',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Skip', style: TextStyle(fontSize: 16)),
                ),
                Row(
                  children:
                      List.generate(3, (index) => buildDot(index, context)),
                ),
                TextButton(
                  onPressed: () {
                    if (_currentPage == 2) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const MainNavigationScreen()),
                      );
                      // Navigate to home screen or another page // TODO : Navigate to login screen
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(_currentPage == 2 ? 'Finish' : 'Next',
                      style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 12 : 8,
      height: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
