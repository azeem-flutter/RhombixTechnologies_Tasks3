import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingDotnavigation extends StatelessWidget {
  final PageController controller;

  const OnboardingDotnavigation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: 3,
      effect: ExpandingDotsEffect(
        dotHeight: 8,
        dotWidth: 8,
        spacing: 6,
        expansionFactor: 2.8,
        dotColor: Colors.grey.shade300,
        activeDotColor: const Color(0xFF1F5A2E),
      ),
    );
  }
}
