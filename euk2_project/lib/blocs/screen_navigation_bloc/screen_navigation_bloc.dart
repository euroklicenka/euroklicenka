import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'screen_navigation_event.dart';

part 'screen_navigation_state.dart';

///Controls user navigation between app screens.
class ScreenNavigationBloc extends Bloc<ScreenNavigationEvent, ScreenNavigationState> {
  ScreenType currentScreen = ScreenType.map;

  ScreenNavigationBloc() : super(const AppScreenMap()) {
    on<OnSwitchPage>(_onSwitchPage);
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
}

enum ScreenType {list, map, options}
