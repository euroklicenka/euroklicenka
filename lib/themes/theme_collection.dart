import 'package:eurokey2/themes/theme_utils.dart';
import 'package:flutter/material.dart';

ThemeData defaultLightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: createMaterialColor(Colors.deepOrangeAccent),
  ).copyWith(
    secondary: const Color(0xFFE95473),
  ),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Colors.deepOrangeAccent,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.deepOrangeAccent,
  ),
);

ThemeData defaultDarkTheme = ThemeData(
  canvasColor: const Color(0xFF111111),
  scrollbarTheme: const ScrollbarThemeData()
      .copyWith(thumbColor: MaterialStateProperty.all(const Color(0xFF464646))),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
  ).copyWith(
    secondary: Colors.red,
    surface: const Color(0xFF111111),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF111111),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(
      color: Colors.white70,
    ),
  ),
);
