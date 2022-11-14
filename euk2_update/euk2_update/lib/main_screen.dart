import 'package:euk2_project/navigation/app_navigator.dart';
import 'package:flutter/material.dart';

///Main Map Screen Widget
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final AppNavigator _navigator = AppNavigator(defaultPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navigator.currentAppBar,
      body:_navigator.currentBody,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navigator.screenIndex,
        onTap: (index) => setState(() => _navigator.navigate(index)),
        items:  const [
          BottomNavigationBarItem(icon: Icon(Icons.list), activeIcon: Icon(Icons.list_alt), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.map), activeIcon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), activeIcon: Icon(Icons.settings_applications), label: 'Nastavení'),
        ],
      ),
    );
  }
}
