import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/fonts.dart';
import 'package:flutter/material.dart';

class ThemeConfig {
  static AppBarTheme appBarTheme = AppBarTheme(
      color: CbColors.white,
      iconTheme: IconThemeData(
        color: CbColors.cAccentBase,
      ));

  static BottomNavigationBarThemeData bottomNavigationBarThemeData =
      BottomNavigationBarThemeData(
          backgroundColor: CbColors.white,
          selectedItemColor: CbColors.cPrimaryBase,
          selectedLabelStyle:
              TextStyle(fontFamily: CbFonts.circular, fontSize: 12),
          unselectedLabelStyle:
              TextStyle(fontFamily: CbFonts.circular, fontSize: 12),
          unselectedItemColor: CbColors.cDarken4);

  static ThemeData defaultTheme = ThemeData(
      primaryColor: CbColors.cPrimaryBase,
      appBarTheme: appBarTheme,
      dividerTheme: DividerThemeData(color: Colors.transparent),
      brightness: Brightness.light,
      bottomNavigationBarTheme: bottomNavigationBarThemeData);
}
