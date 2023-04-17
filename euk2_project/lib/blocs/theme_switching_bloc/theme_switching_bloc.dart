import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/widgets/dialogs/theme_switching_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_switching_event.dart';
part 'theme_switching_state.dart';

///Controls the current theme of the app.
class ThemeSwitchingBloc extends Bloc<ThemeSwitchingEvent, ThemeSwitchingState> {
  ThemeMode _currentTheme = ThemeMode.system;

  ThemeSwitchingBloc() : super(ThemeSwitchingDefault()) {
    on<OnOpenThemeDialog>(_onOpenThemeDialog);
    on<OnSwitchTheme>(_onSwitchTheme);
  }

  void _onSwitchTheme(OnSwitchTheme event, emit) {
    _currentTheme = event.themeMode;
    emit(ThemeSwitchingDefault());
  }

  ThemeMode get currentTheme => _currentTheme;

  void _onOpenThemeDialog(OnOpenThemeDialog event, emit) {
    openThemeSwitchingDialog(
        context: event.context,
        onSelect: (selectedThemeIndex) {
          add(OnSwitchTheme(ThemeMode.values[selectedThemeIndex]));
          Navigator.pop(event.context);
        },
    );
  }
}
