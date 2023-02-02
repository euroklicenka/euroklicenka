part of 'screen_navigation_bloc.dart';

@immutable
abstract class ScreenNavigationEvent {}

class OnSwitchPage extends ScreenNavigationEvent {
  final int index;
  OnSwitchPage(this.index);
}
