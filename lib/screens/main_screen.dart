import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:eurokey2/models/preferences_model.dart';
import 'package:eurokey2/screens/app/main_app_screen.dart';
import 'package:eurokey2/screens/intro_guide_screen.dart';
import 'package:eurokey2/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The Main Screen of the app controls what content is shown.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<EurolockModel>().onInitApp();
      if (!context.mounted) return;
      await context.read<PreferencesModel>().onInitApp();
      if (!context.mounted) return;
      await context.read<LocationModel>().onInitApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: Consumer<PreferencesModel>(
          // FIXME: Maybe use routes here?
          builder: (context, state, child) {
            switch (state.mainScreenState) {
              case MainScreenStates.initialState:
                return const EUKSplashScreen();
              case MainScreenStates.guideState:
                return const GuideScreen();
              case MainScreenStates.appContentState:
                return const MainAppScreen();
              default:
                throw 'Barf!';
            }
          },
        ),
      ),
    );
  }
}
