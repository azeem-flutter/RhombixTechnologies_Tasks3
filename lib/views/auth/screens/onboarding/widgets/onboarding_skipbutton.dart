import 'package:flutter/material.dart';

class OnboardingSkipbutton extends StatelessWidget {
  const OnboardingSkipbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: kToolbarHeight,
      right: 16,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.grey.withAlpha(77)),
        onPressed: () {},
        child: const Text('Skip', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
