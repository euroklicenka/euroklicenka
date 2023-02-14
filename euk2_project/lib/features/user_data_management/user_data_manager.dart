import 'package:shared_preferences/shared_preferences.dart';

/// Manages all of user's saved data.
class UserDataManager {
  late SharedPreferences _prefs;
  int? _initScreen;

  UserDataManager._create();

  /// Creates a new instance of [UserDataManager].
  static Future<UserDataManager> create() async {
    final UserDataManager m = UserDataManager._create();

    m._prefs = await SharedPreferences.getInstance();
    m._initScreen = m._prefs.getInt('onBoard');
    await m._prefs.setInt('onBoard', 1);

    return m;
  }

  int? get initScreen => _initScreen;
}
