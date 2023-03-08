import 'dart:convert';

import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages all of user's saved data.
class UserDataManager {

  static const String _notFirstTimeLaunchPref = 'isFirstTimeLaunch';
  static const String _locationDataPref = 'locationData';

  SharedPreferences? _prefs;
  bool? _initScreen;

  UserDataManager._create();

  /// Creates a new instance of [UserDataManager].
  static Future<UserDataManager> create() async {

    final UserDataManager m = UserDataManager._create();
    m._prefs = await SharedPreferences.getInstance();

    m._initScreen = m._prefs!.getBool(_notFirstTimeLaunchPref);
    await m._prefs!.setBool(_notFirstTimeLaunchPref, true);

    return m;
  }

  ///Save EUK Location data onto the current device.
  Future<void> saveEUKLocationData(List<EUKLocationData> data) async {
    final List<String> stringData = [];
    for (final EUKLocationData d in data) {
      final value = json.encode(d.toMap());
      stringData.add(value);
    }
    await _prefs!.setStringList(_locationDataPref, stringData);
  }

  ///Try to load EUK Location data from the current device.
  List<EUKLocationData> loadEUKLocationData() {
    final List<EUKLocationData> data = [];
    final List<String> listOfStrings = _prefs?.getStringList(_locationDataPref) ?? [];

    for (final String s in listOfStrings) {
      final decoded = json.decode(s) as Map<String, dynamic>;
      data.add(EUKLocationData.fromJson(decoded));
    }

    return data;
  }

  bool? get notFirstTimeLaunch => _initScreen;
}
