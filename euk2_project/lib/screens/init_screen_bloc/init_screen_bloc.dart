import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:euk2_project/user_data_management/user_data_manager.dart';
import 'package:flutter/material.dart';

part 'init_screen_event.dart';

part 'init_screen_state.dart';

///Controls the data on teh screen
class MainScreenBloc extends Bloc<InitScreenEvent, InitScreenState> {
  UserDataManager? dataManager;

  MainScreenBloc() : super(const InitScreenInitialState()) {
    on<OnLoad>(_onLoad);
  }

  ///Loads the proper screen on startup and initializes variables.
  FutureOr<void> _onLoad(event, emit) async {
    emit(const InitScreenInitialState());
    dataManager = await UserDataManager.create();

    if (dataManager?.initScreen == null || dataManager?.initScreen == 0) {
      emit(const InitScreenGuideState());
    } else {
      //TODO Heat up Google maps before showing.
      emit(const InitScreenFinishState());
    }
  }
}
