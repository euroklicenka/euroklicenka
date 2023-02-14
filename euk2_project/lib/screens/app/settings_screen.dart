import 'package:flutter/material.dart';

///The Settings screen where the user can adjust various app settings
///or look up information.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Zatím žádná nastavení neexistují.'),
    );
  }
}

///The AppBar for the Settings Screen.
class AppBarSettingsScreen extends StatelessWidget {
  const AppBarSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Nastavení a Informace'),
      centerTitle: true,
    );
  }
}
