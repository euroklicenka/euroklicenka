import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    
    //TODO Once the functionality is added, uncomment the buttons.
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        children: [
          // ListTile(
          //   onTap: () {},
          //   title: const Text("Informace o aplikaci"),
          //   leading: const Icon(Icons.bookmarks_outlined),
          //   // tileColor: Colors.amber,
          // ),
          // const DividerOptions(),
          ListTile(
            onTap: () {
              context.read<MainScreenBloc>().add(OnOpenGuideScreen());
            },
            title: const Text("Průvodce"),
            leading: const Icon(Icons.rocket_launch),
            // tileColor: Colors.amber,
          ),
          const DividerOptions(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<LocationManagementBloc>().add(OnLoadLocationsFromDatabase());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    backgroundColor: Colors.deepOrangeAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Aktualizace databáze'),
                ),
              ),
            ),
          ),
        ],
      ),
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

class DividerOptions extends StatelessWidget {
  const DividerOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      indent: 10,
      endIndent: 10,
    );
  }
}
