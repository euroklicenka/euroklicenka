// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/providers/preferences_provider.dart';
import 'package:eurokey2/screens/app/information_screen.dart';
import 'package:eurokey2/screens/app/list_screen.dart';
import 'package:eurokey2/screens/app/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String listLabel() => Intl.message(
          'Seznam',
          name: 'MainAppScreen_listLabel',
        );

    String mapLabel() => Intl.message(
          'Mapa',
          name: 'MainAppScreen_mapLabel',
        );

    String aboutLabel() => Intl.message(
          'O aplikaci',
          name: 'MainAppScreen_aboutLabel',
        );

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
        default:
          index = 1;
      }

      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: index,
          children: <Widget>[
            const ListScreen(),
            MapScreen(),
            const InformationScreen(),
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
              label: listLabel(),
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.map_outlined),
              icon: const Icon(Icons.map),
              label: mapLabel(),
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.format_align_center),
              icon: const Icon(Icons.format_list_bulleted),
              label: aboutLabel(),
            ),
          ],
        ),
      );
    });
  }
}
