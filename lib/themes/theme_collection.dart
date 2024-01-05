import 'package:flutter/material.dart';

ThemeData defaultLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    // ···
    brightness: Brightness.light,
  ),
);

ThemeData defaultDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    // ···
    brightness: Brightness.dark,
  ),
);
