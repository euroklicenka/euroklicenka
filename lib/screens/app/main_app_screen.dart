// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/providers/preferences_provider.dart';
import 'package:eurokey2/screens/app/settings_screen.dart';
import 'package:eurokey2/screens/app/list_screen.dart';
import 'package:eurokey2/screens/app/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eurokey2/providers/location_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => MainAppScreenState();
}

class MainAppScreenState extends State<MainAppScreen> {
  Future<void> initialize(BuildContext context) async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    String deniedLocationServicesMessage =
        AppLocalizations.of(context)!.deniedLocationServicesMessage;
    String restrictedLocationServicesMessage =
        AppLocalizations.of(context)!.restrictedLocationServicesMessage;
    String permanentlyDeniedLocationServicesMessage =
        AppLocalizations.of(context)!.permanentlyDeniedLocationServicesMessage;
    String limitedLocationServicesMessage =
        AppLocalizations.of(context)!.limitedLocationServicesMessage;
    String provisionalLocationServicesMessage =
        AppLocalizations.of(context)!.provisionalLocationServicesMessage;

    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      // We haven't asked for permission yet or the permission has been denied before, but not permanently.
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isGranted) {
      // Either the permission was already granted before or the user just granted it.
      await locationProvider.getCurrentPosition().catchError((e) {
        showSnackBar(message: e.toString());
      });
    } else if (status.isDenied) {
      // The permission has been denied, but not permanently.
      showSnackBar(message: deniedLocationServicesMessage);
    } else if (status.isRestricted) {
      showSnackBar(message: restrictedLocationServicesMessage);
    } else if (status.isProvisional) {
      showSnackBar(message: provisionalLocationServicesMessage);
    } else if (status.isLimited) {
      showSnackBar(message: limitedLocationServicesMessage);
    } else if (status.isPermanentlyDenied) {
      showSnackBar(message: permanentlyDeniedLocationServicesMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize(context),
      builder: (context, snapshot) {
        return Consumer<PreferencesProvider>(
            builder: (context, sharedPreferencesProvider, child) {
          final int index;

          switch (sharedPreferencesProvider.mainScreenState) {
            case MainScreenStates.listScreenState:
              index = 0;
            case MainScreenStates.mapScreenState:
              index = 1;
            case MainScreenStates.aboutScreenState:
              index = 2;
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: index,
              children: <Widget>[
                const ListScreen(),
                MapScreen(),
                const SettingsScreen(),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (index) {
                final eurolockProvider =
                    Provider.of<EurolockProvider>(context, listen: false);
                eurolockProvider.cleanupCurrentEUK();
                switch (index) {
                  case 0:
                    sharedPreferencesProvider.mainScreenState =
                        MainScreenStates.listScreenState;
                  case 1:
                    sharedPreferencesProvider.mainScreenState =
                        MainScreenStates.mapScreenState;
                  case 2:
                    sharedPreferencesProvider.mainScreenState =
                        MainScreenStates.aboutScreenState;
                  default:
                    throw ("invalid state");
                }
              },
              // indicatorColor: Colors.amber,
              selectedIndex: index,
              destinations: <Widget>[
                NavigationDestination(
                  selectedIcon: const Icon(Icons.view_list_outlined),
                  icon: const Icon(Icons.view_list),
                  label: AppLocalizations.of(context)!.listLabel,
                ),
                NavigationDestination(
                  selectedIcon: const Icon(Icons.map_outlined),
                  icon: const Icon(Icons.map),
                  label: AppLocalizations.of(context)!.mapLabel,
                ),
                NavigationDestination(
                  selectedIcon: const Icon(Icons.format_align_center),
                  icon: const Icon(Icons.format_list_bulleted),
                  label: AppLocalizations.of(context)!.settingsLabel,
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
