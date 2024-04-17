// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData defaultLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(245, 255, 107, 38),
    secondary: Color.fromARGB(245, 255, 107, 38),
    onSecondary: Color.fromARGB(255, 255, 255, 255),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
    size: 23.0,
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.white,
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(
        Colors.white,
      ),
      backgroundColor: MaterialStatePropertyAll(
        Color.fromARGB(245, 255, 107, 38),
      ),
      iconColor: MaterialStatePropertyAll(
        Colors.white,
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(245, 255, 107, 38),
      statusBarIconBrightness: Brightness.light 
    ),
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
