import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trailmate/routes/app_routes.dart';
import 'package:trailmate/views/auth/screens/onboarding/widgets/onboarding_dotnavigation.dart';
import 'package:trailmate/views/auth/screens/onboarding/widgets/onboarding_page.dart';
import 'package:trailmate/views/auth/screens/onboarding/widgets/onboarding_skipbutton.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    Get.offAllNamed(AppRoutes.login);
  }

  void _goToNextPage() {
    if (_currentIndex < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children: const [
                  OnboardingPage(
                    image: 'assets/images/camp.jpg',
                    title: 'Plan Your Escape',
                    subTitle:
                        'Discover remote campsites, build a flexible itinerary, and share your adventure plans.',
                  ),
                  OnboardingPage(
                    image: 'assets/images/firecamp.jpg',
                    title: 'AI Smart Packing',
                    subTitle:
                        'Get a weather-aware packing list so you never miss essential gear or supplies.',
                  ),
                  OnboardingPage(
                    image: 'assets/images/forest.jpg',
                    title: 'Survival Ready',
                    subTitle:
                        'Stay safe with bite-size guides, safety tips, and confidence for the outdoors.',
                  ),
                ],
              ),
            ),
            OnboardingSkipbutton(onSkip: _completeOnboarding),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    children: [
                      OnboardingDotnavigation(controller: _controller),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _goToNextPage,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1F5A2E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        iconAlignment: IconAlignment.end,
                        icon: Icon(
                          _currentIndex == 2
                              ? Icons.check_circle_outline_rounded
                              : Icons.arrow_forward_rounded,
                          size: 18,
                        ),
                        label: Text(
                          _currentIndex == 2 ? 'Get Started' : 'Next',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
