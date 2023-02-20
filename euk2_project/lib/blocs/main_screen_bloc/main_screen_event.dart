part of 'main_screen_bloc.dart';

@immutable
abstract class MainScreenEvent {}

///Is called when it is time to load the map screen.
class OnAppInit extends MainScreenEvent {}
class OnInitFinish extends MainScreenEvent {}
class OnOpenGuideScreen extends MainScreenEvent {}
