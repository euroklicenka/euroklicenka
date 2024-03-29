// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/providers/location_provider.dart';
import 'package:eurokey2/providers/preferences_provider.dart';
import 'package:eurokey2/screens/app/main_app_screen.dart';
import 'package:eurokey2/screens/intro_guide_screen.dart';
import 'package:eurokey2/screens/splash_screen.dart';
import 'package:eurokey2/themes/theme_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const EUKSplashScreen(),
      redirect: (context, state) {
        final prefs = Provider.of<PreferencesProvider>(context);
        switch (prefs.mainScreenState) {
          case MainScreenStates.initialState:
            return '/splash';
          case MainScreenStates.guideState:
            return '/guide';
          case MainScreenStates.appContentState:
            return '/main/1';
          default:
            throw 'Barf!';
        }
      },
    ),
    GoRoute(
      path: '/guide',
      builder: (context, state) => const GuideScreen(),
      redirect: (context, state) {
        final prefs = Provider.of<PreferencesProvider>(context);
        switch (prefs.mainScreenState) {
          case MainScreenStates.initialState:
            return '/splash';
          case MainScreenStates.guideState:
            return '/guide';
          case MainScreenStates.appContentState:
            return '/main/1';
          default:
            throw 'Barf!';
        }
      },
    ),
    GoRoute(
      path: "/main/:pageId",
      builder: (context, state) =>
          MainAppScreen(id: state.pathParameters['pageId']!),
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterMapTileCaching.initialise();
  await FMTC.instance('mapStore').manage.createAsync();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => PreferencesProvider()),
        ChangeNotifierProvider(create: (context) => EurolockProvider()),
      ],
      builder: (context, child) {
        return Consumer<PreferencesProvider>(
          builder: (context, prefs, child) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: defaultLightTheme,
            darkTheme: defaultDarkTheme,
            themeMode: prefs.themeMode,
            scaffoldMessengerKey: snackBarKey,
            routerConfig: _router,
          ),
        );
      },
    );
  }
}
