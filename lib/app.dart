import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/core/theme/theme.dart';
import 'package:trailmate/views/auth/screens/onboarding/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TrailMate',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,

      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const OnboardingScreen(),
    );
  }
}
