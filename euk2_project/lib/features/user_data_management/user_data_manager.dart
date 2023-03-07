import 'dart:convert';

import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages all of user's saved data.
class UserDataManager {
  SharedPreferences? _prefs;
  int? _initScreen;

  UserDataManager._create();

  /// Creates a new instance of [UserDataManager].
  static Future<UserDataManager> create() async {
    final UserDataManager m = UserDataManager._create();

    m._prefs = await SharedPreferences.getInstance();
    m._initScreen = m._prefs!.getInt('onBoard');
    await m._prefs!.setInt('onBoard', 1);

    return m;
  }

  Future<void> saveEUKLocationData(List<EUKLocationData> data) async {
    final List<String> stringData = [];
    for (final EUKLocationData d in data) {
      final value = json.encode(d.toMap());
      stringData.add(value);
    }

    await _prefs?.setStringList('locationData', stringData);
  }

  List<EUKLocationData> loadEUKLocationData() {
    final List<EUKLocationData> data = [];
    final List<String>? strings = _prefs?.getStringList("locationData");
    for (final String s in strings!) {
      final decoded = json.decode(s) as Map<String, dynamic>;
      data.add(EUKLocationData.fromJson(decoded));
    }

    return data;
  }

  int? get initScreen => _initScreen;
}
