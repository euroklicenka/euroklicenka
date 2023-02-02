import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'screen_navigation_event.dart';
part 'screen_navigation_state.dart';

///Controls user navigation between app screens.
class ScreenNavigationBloc extends Bloc<ScreenNavigationEvent, ScreenNavigationState> {
  int currentScreenIndex = 1;

  ScreenNavigationBloc() : super(const AppScreenMap()) {
    on<OnSwitchPage>(_onSwitchPage);
  }

  void _onSwitchPage(OnSwitchPage event, emit) {
      currentScreenIndex = event.index;
      switch(currentScreenIndex) {
        case 0:
          emit(const AppScreenList());
          break;
        case 1:
          emit(const AppScreenMap());
          break;
        case 2:
          emit(const AppScreenOptions());
          break;
      }
}

}
