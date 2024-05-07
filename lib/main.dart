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
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:eurokey2/features/icon_management/icon_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  Intl.defaultLocale = 'cs_CZ';
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await FMTCObjectBoxBackend().initialise();
  await const FMTCStore('mapStore').manage.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> initialize(BuildContext context) async {
    final eurolockProvider = context.read<EurolockProvider>();
    final preferencesProvider = context.read<PreferencesProvider>();
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    await precacheMarkerIcon(context);

    await eurolockProvider.onInitApp().catchError((e) {
      showSnackBar(message: e.toString());
    });

    await preferencesProvider.initialize().catchError((e) {
      showSnackBar(message: e.toString());
    });

    await locationProvider.handlePermissions().catchError((e) {
      showSnackBar(message: e.toString());
    });

    await locationProvider.getCurrentPosition().catchError((e) {
      showSnackBar(message: e.toString());
      return null;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => PreferencesProvider()),
        ChangeNotifierProvider(create: (context) => EurolockProvider()),
      ],
      builder: (context, child) {
        return FutureBuilder<bool>(
          future: initialize(context),
          builder: (context, snapshot) {
            Widget returnWidget = MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const SplashScreen(),
            ); //

            if (snapshot.hasData) {
              // FlutterNativeSplash.remove();

              returnWidget = Consumer<PreferencesProvider>(
                builder: (context, sharedPreferencesProvider, child) {
                  final Widget homeWidget;

                  switch (sharedPreferencesProvider.mainScreenState) {
                    case MainScreenStates.initialState:
                      throw ("We should not be in initialState");
                    case MainScreenStates.guideState:
                      homeWidget = const GuideScreen();
                    case MainScreenStates.listScreenState:
                    case MainScreenStates.mapScreenState:
                    case MainScreenStates.aboutScreenState:
                      homeWidget = const MainAppScreen();
                    default:
                      print(sharedPreferencesProvider.mainScreenState);
                      throw ("invalid state ${sharedPreferencesProvider.mainScreenState}");
                  }

                  return MaterialApp(
                    onGenerateTitle: (context) =>
                        AppLocalizations.of(context)!.appTitle,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    debugShowCheckedModeBanner: false,
                    theme: defaultLightTheme,
                    darkTheme: defaultDarkTheme,
                    themeMode: sharedPreferencesProvider.themeMode,
                    scaffoldMessengerKey: snackBarKey,
                    home: homeWidget,
                  );
                },
              );
            } else if (snapshot.hasError) {
              throw snapshot.error.toString();
            }
            return returnWidget;
          },
        );
      },
    );
  }
}
