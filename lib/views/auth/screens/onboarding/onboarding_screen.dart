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
                title: 'Welcome to TrailMate',
                subTitle: 'Your adventure starts here',
              ),
              OnboardingPage(
                image: 'assets/images/firecamp.jpg',
                title: 'Explore New Trails',
                subTitle: 'Discover hidden gems in nature',
              ),
              OnboardingPage(
                image: 'assets/images/forest.jpg',
                title: 'Connect with Nature',
                subTitle: 'Experience the great outdoors',
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
