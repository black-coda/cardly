import 'package:cardly/config/theme/color.dart';
import 'package:flutter/material.dart';

class ThemeCard {
  static ThemeData initialThemeData = ThemeData(
    fontFamily: "Poppins",
    scaffoldBackgroundColor: BrandColor.white,
    colorSchemeSeed: BrandColor.primaryColor,
    appBarTheme: const AppBarTheme(
      // backgroundColor: BrandColor.transparent,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: BrandColor.black,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
  );
}
