import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/views/auth/login/login.dart';

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
        onPressed: () => Get.to(const LoginScreen()),
        child: const Text('Skip', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
