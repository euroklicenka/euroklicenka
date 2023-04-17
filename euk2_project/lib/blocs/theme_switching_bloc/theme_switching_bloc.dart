import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_switching_event.dart';
part 'theme_switching_state.dart';

class ThemeSwitchingBloc extends Bloc<ThemeSwitchingEvent, ThemeSwitchingState> {
  ThemeData _currentTheme;

  ThemeSwitchingBloc({required ThemeData initialTheme})
      : _currentTheme = initialTheme,
        super(ThemeSwitchingInitial(initialTheme));

  @override
  Stream<ThemeSwitchingState> mapEventToState(ThemeSwitchingEvent event) async* {
    if (event is ThemeChanged) {
      _currentTheme = event.theme;
      yield ThemeSwitchingInitial(_currentTheme);
    }
  }

  ThemeData get currentTheme => _currentTheme;
}
