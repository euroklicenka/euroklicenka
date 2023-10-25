import 'package:flutter/services.dart';

///Controls access to Google Map themes.
class MapThemeManager {
  String? _lightTheme;
  String? _darkTheme;

  Future<void> _loadThemes() async {
    _lightTheme = await rootBundle.loadString('assets/map_styles/light.json');
    _darkTheme = await rootBundle.loadString('assets/map_styles/dark.json');
  }

  Future<String> get darkTheme async {
    if (_darkTheme == null) await _loadThemes();
    return _darkTheme!;
  }

  Future<String> get lightTheme async {
    if (_lightTheme == null) await _loadThemes();
    return _lightTheme!;
  }
}
