part of 'main_app_screen_bloc.dart';

@immutable
abstract class MainAppScreenState {
  const MainAppScreenState();
}

class AppScreenMap extends MainAppScreenState {
  const AppScreenMap();
}

class AppScreenList extends MainAppScreenState {
  const AppScreenList();
}

class AppScreenOptions extends MainAppScreenState {
  const AppScreenOptions();
}
