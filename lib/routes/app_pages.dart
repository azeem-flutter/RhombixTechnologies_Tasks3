import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/controllers/auth/login_controller.dart';
import 'package:trailmate/core/binding/initialbinding.dart';
import 'package:trailmate/models/Trip/trip_model.dart';
import 'package:trailmate/navigation_menu.dart';
import 'package:trailmate/routes/app_routes.dart';
import 'package:trailmate/views/ai_chat/ai_chat_screen.dart';
import 'package:trailmate/views/auth/login/login.dart';
import 'package:trailmate/views/auth/screens/onboarding/onboarding_screen.dart';
import 'package:trailmate/views/auth/signup/signup.dart';
import 'package:trailmate/views/mytrip/screens/my_trips_screen.dart';
import 'package:trailmate/views/packing/screens/ai_packing_screen.dart';
import 'package:trailmate/views/profile/screens/profile_screen.dart';
import 'package:trailmate/views/trip/trip_create_form.dart';
import 'package:trailmate/views/trip/trip_detail_screen.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: Initialbinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: Initialbinding(),
    ),
    GetPage(name: AppRoutes.navigation, page: () => NavigationMenu()),
    GetPage(name: AppRoutes.tripCreate, page: () => const TripCreateForm()),
    GetPage(
      name: AppRoutes.tripDetail,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      page: () {
        final trip = Get.arguments as TripModel?;
        if (trip == null) {
          return const _MissingArgsScreen(title: 'Trip not found');
        }
        return TripDetailScreen(trip: trip);
      },
    ),
    GetPage(name: AppRoutes.aiChat, page: () => const AiChatScreen()),
    GetPage(
      name: AppRoutes.aiPacking,
      page: () {
        final trip = Get.arguments as TripModel?;
        if (trip == null) {
          return const _MissingArgsScreen(title: 'Packing list unavailable');
        }
        return AiPackingScreen(trip: trip);
      },
    ),
    GetPage(
      name: AppRoutes.myTrips,
      page: () {
        final trips = Get.arguments as List<TripModel>? ?? <TripModel>[];
        return MyTripsScreen(trips: trips);
      },
    ),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
  ];
}

class _MissingArgsScreen extends StatelessWidget {
  final String title;

  const _MissingArgsScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TrailMate')),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
