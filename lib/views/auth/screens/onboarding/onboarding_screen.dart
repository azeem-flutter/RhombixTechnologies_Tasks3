import 'package:flutter/material.dart';
import 'package:trailmate/views/auth/screens/onboarding/widgets/onboarding_dotnavigation.dart';
import 'package:trailmate/views/auth/screens/onboarding/widgets/onboarding_page.dart';
import 'package:trailmate/views/auth/screens/onboarding/widgets/onboarding_skipbutton.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          PageView(
            controller: PageController(),
            scrollDirection: Axis.horizontal,
            children: const [
              OnboardingPage(
                image: 'assets/images/camp.jpg',
                title: 'Plan Your Escape',
                subTitle:
                    'Discover remote campsites and plan your route with precision.',
              ),
              OnboardingPage(
                image: 'assets/images/firecamp.jpg',
                title: 'AI Smart Packing',
                subTitle:
                    'Never forget a tent stake again. Our AI generates tailored lists based on weather',
              ),
              OnboardingPage(
                image: 'assets/images/forest.jpg',
                title: 'Survival Ready',
                subTitle:
                    'Learn expert techniques and get assistance in the wild, even offline.',
              ),
            ],
          ),

          // Bottom dot navigation
          const OnboardingSkipbutton(),
          // Add dot navigation widget here
          const OnboardingDotnavigation(),
        ],
      ),
    );
  }
}
