part of 'theme_switching_bloc.dart';

@immutable
abstract class ThemeSwitchingEvent {}

class OnOpenThemeDialog extends ThemeSwitchingEvent {
  final BuildContext context;

  OnOpenThemeDialog(this.context);
}

class OnSwitchTheme extends ThemeSwitchingEvent {
  final ThemeMode themeMode;

  OnSwitchTheme(this.themeMode);
}