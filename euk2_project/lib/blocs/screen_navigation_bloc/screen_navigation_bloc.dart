import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/screens/app/extras/information_screen.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'screen_navigation_event.dart';

part 'screen_navigation_state.dart';

///Controls user navigation between app screens.
class ScreenNavigationBloc extends Bloc<ScreenNavigationEvent, ScreenNavigationState> {
  ScreenType currentScreen = ScreenType.map;

  ScreenNavigationBloc() : super(const AppScreenMap()) {
    on<OnSwitchPage>(_onSwitchPage);
    on<OnOpenInformation>(_onOpenNavigation);
  }

  void _onSwitchPage(OnSwitchPage event, emit) {
    currentScreen = event.screen;
    switch (currentScreen) {
      case ScreenType.list:
        emit(const AppScreenList());
        break;
      case ScreenType.map:
        emit(const AppScreenMap());
        break;
      case ScreenType.options:
        emit(const AppScreenOptions());
        break;
    }
  }

  void _onOpenNavigation(OnOpenInformation event, emit) {
    Navigator.push(event.context, MaterialPageRoute(builder: (context) => const InformationScreen()));
  }
}

enum ScreenType {list, map, options}
