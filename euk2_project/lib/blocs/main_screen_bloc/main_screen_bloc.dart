import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/features/user_data_management/user_data_manager.dart';
import 'package:flutter/material.dart';

part 'main_screen_event.dart';
part 'main_screen_state.dart';

///Controls the data on the screen.
class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {

  late LocationManagementBloc _locationBloc;
  late UserDataManager _dataManager;

  MainScreenBloc({required LocationManagementBloc locationBloc}) : super(const MainScreenInitialState()) {
    _locationBloc = locationBloc;
    on<OnAppInit>(_onAppInit);
    on<OnInitFinish>(_onInitFinish);
    on<OnOpenGuideScreen>(_onOpenGuideScreen);
  }

  ///Loads the proper screen on startup and initializes variables.
  FutureOr<void> _onAppInit(event, emit) async {
    emit(const MainScreenInitialState());

    _dataManager = await UserDataManager.create();
    await _locationBloc.create(dataManager: _dataManager);

    if (_dataManager.notFirstTimeLaunch == null || _dataManager.notFirstTimeLaunch == false) {
      _onOpenGuideScreen(event, emit);
    } else {

      emit(const MainScreenAppContentState());
      await Future.delayed(const Duration(milliseconds: 500));
      _locationBloc.add(OnFocusOnUserPosition());
      _onInitFinish(event, emit);
    }
  }

  FutureOr<void> _onInitFinish(event, emit) {
    emit(const MainScreenAppContentState());
  }

  FutureOr<void> _onOpenGuideScreen(event, emit) {
    emit(const MainScreenGuideState());
  }

  LocationManagementBloc get locationBloc => _locationBloc;
  UserDataManager get dataManager => _dataManager;
}
