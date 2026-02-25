import 'package:flutter/material.dart';

class OnboardingSkipbutton extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingSkipbutton({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 16,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white.withAlpha(228),
          foregroundColor: const Color(0xFF1F5A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
        onPressed: onSkip,
        child: const Text(
          'Skip',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
