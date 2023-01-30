import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'main_app_screen_event.dart';
part 'main_app_screen_state.dart';

class MainAppScreenBloc extends Bloc<MainAppScreenEvent, MainAppScreenState> {
  int currentScreenIndex = 0;

  MainAppScreenBloc() : super(const AppScreenMap()) {
    on<OnSwitchPage>(_onSwitchPage);
  }

  void _onSwitchPage(OnSwitchPage event, emit) {
      currentScreenIndex = event.index;
      switch(currentScreenIndex) {
        case 0:
          emit(const AppScreenMap());
          break;
        case 1:
          emit(const AppScreenList());
          break;
        case 2:
          emit(const AppScreenOptions());
          break;
      }
}

}
