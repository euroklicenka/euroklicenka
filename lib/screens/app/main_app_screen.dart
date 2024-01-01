import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/screens/app/list_screen.dart';
import 'package:eurokey2/screens/app/map_screen.dart';
import 'package:eurokey2/screens/app/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: index,
        children: const <Widget>[
          ListScreen(),
          MapScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          final eukModel = Provider.of<EurolockModel>(context, listen: false);
          eukModel.cleanupCurrentEUK();
          context.go('/main/$index');
        },
        indicatorColor: Colors.amber,
        selectedIndex: index,
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
    );
  }
}
