part of 'screen_navigation_bloc.dart';

@immutable
abstract class ScreenNavigationState {
  const ScreenNavigationState();
}

class AppScreenMap extends ScreenNavigationState {
  const AppScreenMap();
}

class AppScreenList extends ScreenNavigationState {
  const AppScreenList();
}

class AppScreenOptions extends ScreenNavigationState {
  const AppScreenOptions();
}
