// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/screens/app/information_screen.dart';
import 'package:eurokey2/screens/app/list_screen.dart';
import 'package:eurokey2/screens/app/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MainAppScreen extends StatelessWidget {
  final String id;

  const MainAppScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final int index = int.parse(id);

    if (index < 0 || index >= 3) {
      // Just in case someone tries to pass an invalid index in the url.
      GoRouter.of(context).go('/');
      return const SizedBox.shrink();
    }

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
          context.go('/main/$index');
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
  }
}
