import 'package:euk2_project/screens/init_screen_bloc/init_screen_bloc.dart';
import 'package:euk2_project/screens/intro_screen.dart';
import 'package:euk2_project/screens/map_page/map_page.dart';
import 'package:euk2_project/screens/splash_screen.dart';
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
    return BlocBuilder<InitScreenBloc, InitScreenState>(
      builder: (context, state) {
        if (state is InitScreenInitialState) {
          return const EUKSplashScreen();
        } else if (state is InitScreenGuideState) {
          return IntroGuideScreen();
        } else {
          return const MapScreen();
        }
      },
    );
  }

}
