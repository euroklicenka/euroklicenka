import 'package:flutter/material.dart';

ThemeData yellowTheme = ThemeData(
  primarySwatch: Colors.amber,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.amber,
  ),
);


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);


