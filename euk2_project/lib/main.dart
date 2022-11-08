import 'package:euk2_project/main_screen.dart';
import 'package:euk2_project/pages/list_page.dart';
import 'package:euk2_project/pages/map_page.dart';
import 'package:euk2_project/pages/settings_page.dart';
import 'package:euk2_project/themes/theme_collection.dart';
import 'package:euk2_project/themes/theme_manager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeManager _themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: yellowTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: const MainScreen(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [
    MapPage(),
    ListPage(),
    SettingsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        height: 60,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined, size: 35 ),
            selectedIcon: Icon(Icons.map, size: 35),
            label: "Mapa"),
          NavigationDestination(
              icon: Icon(Icons.list, size: 35),
              selectedIcon: Icon(Icons.list_alt, size: 35),
              label: "List"),
          NavigationDestination(
              icon: Icon(Icons.settings, size: 35),
              selectedIcon: Icon(Icons.settings_applications, size: 35),
              label: "Nastavení")
        ],
        onDestinationSelected: (int index){
          setState((){
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
