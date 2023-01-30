part of 'main_app_screen_bloc.dart';

@immutable
abstract class MainAppScreenEvent {}

class OnSwitchPage extends MainAppScreenEvent {
  final int index;
  OnSwitchPage(this.index);
}
