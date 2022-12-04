import 'package:euk2_project/navigation/app_navigator.dart';
import 'package:flutter/material.dart';

///Main Map Screen Widget
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final AppNavigator _navigator = AppNavigator(defaultPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navigator.currentAppBar,
      body:_navigator.currentBody,
    );
  }
}
