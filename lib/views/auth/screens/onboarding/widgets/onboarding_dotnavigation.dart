import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingDotnavigation extends StatelessWidget {
  const OnboardingDotnavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: SmoothPageIndicator(
          controller: PageController(),
          count: 3,
          effect: const ExpandingDotsEffect(
            dotHeight: 6,
            dotColor: Colors.grey,
            activeDotColor: Colors.deepOrangeAccent,
          ),
        ),
      ),
    );
  }
}
