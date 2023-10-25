import 'package:eurokey2/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:eurokey2/screens/app/main_app_screen.dart';
import 'package:eurokey2/screens/intro_guide_screen.dart';
import 'package:eurokey2/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The Main Screen of the app controls what content is shown.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: _getScreen(state),
          ),
        );
      },
    );
  }

  ///Returns a screen based on the [state] of [MainScreenBloc].
  Widget _getScreen(MainScreenState state) {
    if (state is MainScreenInitialState) {
      return const EUKSplashScreen();
    } else if (state is MainScreenGuideState) {
      return const GuideScreen();
    } else {
      return const MainAppScreen();
    }
  }
}
