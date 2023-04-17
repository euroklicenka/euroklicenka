part of 'theme_switching_bloc.dart';

@immutable
abstract class ThemeSwitchingState {}

class ThemeSwitchingInitial extends ThemeSwitchingState {
  final ThemeData theme;

  ThemeSwitchingInitial(this.theme);
}