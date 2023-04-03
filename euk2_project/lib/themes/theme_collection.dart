import 'package:flutter/material.dart';

ThemeData yellowTheme = ThemeData(
  primarySwatch: Colors.orange,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.orange,
  ),
);


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);


