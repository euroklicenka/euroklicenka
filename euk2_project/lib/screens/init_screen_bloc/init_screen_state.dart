part of 'init_screen_bloc.dart';

@immutable
abstract class InitScreenState {
  const InitScreenState();
}

class InitScreenInitialState extends InitScreenState {
  const InitScreenInitialState();
}

class InitScreenSplashState extends InitScreenState {
  const InitScreenSplashState();
}

class InitScreenGuideState extends InitScreenState {
  const InitScreenGuideState();
}

class InitScreenFinishState extends InitScreenState {
  const InitScreenFinishState();

}
