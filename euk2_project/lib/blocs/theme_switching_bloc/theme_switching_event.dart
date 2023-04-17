part of 'theme_switching_bloc.dart';

@immutable
abstract class ThemeSwitchingEvent {
  const ThemeSwitchingEvent();
}

class ThemeChanged extends ThemeSwitchingEvent {
  final ThemeData theme;

  const ThemeChanged({required this.theme});
}
