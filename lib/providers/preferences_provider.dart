import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MainScreenStates {
  initialState,
  guideState,
  appContentState,
}

class PreferencesProvider extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  MainScreenStates mainScreenState = MainScreenStates.initialState;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> onInitApp() async {
    if (mainScreenState == MainScreenStates.initialState) {
      final SharedPreferences prefs = await _prefs;
      final bool? isFirstTimeLaunch = prefs.getBool('isFirstTimeLaunch');

      if (isFirstTimeLaunch ?? true) {
        // mainScreenState = MainScreenStates.guideState;
        // FIXME
        mainScreenState = MainScreenStates.initialState;
      }
      notifyListeners();
    }
  }

  Future<void> onInitFinish() async {
    final SharedPreferences prefs = await _prefs;

    prefs.setBool('isFirstTimeLaunch', false);

    mainScreenState = MainScreenStates.appContentState;

    notifyListeners();
  }
}
