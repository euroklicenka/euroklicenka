import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/features/user_data_management/user_data_manager.dart';
import 'package:euk2_project/themes/map_theme_manager.dart';
import 'package:euk2_project/themes/theme_utils.dart';
import 'package:euk2_project/widgets/dialogs/theme_switching_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meta/meta.dart';

part 'theme_switching_event.dart';
part 'theme_switching_state.dart';

///Controls the current theme of the app.
class ThemeSwitchingBloc extends Bloc<ThemeSwitchingEvent, ThemeSwitchingState> {

  late UserDataManager _dataManager;
  late MapThemeManager _mapThemes;

  ThemeMode _currentTheme = ThemeMode.system;
  String _currentMapTheme = '';

  ThemeSwitchingBloc({required UserDataManager dataManager}) : super(ThemeSwitchingSystemState()) {
    _dataManager = dataManager;
    _mapThemes = MapThemeManager();
    on<OnOpenThemeDialog>(_onOpenThemeDialog);
    on<OnSwitchTheme>(_onSwitchTheme);
    _loadThemeFromStorage();
  }

  Future<void> _onSwitchTheme(OnSwitchTheme event, emit) async {
    _currentTheme = event.themeMode;
    _dataManager.saveDefaultTheme(event.themeMode.index);
    switch (_currentTheme) {
      case ThemeMode.system:
        _currentMapTheme = (isDarkModeActive()) ? await _mapThemes.darkTheme : await _mapThemes.lightTheme;
        emit(ThemeSwitchingSystemState());
        break;
      case ThemeMode.light:
        _currentMapTheme = await _mapThemes.lightTheme;
        emit(ThemeSwitchingLightState());
        break;
      case ThemeMode.dark:
        _currentMapTheme = await _mapThemes.darkTheme;
        emit(ThemeSwitchingDarkState());
        break;
    }
  }

  void _onOpenThemeDialog(OnOpenThemeDialog event, emit) {
    openThemeSwitchingDialog(
      context: event.context,
      onSelect: (selectedThemeIndex) {
        add(OnSwitchTheme(ThemeMode.values[selectedThemeIndex]));
        Navigator.pop(event.context);
      },
    );
  }

  ///Load saved theme from storage.
  void _loadThemeFromStorage() {
    final int index = _dataManager.loadDefaultThemeIndex();
    add(OnSwitchTheme(ThemeMode.values[(index != -1) ? index : 0]));
  }

  ThemeMode get currentTheme => _currentTheme;
  String get currentMapTheme => _currentMapTheme;
}
