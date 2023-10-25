part of 'screen_navigation_bloc.dart';

@immutable
abstract class ScreenNavigationState {
  const ScreenNavigationState();
}

class AppScreenMapState extends ScreenNavigationState {
  const AppScreenMapState();
}

class AppScreenListState extends ScreenNavigationState {
  const AppScreenListState();
}

class AppScreenOptionsState extends ScreenNavigationState {
  const AppScreenOptionsState();
}
