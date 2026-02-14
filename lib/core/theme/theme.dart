import 'package:flutter/material.dart';
import 'package:trailmate/core/theme/elevated_button_theme.dart';
import 'package:trailmate/core/theme/outlined_button_theme.dart';
import 'package:trailmate/core/theme/text_field_theme.dart';
import 'package:trailmate/core/theme/text_theme.dart';

class TAppTheme {
  // Private constructor to prevent instantiation
  TAppTheme._();
  // Define your theme data here, for example:
  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'Poppins',
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightELevatedButtonTheme,
    inputDecorationTheme: TTextFieldTheme.lightTextFieldTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
  );

  static ThemeData get darkTheme => ThemeData(
    fontFamily: 'Poppins',
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: TTextFieldTheme.darkTextFieldTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
  );
}
