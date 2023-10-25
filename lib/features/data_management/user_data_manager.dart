import 'dart:convert';

import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages all of user's saved data.
class UserDataManager {

  static const String _notFirstTimeLaunchPref = 'isFirstTimeLaunch';
  static const String _defaultMapAppIndexPref = 'defaultMapAppIndex';
  static const String _defaultThemeIndexPref = 'defaultThemeIndex';
  static const String _locationDataPref = 'locationData';
  static const String _searchOnlineOnStartupPref = 'searchOnlineOnStartup';

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

  ///Save a map app index.
  Future<void> saveDefaultMapApp(int index) async {
    await _prefs!.setInt(_defaultMapAppIndexPref, index);
  }

  ///Get the currently saved map app index. If there is none, returns -1.
  int loadDefaultMapAppIndex() {
    final int? defaultMapAppIndex = _prefs!.getInt(_defaultMapAppIndexPref);
    return (defaultMapAppIndex == null) ? -1 : defaultMapAppIndex;
  }

  ///Save an app theme index.
  Future<void> saveDefaultTheme(int index) async {
    await _prefs!.setInt(_defaultThemeIndexPref, index);
  }

  ///Get the currently saved app theme index. If there is none, returns -1.
  int loadDefaultThemeIndex() {
    final int? defaultThemeIndex = _prefs!.getInt(_defaultThemeIndexPref);
    return (defaultThemeIndex == null) ? -1 : defaultThemeIndex;
  }

  ///Save the current decision about checking for data online.
  Future<void> saveOnlineCheckDecision(bool checkOnStartup) async {
    await _prefs!.setBool(_searchOnlineOnStartupPref, checkOnStartup);
  }

  ///Get the saved decision about check for data at startup. Returns TRUE when save is found.
  bool loadOnlineCheckDecision() {
    return _prefs!.getBool(_searchOnlineOnStartupPref) ?? true;
  }

  bool? get notFirstTimeLaunch => _initScreen;
}
