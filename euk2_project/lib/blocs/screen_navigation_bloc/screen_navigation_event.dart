part of 'screen_navigation_bloc.dart';

@immutable
abstract class ScreenNavigationEvent {}

class OnSwitchPage extends ScreenNavigationEvent {
  final ScreenType screen;
  OnSwitchPage(int screenIndex) : screen = ScreenType.values[screenIndex];
  OnSwitchPage.screen(this.screen);
}
