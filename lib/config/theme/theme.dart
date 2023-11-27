import 'package:cardly/config/theme/color.dart';
import 'package:flutter/material.dart';

class ThemeCard {
  static ThemeData initialThemeData = ThemeData(
    fontFamily: "Poppins",
    colorSchemeSeed: BrandColor.primaryColor,
    appBarTheme: const AppBarTheme(
      // backgroundColor: BrandColor.transparent,
      elevation: 0,
    ),
  );
}
