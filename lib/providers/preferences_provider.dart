// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MainScreenStates {
  initialState,
  guideState,
  listScreenState,
  mapScreenState,
  aboutScreenState,
}

class PreferencesProvider extends ChangeNotifier {
  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();
  MainScreenStates _mainScreenState = MainScreenStates.initialState;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  MainScreenStates get mainScreenState => _mainScreenState;

  set mainScreenState(MainScreenStates state) {
    _mainScreenState = state;
    notifyListeners();
  }

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> initialize() async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;
    final bool? isFirstTimeLaunch =
        sharedPreferences.getBool('isFirstTimeLaunch');

    print(isFirstTimeLaunch);

    if (isFirstTimeLaunch ?? true) {
      _mainScreenState = MainScreenStates.guideState;
    } else {
      _mainScreenState = MainScreenStates.mapScreenState;
    }
  }

  Future<void> guideScreenDone() async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    // FIXME: Change this to 'false' if you want to hide the guide
    sharedPreferences.setBool('isFirstTimeLaunch', true);

    _mainScreenState = MainScreenStates.mapScreenState;

    notifyListeners();
  }
}
