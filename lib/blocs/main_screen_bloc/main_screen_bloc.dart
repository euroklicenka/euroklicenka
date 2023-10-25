import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eurokey2/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:eurokey2/features/data_management/user_data_manager.dart';
import 'package:eurokey2/features/internet_access/http_communicator.dart';
import 'package:flutter/material.dart';

part 'main_screen_event.dart';
part 'main_screen_state.dart';

///Controls the data on the screen.
class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  late LocationManagementBloc _locationBloc;
  late UserDataManager _dataManager;

  MainScreenBloc({required UserDataManager dataManager, required LocationManagementBloc locationBloc}) : super(const MainScreenInitialState()) {
    _dataManager = dataManager;
    _locationBloc = locationBloc;
    on<OnAppInit>(_onAppInit);
    on<OnInitFinish>(_onInitFinish);
    on<OnOpenGuideScreen>(_onOpenGuideScreen);
  }

  ///Loads the proper screen on startup and initializes variables.
  FutureOr<void> _onAppInit(event, emit) async {
    emit(const MainScreenInitialState());

    _locationBloc.add(OnInitialize(
      dataManager: _dataManager,
      onFinish: () async {
        if (_dataManager.notFirstTimeLaunch == null || _dataManager.notFirstTimeLaunch == false) {
          add(OnOpenGuideScreen());
        } else {
          await Future.delayed(const Duration(milliseconds: 500));
          _locationBloc.add(OnFocusOnUserPosition());
          add(OnInitFinish());
        }
      },
    ));
  }

  FutureOr<void> _onInitFinish(event, emit) async {
    if (_dataManager.notFirstTimeLaunch == null || _dataManager.notFirstTimeLaunch == false) {
      await checkInternetAccess(errorMessage: 'Zařízení není připojené k internetu.\nDatabáze míst se nemusela aktualizovat.');
    }
    emit(const MainScreenAppContentState());
  }

  FutureOr<void> _onOpenGuideScreen(event, emit) {
    emit(const MainScreenGuideState());
  }

  LocationManagementBloc get locationBloc => _locationBloc;
}
