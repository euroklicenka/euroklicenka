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
  colorScheme: ColorScheme.fromSwatch(
  primarySwatch: createMaterialColor(Colors.brown),
).copyWith(
  secondary: const Color(0xFF4E342E),
),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.teal,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.grey,
  ),
);

