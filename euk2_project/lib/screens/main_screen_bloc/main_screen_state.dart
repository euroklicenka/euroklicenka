part of 'main_screen_bloc.dart';

@immutable
abstract class MainScreenState {
  const MainScreenState();
}

class MainScreenInitialState extends MainScreenState {
  const MainScreenInitialState();
}

class MainScreenGuideState extends MainScreenState {
  const MainScreenGuideState();
}

class MainScreenMapState extends MainScreenState {
  final Set<EUKMarker> markers;

  const MainScreenMapState(this.markers);

}
