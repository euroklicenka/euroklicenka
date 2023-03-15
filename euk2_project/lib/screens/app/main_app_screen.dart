import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:euk2_project/screens/app/list_screen.dart';
import 'package:euk2_project/screens/app/map_screen.dart';
import 'package:euk2_project/screens/app/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///The skeleton for the main pages of the app (List, Map, Options).
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: BlocBuilder<ScreenNavigationBloc, ScreenNavigationState>(
          builder: (context, state) {
            if (state is AppScreenMap) {
              return const AppBarMapScreen();
            } else if (state is AppScreenList) {
              return const AppBarListScreen();
            } else if (state is AppScreenOptions) {
              return const AppBarSettingsScreen();
            } else {
              return const MapScreen();
            }
          },
        ),
      ),
      body: BlocBuilder<ScreenNavigationBloc, ScreenNavigationState>(
        builder: (context, state) {
          if (state is AppScreenMap) {
            return const MapScreen();
          } else if (state is AppScreenList) {
            return const ListScreen();
          } else if (state is AppScreenOptions) {
            return const SettingsScreen();
          } else {
            return const MapScreen();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<ScreenNavigationBloc>().currentScreen.index,
        onTap: (index) {
          context.read<ScreenNavigationBloc>().add(OnSwitchPage(index));
          if (index == ScreenType.map.index) context.read<LocationManagementBloc>().add(OnFocusOnUserPosition());
        },
        selectedItemColor: Colors.amber[500],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            activeIcon: Icon(Icons.view_list_outlined),
            label: "List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            activeIcon: Icon(Icons.map_outlined),
            label: "Mapa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            activeIcon: Icon(Icons.format_align_center),
            label: "Více",
          ),
        ],
      ),
    );
  }
}
