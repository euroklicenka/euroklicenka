import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MainScreenStates {
  initialState,
  guideState,
  appContentState,
}

class PreferencesModel extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  MainScreenStates mainScreenState = MainScreenStates.initialState;

  Future<void> onInitApp() async {
    if (mainScreenState == MainScreenStates.initialState) {
      final SharedPreferences prefs = await _prefs;
      final bool? isFirstTimeLaunch = prefs.getBool('isFirstTimeLaunch');

      if (isFirstTimeLaunch ?? true) {
        mainScreenState = MainScreenStates.guideState;
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
