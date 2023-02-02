import 'package:euk2_project/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:euk2_project/screens/app/list_screen.dart';
import 'package:euk2_project/screens/app/map_screen.dart';
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
              return const Placeholder();
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
            return const Placeholder();
          } else {
            return const MapScreen();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.read<ScreenNavigationBloc>().currentScreen.index,
        onTap: (index) => context.read<ScreenNavigationBloc>().add(OnSwitchPage(index)),
        selectedItemColor: Colors.amber[500],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_outlined),
            label: "List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
