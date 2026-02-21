import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/routes/app_routes.dart';

class OnboardingSkipbutton extends StatelessWidget {
  const OnboardingSkipbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: kToolbarHeight,
      right: 16,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey.withAlpha(200),
        ),
        onPressed: () => Get.toNamed(AppRoutes.login),
        child: const Text('Skip', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
