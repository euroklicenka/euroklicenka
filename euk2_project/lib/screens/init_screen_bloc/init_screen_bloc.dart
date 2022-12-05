import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'init_screen_event.dart';
part 'init_screen_state.dart';

class InitScreenBloc extends Bloc<InitScreenEvent, InitScreenState> {


  InitScreenBloc() : super(const InitScreenInitialState()) {
    on<OnLoad>((event, emit) async {
      emit(const InitScreenSplashState());
      // await Future.delayed(const Duration(seconds: 3));
      // emit(const InitScreenFinishState());
    });
  }
}
