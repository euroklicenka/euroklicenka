import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/preferences_model.dart';
import 'package:eurokey2/screens/app/list_screen.dart';
import 'package:eurokey2/screens/app/map_screen.dart';
import 'package:eurokey2/screens/app/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// The skeleton for the main pages of the app (List, Map, Options).
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.view_list_outlined),
            icon: Icon(Icons.view_list),
            label: "Seznam",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.map_outlined),
            icon: Icon(Icons.map),
            label: "Mapa",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.format_align_center),
            icon: Icon(Icons.format_list_bulleted),
            label: "Více",
          ),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: <Widget>[
          const AppBarListScreen(),
          const AppBarMapScreen(),
          const AppBarSettingsScreen(),
        ][currentPageIndex],
      ),
      body: <Widget>[
        const ListScreen(),
        const MapScreen(),
        const SettingsScreen(),
      ][currentPageIndex],
    );
  }
}
