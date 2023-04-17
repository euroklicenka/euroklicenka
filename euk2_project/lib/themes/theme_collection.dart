import 'package:euk2_project/themes/theme_utils.dart';
import 'package:flutter/material.dart';

ThemeData defaultLightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch(
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
  brightness: Brightness.dark,
  primarySwatch: createMaterialColor(Colors.redAccent),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.redAccent,
  ),
);
