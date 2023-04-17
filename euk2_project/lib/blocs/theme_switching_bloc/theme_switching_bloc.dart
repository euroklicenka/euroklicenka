import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/features/user_data_management/user_data_manager.dart';
import 'package:euk2_project/widgets/dialogs/theme_switching_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_switching_event.dart';
part 'theme_switching_state.dart';

///Controls the current theme of the app.
class ThemeSwitchingBloc extends Bloc<ThemeSwitchingEvent, ThemeSwitchingState> {

  late UserDataManager _dataManager;
  ThemeMode _currentTheme = ThemeMode.system;

  ThemeSwitchingBloc({required UserDataManager dataManager}) : super(ThemeSwitchingSystemState()) {
    _dataManager = dataManager;
    on<OnOpenThemeDialog>(_onOpenThemeDialog);
    on<OnSwitchTheme>(_onSwitchTheme);
    _loadThemeFromStorage();
  }

  void _onSwitchTheme(OnSwitchTheme event, emit) {
    _currentTheme = event.themeMode;
    _dataManager.saveDefaultTheme(event.themeMode.index);
    switch (_currentTheme) {
      case ThemeMode.system:
        emit(ThemeSwitchingSystemState());
        break;
      case ThemeMode.light:
        emit(ThemeSwitchingLightState());
        break;
      case ThemeMode.dark:
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
}
