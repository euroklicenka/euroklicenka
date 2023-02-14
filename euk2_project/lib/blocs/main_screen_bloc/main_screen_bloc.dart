import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/features/user_data_management/user_data_manager.dart';
import 'package:flutter/material.dart';

part 'main_screen_event.dart';

part 'main_screen_state.dart';

///Controls the data on the screen.
class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final LocationManagementBloc locationBloc;

  late UserDataManager dataManager;

  MainScreenBloc({required this.locationBloc}) : super(const MainScreenInitialState()) {
    on<OnAppInit>(_onAppInit);
    on<OnInitFinish>(_onInitFinish);
  }

  ///Loads the proper screen on startup and initializes variables.
  FutureOr<void> _onAppInit(event, emit) async {
    emit(const MainScreenInitialState());

    dataManager = await UserDataManager.create();
    await locationBloc.create();

    if (dataManager.initScreen == null || dataManager.initScreen == 0) {
      emit(const MainScreenGuideState());
    } else {

      //TODO Heat up Google maps before app load.
      //TODO Build markers here before app load.

      _onInitFinish(event, emit);
    }
  }

  FutureOr<void> _onInitFinish(event, emit) {
    emit(const MainScreenMapState());
  }
}
