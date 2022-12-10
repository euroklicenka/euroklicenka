import 'package:flutter/material.dart';

/// Controls the Theme of the app.
class ThemeManager with ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  void changeTheme(bool isDark) {
    _mode = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get themeMode => _mode;
}
