import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/core/binding/initialbinding.dart';
import 'package:trailmate/core/theme/theme.dart';
import 'package:trailmate/routes/app_pages.dart';
import 'package:trailmate/routes/app_routes.dart';

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
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      initialBinding: Initialbinding(),
    );
  }
}
