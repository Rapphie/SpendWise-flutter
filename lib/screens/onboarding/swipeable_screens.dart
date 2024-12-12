import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spend_wise/screens/home.dart';
import 'package:spend_wise/themes/app_colors.dart';

class OnboardingSwipeScreens extends StatefulWidget {
  const OnboardingSwipeScreens({super.key});

  @override
  OnboardingSwipeScreensState createState() => OnboardingSwipeScreensState();
}

class OnboardingSwipeScreensState extends State<OnboardingSwipeScreens> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              children: const [
                Center(child: Text('Page 1', style: TextStyle(fontSize: 24))),
                Center(child: Text('Page 2', style: TextStyle(fontSize: 24))),
                Center(child: Text('Page 3', style: TextStyle(fontSize: 24))),
                Center(child: Text('Page 4', style: TextStyle(fontSize: 24))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmoothPageIndicator(
              controller: pageController,
              count: 4,
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Colors.white,
                dotColor: darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
