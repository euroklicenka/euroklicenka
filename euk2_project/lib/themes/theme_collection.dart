import 'package:euk2_project/themes/theme_utils.dart';
import 'package:flutter/material.dart';


ThemeData defaultLightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.light,
    primarySwatch: createMaterialColor(Colors.deepOrangeAccent),
  ).copyWith(
    secondary: const Color(0xFFE95473),
  ),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.deepOrangeAccent,
  ),
);

ThemeData defaultDarkTheme = ThemeData(
  canvasColor: const Color(0xFF111111),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    primarySwatch: createMaterialColor(Colors.red),
  ).copyWith(
    secondary: Colors.red,
    surface: const Color(0xFF111111),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  ),
  snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
    contentTextStyle: TextStyle(
      color: Colors.white70,
    ),
  ),
);
