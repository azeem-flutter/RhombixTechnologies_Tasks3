import 'package:flutter/material.dart';

class TElevatedButtonTheme {
  // make prvate constructor to prevent instantiation
  TElevatedButtonTheme._();

  // Define your ElevatedButtonThemeData here
  static ElevatedButtonThemeData get lightELevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 25),
          backgroundColor: const Color.fromARGB(255, 15, 41, 15),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.withAlpha(77),
          disabledForegroundColor: Colors.white.withAlpha(77),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      );

  // Define your dark ElevatedButtonThemeData here
  static ElevatedButtonThemeData get darkElevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 17, 46, 17),
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.withAlpha(77),
          disabledForegroundColor: Colors.white.withAlpha(77),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      );
}
