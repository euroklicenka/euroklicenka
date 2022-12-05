import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/location_data/data/euk_marker.dart';
import 'package:euk2_project/location_data/location_data_manager.dart';
import 'package:euk2_project/user_data_management/user_data_manager.dart';
import 'package:flutter/material.dart';

part 'main_screen_event.dart';

part 'main_screen_state.dart';

///Controls the data on the screen.
class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  UserDataManager? dataManager;
  EUKLocationDataManager? locationManager;
  late CustomInfoWindowController windowController;

  MainScreenBloc() : super(const MainScreenInitialState()) {
    windowController = CustomInfoWindowController();

    on<OnAppInit>(_onAppInit);
  }

  ///Loads the proper screen on startup and initializes variables.
  FutureOr<void> _onAppInit(event, emit) async {
    emit(const MainScreenInitialState());

    dataManager = await UserDataManager.create();
    locationManager = EUKLocationDataManager.create();

    if (dataManager?.initScreen == null || dataManager?.initScreen == 0) {
      emit(const MainScreenGuideState());
    } else {

      //TODO Heat up Google maps before app load.
      //TODO Build markers here before app load.

      emit(const MainScreenMapState());
    }
  }
}
