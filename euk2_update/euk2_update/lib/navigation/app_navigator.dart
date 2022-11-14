import 'package:euk2_project/navigation/page_info.dart';
import 'package:euk2_project/pages/list_page.dart';
import 'package:euk2_project/pages/map_page.dart';
import 'package:euk2_project/pages/settings_page.dart';
import 'package:flutter/material.dart';

/// Controls the navigation between pages.
class AppNavigator {

  PreferredSizeWidget? _currentAppBar = AppBar();
  Widget _currentBody = Column();
  List<PageInfo> _screens = [];

  int _screenIndex = 0;

  AppNavigator({int defaultPage = 0}) {
    _screens = [
      PageInfo(listAppBar, ListPage()),
      PageInfo(mapAppBar, MapPage()),
      PageInfo(settingsAppBar, SettingsPage()),
    ];

    navigate(defaultPage);
  }

  void navigate(int screenIndex) {
    _currentAppBar = _screens[screenIndex].appBar;
    _currentBody = _screens[screenIndex].body;
    _screenIndex = screenIndex;
  }

  PreferredSizeWidget? get currentAppBar => _currentAppBar;
  Widget get currentBody => _currentBody;
  int get screenIndex => _screenIndex;
}
