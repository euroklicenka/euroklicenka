// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MainScreenStates {
  listScreenState,
  mapScreenState,
  aboutScreenState,
}

class PreferencesProvider extends ChangeNotifier {
  late SharedPreferences _sharedPreferences;

  bool _showGuideScreen = true;
  bool get showGuideScreen => _showGuideScreen;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  Locale? _locale;
  Locale? get locale => _locale;
  set locale(Locale? locale) {
    _locale = locale;

    if (locale?.languageCode != null) {
      _sharedPreferences.setString('language', locale!.languageCode);
    }

    notifyListeners();
  }

  MainScreenStates _mainScreenState = MainScreenStates.mapScreenState;
  MainScreenStates get mainScreenState => _mainScreenState;
  set mainScreenState(MainScreenStates state) {
    _mainScreenState = state;
    notifyListeners();
  }

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    final bool? isFirstTimeLaunch =
        _sharedPreferences.getBool('isFirstTimeLaunch');
    _showGuideScreen = !(isFirstTimeLaunch ?? true);

    final String? languageCode = _sharedPreferences.getString('language');
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }
  }

  Future<void> guideScreenDone() async {
    _sharedPreferences.setBool('isFirstTimeLaunch', false);
    _showGuideScreen = false;
  }
}
