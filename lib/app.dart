import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/views/auth/screens/onboarding/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TrailMate',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OnboardingScreen(),
    );
  }
}
